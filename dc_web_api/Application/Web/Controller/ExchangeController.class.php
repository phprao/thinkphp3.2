<?php
/**
 +---------------------------------------------------------- 
 * date: 2018-05-28 20:28:03
 +---------------------------------------------------------- 
 * author: Raoxiaoya
 +---------------------------------------------------------- 
 * describe: 兑换优惠券
 +---------------------------------------------------------- 
 */
namespace Web\Controller;

class ExchangeController extends BaseController {

    protected $exchange_max = 200;

    protected function _initialize()
    {
        
    }

    /**
     * 微信授权
     * @return [type] [description]
     */
    public function index(){
        $shop_id_str = I('get.shop_id');
        $shop_id = think_decrypt($shop_id_str, 'dc_shop_exchange');
        if (!$shop_id) {
            echo "<script type='text/javascript'>alert('参数错误')</script>";
            exit;
        }
        $redirect_uri =  U(C('WEIXIN_SHOP_EXCHANGE_URL'), ['shop_id'=>$shop_id_str], true, true);
        $auth = $this->wxAuth($redirect_uri);
        if($auth['status']){
            header('Location:'.C('WEIXIN_SHOP_EXCHANGE_PAGE_URL') . '?shop_id='.$shop_id_str.'&code=' . $auth['msg']);
        }else{
            echo "<script type='text/javascript'>alert('".$auth['msg']."')</script>";
            exit;
        }
    }

    /**
     * 获取用户信息及加入的电玩厅列表
     * @return [type] [description]
     */
    public function getWxUser(){
        $shop_id_str = I('get.shop_id');
        $shop_id = think_decrypt($shop_id_str, 'dc_shop_exchange');
        if (!$shop_id) {
            return $this->responseJsonError(10000, '参数错误');
        }

        $SBCM  = M('shop_bind_club');

        // 校验商家
        $bindInfo = $SBCM->where(['shop_id'=>$shop_id, 'status'=>4])->find();
        if(empty($bindInfo)){
            return $this->responseJsonError(10000, '该店铺不存在或审核未通过');
        }
        $bindInfo['shop_id_str'] = $shop_id_str;

        // 校验玩家
        $code = I('get.code');
        $info = $this->getWxUserInfoByCode($code);
        
        // $info = [
        //     'status'=>true,
        //     'msg'=>['openid'=>'raoxiaoya_test_8888','unionid'=>'test_unionid_8888']
        // ];
        
        if(!$info['status']){
            return $this->responseJsonError(isset($info['errcode']) ? $info['errcode'] : 10000, $info['msg']);
        }
        $userInfo = $info['msg'];
        
        $PM  = M('player');
        $CIM = M('club_info');

        $player = $PM->where(['player_unionid'=>$userInfo['unionid']])->find();
        if(empty($player)){
            return $this->responseJsonError(10001, '对不起，您还不是平台玩家，请先下载游戏。');
        }
        if($player['player_status'] == 0){
            return $this->responseJsonError(10001, '对不起，您已被拉黑。');
        }
        if(!$player['player_openid_gzh']){
            $PM->where(['player_id'=>$player['player_id']])->save(['player_openid_gzh'=>$userInfo['openid']]);
        }
        $userInfo['player_id'] = $player['player_id'];

        // 玩家俱乐部信息
        $clubPlayer = $this->getClubPlayerInfo($player['player_id'], $bindInfo['club_id']);
        if(empty($clubPlayer)){
            return $this->responseJsonError(10001, '对不起，您还未绑定该俱乐部。');
        }

        // 俱乐部信息
        $club_info = $CIM->where(['club_id'=>$bindInfo['club_id']])->find();
        if(empty($club_info)){
            return $this->responseJsonError(10001, '对不起，该俱乐部不存在。');
        }
        if($club_info['club_status'] == 0){
            return $this->responseJsonError(10001, '对不起，该俱乐部已关闭。');
        }

        // 系统上限配置
        $config = M('config')->where(['config_name'=>'shop_exchange_config', 'config_status'=>1])->find();
        if(empty($config)){
            $max_money = $this->exchange_max;
        }else{
            $temp = json_decode($config['config_config'], true);
            $max_money = $temp['max_money'];
        }
        
        $user_money = cutDataByLen($clubPlayer['player_lottery'] / $club_info['club_lottery_rate'], 2);
        
        $data = [
            'userInfo'    => $userInfo, 
            'bindInfo'    => $bindInfo,
            'detail'      => ['max_money'=>$max_money, 'user_money'=>$user_money],
            'club_player' => $clubPlayer
        ];

        session('ExchangeUser', json_encode($data));

        return $this->responseJsonSuccess($data);
        
    }

    /**
     * 兑换
     * @return [type] [description]
     */
    public function apply(){
        $sess_info = json_decode(session('ExchangeUser'),true);
        if(empty($sess_info)){
            return $this->responseJsonError(402, '非法请求，请重新进入');
        }

        $money = I('post.money');

        if(!preg_match("/^[0-9]{1,11}$/", $money)){
            return $this->responseJsonError(10000, '参数格式错误');
        }
        $money = (int)$money;
        if($money < 1){
            return $this->responseJsonError(10000, '请输入大于1的整数');
        }

        $SBCM  = M('shop_bind_club');
        // 校验商家
        $bindInfo = $SBCM->where(['shop_id'=>$sess_info['bindInfo']['shop_id'], 'status'=>4])->find();
        if(empty($bindInfo)){
            return $this->responseJsonError(10000, '该店铺不存在或审核未通过');
        }

        // 是否超过上限
        $config = M('config')->where(['config_name'=>'shop_exchange_config', 'config_status'=>1])->find();
        if(empty($config)){
            $max_money = $this->exchange_max;
        }else{
            $temp = json_decode($config['config_config'], true);
            $max_money = $temp['max_money'];
        }
        if($money > $max_money){
            return $this->responseJsonError(10000, '输入的数值不能大于'.$max_money);
        }

        $SELM = M('shop_exchange_lottery');
        $BLM  = M('wx_bonus_log');
        $CIM  = M('club_info');

        M()->startTrans();

        // 彩票数是否足够
        $club_info = $CIM->lock(true)->where(['club_id'=>$sess_info['bindInfo']['club_id']])->find();
        
        if(empty($club_info)){
            M()->rollback();
            return $this->responseJsonError(10001, '对不起，该俱乐部不存在。');
        }
        if($club_info['club_status'] == 0){
            M()->rollback();
            return $this->responseJsonError(10001, '对不起，该俱乐部已关闭。');
        }
        // 俱乐部金额是否足够
        if($club_info['club_residue_money'] < $money){
            M()->rollback();
            return $this->responseJsonError(10001, '对不起，该俱乐部余额不足。');
        }else{
            $r0 = $CIM->where(['club_id'=>$sess_info['bindInfo']['club_id']])->setDec('club_residue_money', $money);
            if($r0 === false){
                M()->rollback();
                return $this->responseJsonError(10003, '俱乐部扣款失败');
            }
            $log = [
                'club_id'          => $sess_info['bindInfo']['club_id'],
                'club_player_id'   => $sess_info['userInfo']['player_id'],
                'club_bef_amount'  => $club_info['club_residue_money'],
                'club_amount'      => -$money,
                'club_aft_amount'  => $club_info['club_residue_money'] - $money,
                'club_change_type' => 2,
                'club_create_time' => time()
            ];
            M('club_amount_record')->add($log);
        }

        // 需要的彩票数
        $need_lottery = $money * $club_info['club_lottery_rate'];

        // 玩家俱乐部信息
        $clubPlayer = $this->getClubPlayerInfo($sess_info['club_player']['player_id'], $sess_info['club_player']['club_id']);
        if(empty($clubPlayer)){
            M()->rollback();
            return $this->responseJsonError(10001, '对不起，您还未绑定该俱乐部。');
        }
        if($clubPlayer['player_lottery'] < $need_lottery){
            M()->rollback();
            return $this->responseJsonError(10001, '对不起，您在该俱乐部的电子卡余额不足。');
        }

        $r1 = $this->updateClubPlayer($sess_info['club_player']['player_id'], $sess_info['club_player']['club_id'], $need_lottery);
        if($r1 === false){
            M()->rollback();
            return $this->responseJsonError(10003, '扣款失败');
        }

        $r2 = $BLM->add([
            'type_id'      =>1,
            'receiver_id'  =>$sess_info['bindInfo']['shop_id'],
            'openid'       =>$sess_info['bindInfo']['openid'],
            'unionid'      =>$sess_info['bindInfo']['unionid'],
            'mch_billno'   =>createOrderId(32),
            'total_amount' =>$money,
            'create_time'  =>time(),
            'create_date'  =>date('Y-m-d H:i:s')
        ]);

        // 校验成功
        $r3 = $SELM->add([
            'shop_id'           =>$sess_info['bindInfo']['shop_id'],
            'club_id'           =>$sess_info['bindInfo']['club_id'],
            'player_id'         =>$sess_info['userInfo']['player_id'],
            'cost_type'         =>1,
            'cost_value'        =>$need_lottery,
            'cost_before'       =>$clubPlayer['player_lottery'],
            'cost_after'        =>$clubPlayer['player_lottery'] - $need_lottery,
            'get_type'          =>1,
            'get_type_value'    =>$money,
            'get_type_id'       =>$r2,
            'club_lottery_rate' =>$club_info['club_lottery_rate'],
            'create_time'       =>time(),
            'create_date'       =>date('Y-m-d H:i:s')
        ]);
        if($r2 && $r3){
            M()->commit();
            $ret = $this->sendWxBonus($r2);
            if(!$ret['status']){
                \Think\Log::write('[ exchange ] : 红包发送失败 | id = ' . $r2 . ' | ' . $ret['msg'], 'ERR');
            }
            return $this->responseJsonSuccess();
        }else{
            \Think\Log::write("[ exchange ]：r1=$r1, $r2=$r2, r3=$r3","INFO");
            M()->rollback();
            $this->changeClubPlayer($sess_info['club_player']['player_id'], $sess_info['club_player']['club_id'], $need_lottery);
            return $this->responseJsonError(10003, '更新失败');
        }
        
    }

    /**
     * 换算成彩票数
     * @return [type] [description]
     */
    public function getLottery(){
        $sess_info = json_decode(session('ExchangeUser'),true);
        if(empty($sess_info)){
            return $this->responseJsonError(402, '非法请求，请重新进入');
        }

        $money = I('get.money');

        if(!preg_match("/^[0-9]{1,11}$/", $money)){
            return $this->responseJsonError(10000, '参数格式错误');
        }
        $money = (int)$money;
        if($money < 1){
            return $this->responseJsonError(10000, '请输入大于1的整数');
        }

        $CIM  = M('club_info');
        // 彩票数是否足够
        $club_info = $CIM->where(['club_id'=>$sess_info['bindInfo']['club_id']])->find();
        if(empty($club_info)){
            return $this->responseJsonError(10001, '对不起，该俱乐部不存在。');
        }
        if($club_info['club_status'] == 0){
            return $this->responseJsonError(10001, '对不起，该俱乐部已关闭。');
        }
        // 需要的彩票数
        $need_lottery = $money * $club_info['club_lottery_rate'];
        return $this->responseJsonSuccess(['need_lottery'=>$need_lottery, 'money'=>$money]);
    }

    /**
     * 微信红包回调处理
     * @return [type] [description]
     */
    public function notifyAction()
    {
        $postData = $_POST;
        // \Think\Log::write('[ notifyAction ] : ' . json_encode($postData),"INFO");
        // {"order_id":"d602afc62fcc6129ce07e5c144af10","status":"2","send_config":"king"}
        $BLM  = M('wx_bonus_log');

        $info = $BLM->where(['mch_billno' => $postData['order_id']])->find();
        $re = true;
        if ($info) {

            if ($postData['status'] == 2 && $info['status'] != 2) {
                // 已发放待领取 
                $re = $BLM->where(['id' => $info['id']])->save(['send_time' => date('Y-m-d H:i:s'), 'status' => 2]);
            }
            if ($postData['status'] == 4 && $info['status'] != 4) {
                // 已领取
                $re = $BLM->where(['id' => $info['id']])->save(['receive_time' => date('Y-m-d H:i:s'), 'status' => 4]);
            }
            if ($postData['status'] == 6 && $info['status'] != 6) {
                // 已退款,暂不处理
                $re = $BLM->where(['id' => $info['id']])->save(['refund_time' => date('Y-m-d H:i:s'), 'status' => 6]);
            }

        }
        if ($re !== false) {
            echo 'success';
        } else {
            echo 'fail';
        }
    }

    // 发送红包 - 防止返回信息编码有误
    protected function sendWxBonus($id){
        $bonusModel = new \Web\Lib\Service\WxBonus();
        $return = $bonusModel->sendBonus($id);
        if ($return && $return['status'] == 'success' && $return['data']['return_code'] == 'SUCCESS' && $return['data']['result_code'] == 'SUCCESS') {
            $update = [
                'status'      => 2,
                'send_listid' => $return['data']['send_listid'],
                'send_time'   => date('Y-m-d H:i:s')
            ];
            $ret = M('wx_bonus_log')->where(['id'=>$id])->save($update);
        } else {
            $ret = false;
            $error = isset($return['errorMsg']) ? $return['errorMsg'] : '无信息返回';
        }
        if ($ret) {
            return ['status'=>true, 'msg'=>''];
        } else {
            return ['status'=>false, 'msg'=>$error];
        }
    }

    protected function getClubPlayerInfo($player_id, $club_id){
        $redis = new \Web\Lib\Redis\PlayerRedis(['table' => 'club_user', 'club_id'=>$club_id]);
        $exists = $redis->exists($player_id);
        if($exists){
            $club_player = $redis->hgetall($player_id);
        }else{
            $CPM = M('club_player');
            $club_player = $CPM->lock(true)->where(['club_id'=>$club_id, 'player_id'=>$player_id])->find();
        }

        return $club_player;
    }

    protected function updateClubPlayer($player_id, $club_id, $player_lottery){
        $redis = new \Web\Lib\Redis\PlayerRedis(['table' => 'club_user', 'club_id'=>$club_id]);
        $exists = $redis->exists($player_id);
        if($exists){
            $r1 = $redis->hdecrby($player_id, 'player_lottery', $player_lottery);
        }else{
            $CPM = M('club_player');
            $r1 = $CPM->where(['club_id'=>$club_id, 'player_id'=>$player_id])->setDec('player_lottery', $player_lottery);
        }

        return $r1;
    }

    protected function changeClubPlayer($player_id, $club_id, $player_lottery){
        $redis = new \Web\Lib\Redis\PlayerRedis(['table' => 'club_user', 'club_id'=>$club_id]);
        $exists = $redis->exists($player_id);
        if($exists){
            $r1 = $redis->hincrby($player_id, 'player_lottery', $player_lottery);
        }

        return $r1;
    }




    public function test(){
        
    }

}