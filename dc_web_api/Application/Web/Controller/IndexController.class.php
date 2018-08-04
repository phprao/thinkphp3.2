<?php
/**
 +---------------------------------------------------------- 
 * date: 2018-05-28 20:28:03
 +---------------------------------------------------------- 
 * author: Raoxiaoya
 +---------------------------------------------------------- 
 * describe: 微信公众号充值
 +---------------------------------------------------------- 
 */
namespace Web\Controller;

class IndexController extends BaseController {

    protected function _initialize()
    {
        
    }

    /**
     * 微信授权
     * @return [type] [description]
     */
    public function index(){
        $redirect_uri =  U(C('WEIXIN_CHARGE_REDIRECT_URL'), [], true, true);
        $auth = $this->wxAuth($redirect_uri);
        if($auth['status']){
            header('Location:'.C('WEIXIN_CHARGE_PAGE_URL') . '?code=' . $auth['msg']);
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
        // http://localhost/dc_php_xingyun/trunk/dc_web/Index/getWxUser
        
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
        $CPM = M('club_player');
        $CIM = M('club_info');
        // 校验用户信息
        $player = $PM->where(['player_unionid'=>$userInfo['unionid']])->field('player_id,player_openid_gzh')->find();
        if(empty($player)){
            return $this->responseJsonError(10001, '对不起，您还不是平台玩家，请先下载游戏。');
        }
        if(!$player['player_openid_gzh']){
            $PM->where(['player_id'=>$player['player_id']])->save(['player_openid_gzh'=>$userInfo['openid']]);
        }
        $userInfo['player_id'] = $player['player_id'];

        // 电玩厅信息
        $club = [];
        $clubPlayer = $CPM->where(['player_id'=>$player['player_id']])->select();
        if(empty($clubPlayer)){
            return $this->responseJsonError(10001, '对不起，您还没有绑定任何电玩厅。');
        }
        foreach($clubPlayer as $key => $val){
            $temp = $CIM->where(['club_id'=>$val['club_id'],'club_status'=>1])->field('club_id,club_name')->find();
            if(!empty($temp)){
                array_push($club, $temp);
            }
        }

        if(empty($club)){
            return $this->responseJsonError(10001, '对不起，您所绑定的电玩厅不存在或禁用。');
        }

        $data = ['userInfo'=>$userInfo, 'club'=>$club];

        session('WxUser', json_encode($data));

        // 刷新实体卡信息
        $this->flushClubCardInfo($userInfo['player_id']);

        return $this->responseJsonSuccess($data);
        
    }

    /**
     * 通过电玩厅id获取信息
     * @return [type] [description]
     */
    public function changeClub(){
        // http://localhost/dc_php_xingyun/trunk/dc_web/Index/changeClub?club_id=1&player_id=1096611
        $club_id   = I('get.club_id');
        $player_id = I('get.player_id');
        if(!$club_id || !$player_id){
            return $this->responseJsonError(10000, '参数错误。');
        }

        $CPM = M('club_player');
        $CIM = M('club_info');
        $PM  = M('player');

        // 校验用户信息
        $player = $PM->where(['player_id'=>$player_id])->find();
        if(empty($player)){
            return $this->responseJsonError(10001, '对不起，您还不是平台玩家。');
        }

        $clubPlayer = $CPM->where(['player_id'=>$player_id, 'club_id'=>$club_id])->find();
        if(empty($clubPlayer)){
            return $this->responseJsonError(10001, '玩家未绑定该电玩厅。');
        }

        $club = $CIM->where(['club_id'=>$club_id,'club_status'=>1])->find();
        if(empty($club)){
            return $this->responseJsonError(10001, '该电玩厅不存在或禁用。');
        }

        // 卡信息
        $card = $this->getCardByClub($club_id, $player_id);
        if(empty($card)){
            return $this->responseJsonError(10001, '对不起，您在该电玩厅的卡信息不存在。');
        }

        return $this->responseJsonSuccess(['card'  =>$card]);
    }

    public function getGoods(){
        $club_id    = I('get.club_id');
        $type_id    = I('get.type_id');// 1-余额，4-代币

        if(!checkString($club_id, 4)){
            return $this->responseJsonError(10000, '电玩厅参数错误。');
        }
        if(!checkString($type_id, 4)){
            return $this->responseJsonError(10000, '商品类型参数错误。');
        }

        $goods = $this->getClubGoods($club_id, $type_id);
        return $this->responseJsonSuccess(['goods' =>$goods]);
    }

    public function getUserInfo(){
        $club_id    = I('get.club_id');
        $player_id  = I('get.player_id');
        $card_value = I('get.card_value');

        $info = $this->checkCardAndUser($club_id, $player_id, $card_value);

        if($info){
            return $this->responseJsonSuccess(['info' =>$info]);
        }else{
            return $this->responseJsonError(10001, '请求参数不匹配。');
        }
    }

    /**
     * 余额充值下单（电子卡，实体卡）
     * @return [type] [description]
     */
    public function orderAmount(){
        $sess_info = json_decode(session('WxUser'),true);
        if(empty($sess_info)){
            return $this->responseJsonError(402, '非法请求，请重新进入');
        }

        $info = $this->preOrder(1);
        
        // 统一下单
        $re = $this->submitOrderInfo($info);

        if(!$re['status']){
            return $this->responseJsonError(10001, $re['msg']);
        }else{
            return $this->responseJsonSuccess(['msg'=>$re['msg'],'order_id'=>$re['order_id']]);
        }

    }

    /**
     * 换代币
     * @return [type] [description]
     */
    public function exchangeCoin(){
        $sess_info = json_decode(session('WxUser'),true);
        if(empty($sess_info)){
            return $this->responseJsonError(402, '非法请求，请重新进入');
        }

        M()->startTrans();

        $info = $this->preOrder(2);

        if($info['from_card_type'] == 1){
            $re = $this->doExchangeToken($info);
        }
        if($info['from_card_type'] == 2){
            // 请求换代币
            $re = $this->requestExchangeToken($info);
        }

        if($re['status']){
            M()->commit();
            return $this->responseJsonSuccess(['from_card_type'=>$info['from_card_type'], 'order_id'=>$info['order_id']]);
        }else{
            M()->rollback();
            return $this->responseJsonError(10001, $re['msg']);
        }
        
    }

    public function syncPayOrder(){
        $sess_info = json_decode(session('WxUser'),true);
        if(empty($sess_info)){
            return $this->responseJsonError(402, '非法请求，请重新进入');
        }

        $order_id    = I('get.order_id');
        $order_info = M('order_log')->where(['order_id'=>$order_id])->find();
        if(empty($order_info)){
            return $this->responseJsonSuccess(['status'=>404]);
        }

        if($order_info['order_is_send'] != 1){
            return $this->responseJsonSuccess(['status'=>400]);
        }

        if($order_info['order_sync_status'] == 2){
            return $this->responseJsonSuccess(['status'=>0]);
        }else{
            return $this->responseJsonSuccess(['status'=>300]);
        }
    }

    public function syncExchangeOrder(){
        $sess_info = json_decode(session('WxUser'),true);
        if(empty($sess_info)){
            return $this->responseJsonError(402, '非法请求，请重新进入');
        }

        $order_id    = I('get.order_id');
        $order_info = M('money_to_token_log')->where(['order_id'=>$order_id])->find();
        if(empty($order_info)){
            return $this->responseJsonSuccess(['status'=>404]);
        }
        if($order_info['status'] == 3){
            return $this->responseJsonSuccess(['status'=>0]);
        }else{
            return $this->responseJsonSuccess(['status'=>300]);
        }
    }

    protected function preOrder($type){
        $club_id    = I('post.club_id');
        $card_value = I('post.card_value');
        $player_id  = I('post.player_id');
        $goods_id   = I('post.goods_id');
        $openid     = I('post.openid');
        $is_user    = I('post.is_user') ? 1 : 0;// 是否自定义
        $amount     = I('post.amount');// 自定义数量

        // 校验卡片关联关系
        if(!$cardInfo = $this->checkCardAndUser($club_id, $player_id, $card_value)){
            return $this->responseJsonError(10001, '请求参数不匹配。');
        }

        $card = explode('-', $card_value);
        if($card[0] == 1){
            $card_type = 1;// 电子卡  id
        }elseif($card[0] == 2){
            $card_type = 2;// 实体卡  club_card_id
        }

        // 校验俱乐部与商品
        $GIM = M('goods_info');
        $goods = $GIM->where(['goods_id'=>$goods_id, 'goods_club_id'=>$club_id, 'goods_status'=>1])->find();
        if(empty($goods)){
            $goods = $GIM->where(['goods_id'=>$goods_id, 'goods_club_id'=>0, 'goods_status'=>1])->find();
            if(empty($goods)){
                return $this->responseJsonError(10001, '商品参数不匹配。');
            }
        }

        // 参数校验
        $is_user = 0;
        if($is_user){
            // 自定义数量
            // if(checkString($amount, 4)){
            //     $goods_id        = 0;
            //     $goods_get_price = $amount;
            //     $goods_price     = 0;
            //     $total_fee       = (int)($goods['goods_price']);
            // }else{
            //     return $this->responseJsonError(10000, '输入参数错误。');
            // }
        }else{
            // goods_id
            $goods_get_price = $goods['goods_get_price'];
            $goods_price     = $goods['goods_price'];// 分
            $total_fee       = $goods['goods_price'];// 分
        }

        if($type == 1){
            $info = array(
                'out_trade_no'          => createOrderId(),
                'body'                  => $goods['goods_name'],
                'total_fee'             => $total_fee,// 分
                'openid'                => $openid,
                'player_id'             => $player_id,
                'club_id'               => $club_id,
                'goods_id'              => $goods_id,
                'goods_price'           => $goods_price,
                'get_type'              => 1,// 余额
                'goods_get_price'       => $goods_get_price,
                'order_club_card_type'  => $card_type,
                'order_club_card_value' => $card[1]
            );
            // 生成订单信息
            $re = $this->createOrder($info);
        }
        if($type == 2){
            $club_player = $this->getClubPlayerInfo($player_id, $club_id, $card[1]);
            $goods = M('goods_info')->where(['goods_id'=>$goods_id])->find();
            $info = [
                'player_id'      => $player_id,
                'club_id'        => $club_id,
                'from_card_type' => $card_type,
                'from_card_id'   => $card[1],
                'to_card_type'   => 1,
                'to_card_id'     => $club_player['id'], 
                'goods_id'       => $goods_id,
                'from_value'     => $goods['goods_price'],
                'to_value'       => $goods['goods_get_price'],
                'before_value'   => $club_player['player_tokens'],
                'after_value'    => $club_player['player_tokens'] + $goods['goods_get_price'],
                'app_id'         => $cardInfo['club_card_app_id']
            ];
            $re = $this->createExchangeOrder($info);
        }
        
        if(!$re){
            return $this->responseJsonError(10001, '订单表写入失败。');
        }
        $info['order_id'] = $re;

        return $info;
    }

    protected function checkCardAndUser($club_id, $player_id, $card_value){
        if(!checkString($club_id, 4)){
            return $this->responseJsonError(10000, '电玩厅参数错误。');
        }
        if(!checkString($card_value, 2)){
            return $this->responseJsonError(10000, '卡参数错误。');
        }else{
            $card = explode('-', $card_value);
            if($card[0] == 1){
                $card_type = 1;// 电子卡  id
            }elseif($card[0] == 2){
                $card_type = 2;// 实体卡  club_card_id
            }else{
                return $this->responseJsonError(10000, '卡参数错误。');
            }

            $card_id = $card[1];
        }
        if(!checkString($player_id, 4)){
            return $this->responseJsonError(10000, '玩家参数错误。');
        }

        $CPM = M('club_player');
        $CIM = M('club_info');
        $PM  = M('player');
        $CCM = M('club_card');

        $player = $PM->where(['player_id'=>$player_id])->find();
        if(empty($player)){
            return $this->responseJsonError(10001, '对不起，您还不是平台玩家。');
        }
        $clubPlayer = $CPM->where(['player_id'=>$player_id, 'club_id'=>$club_id])->find();
        if(empty($clubPlayer)){
            return $this->responseJsonError(10001, '玩家未绑定该电玩厅。');
        }

        $club = $CIM->where(['club_id'=>$club_id,'club_status'=>1])->find();
        if(empty($club)){
            return $this->responseJsonError(10001, '该电玩厅不存在或禁用。');
        }

        // 校验卡片信息
        if($card_type == 1){
            $info = $this->getClubPlayerInfo($player_id, $club_id, $card_id);
        }
        if($card_type == 2){
            $info = $CCM->where(['club_card_status'=>2, 'club_card_id'=>$card_id,'club_card_player_id'=>$player_id,'club_card_club_id'=>$club_id])->find();
        }

        return $info;
    }

    /**
     * 获取电子卡信息
     * @return [type] [description]
     */
    protected function getClubPlayerInfo($player_id, $club_id, $card_id){
        $redis = new \Web\Lib\Redis\PlayerRedis(['table' => 'club_user', 'club_id'=>$club_id]);
        $exists = $redis->exists($player_id);
        if($exists){
            $data = $redis->hgetall($player_id);
            $info = [
                'id'                 =>$data['id'] ? $data['id'] : 0,
                'club_id'            =>$data['club_id'] ? $data['club_id'] : 0,
                'player_id'          =>$data['player_id'] ? $data['player_id'] : 0,
                'player_tokens'      =>$data['player_tokens'] ? $data['player_tokens'] : 0,
                'player_lottery'     =>$data['player_lottery'] ? $data['player_lottery'] : 0,
                'player_amount'      =>$data['player_amount'] ? $data['player_amount'] : 0,
                'player_zombie_coin' =>$data['player_zombie_coin'] ? $data['player_zombie_coin'] : 0,
                'join_time'          =>$data['join_time'] ? $data['join_time'] : 0
            ];
        }else{
            $info = M('club_player')->where(['club_id'=>$club_id,'player_id'=>$player_id,'id'=>$card_id])->find();
        }

        return $info;
    }

    /**
     * 根据电玩厅id获取会员卡信息
     * @param  [type] $club_id   [description]
     * @param  [type] $player_id [description]
     * @return [type]            [description]
     */
    protected function getCardByClub($club_id, $player_id){
        $CPM = M('club_player');
        $CCM = M('club_card');
        $card = [];
        $clubPlayer = $CPM->where(['player_id'=>$player_id, 'club_id'=>$club_id])->field('id')->find();
        if(empty($clubPlayer)){
            return $card;
        }else{
            $clubPlayer['name'] = '线上电子卡';
            $clubPlayer['value'] = '1-' . $clubPlayer['id']; // 电子卡
            unset($clubPlayer['id']);
            array_push($card, $clubPlayer);
        }

        $clubCard = $CCM->where(['club_card_club_id'=>$club_id,'club_card_status'=>2,'club_card_player_id'=>$player_id])
                        ->field('club_card_id,club_card_member_no')
                        ->select();
        foreach ($clubCard as $value) {
            $temp = ['name'=>'实体卡：'.$value['club_card_member_no'], 'value'=>'2-'.$value['club_card_id']];// 实体卡
            array_push($card, $temp);
        }

        return $card;

    }

    /**
     * 获取电玩厅商品列表
     * @param  [type]  $club_id 电玩厅id
     * @param  integer $type    商品类型：1余额，4代币
     * @return [type]           [description]
     */
    protected function getClubGoods($club_id, $type = 1){
        $goods = [];
        $GIM = M('goods_info');
        if(!in_array($type, [1,4])){
            return $goods;
        }

        $goods = $GIM->where(['goods_type'=>$type, 'goods_club_id'=>$club_id, 'goods_status'=>1])
                     ->field('goods_id,goods_name,goods_price,goods_get_price')
                     ->select();
        if(empty($goods)){
            $goods = $GIM->where(['goods_type'=>$type, 'goods_club_id'=>0, 'goods_status'=>1])
                     ->field('goods_id,goods_name,goods_price,goods_get_price')
                     ->select();
        }

        // 价格换成标准显示
        if($goods){
            foreach($goods as $key => $val){
                $goods[$key]['goods_price'] = cutDataByLen($val['goods_price'] / 100);
            }
        }

        return $goods;

    }

    /**
     * 提交订单信息
     */
    protected function submitOrderInfo($data){
        import('Web.Lib.wxpay_gzh_ext.JsApiPay');
        $tools = new \JsApiPay();
        $input = new \WxPayUnifiedOrder();

        $input->SetAppid( C('APPID') );
        $input->SetMch_id( C('MCHID') );
        $input->SetBody( $data['body'] );
        $input->SetAttach( "nothing" );
        $input->SetOut_trade_no( $data['out_trade_no'] );
        $input->SetTotal_fee( $data['total_fee'] );
        $input->SetNotify_url( U(C('WEIXIN_CHARGE_NOTIFY_URL'), [], true, true) );
        $input->SetTrade_type( "JSAPI" );
        $input->SetOpenid( $data['openid'] );
        $order = \WxPayApi::unifiedOrder( $input );

        // \Think\Log::write(json_encode($order),'INFO');

        if(!$order || $order['result_code'] != 'SUCCESS' || $order['return_code'] != 'SUCCESS'){
            return ['status'=>false, 'msg'=>'下单失败：return_code:'.$order['return_code'].' return_msg:'.$order['return_msg']];
        }else{
            $jsApiParameters = $tools->GetJsApiParameters($order);
            return ['status'=>true, 'msg'=>$jsApiParameters, 'order_id'=>$data['order_id']];
        }
        
    }

    protected function submitOrderCard($data){

    }
    
    /**
     * 生成订单
     */
    protected function createOrder($info){
        $data_log = [
            'order_player_id'       => $info['player_id'],
            'order_club_id'         => $info['club_id'],
            'order_goods_id'        => $info['goods_id'],
            'order_price'           => $info['goods_price'],
            'order_get_type'        => $info['get_type'],
            'order_get_price'       => $info['goods_get_price'],
            'order_pay_type'        => 0, // 未知
            'order_is_send'         => 0,
            'order_orderno'         => $info['out_trade_no'],
            'order_create_time'     => time(),
            'order_update_time'     => time(),
            'order_pay_channel'     => 6, // 公众号支付
            'order_club_card_type'  => $info['order_club_card_type'],
            'order_club_card_value' => $info['order_club_card_value']
        ];
        
        $re = M('order_log')->add($data_log);
        if(!$re){
            return false;
        }

        return $re;
    }

    protected function createExchangeOrder($info){
        $data_log = [
            'player_id'      => $info['player_id'],
            'club_id'        => $info['club_id'],
            'from_card_type' => $info['from_card_type'],
            'from_card_id'   => $info['from_card_id'],
            'to_card_type'   => $info['to_card_type'],
            'to_card_id'     => $info['to_card_id'], // 未知
            'goods_id'       => $info['goods_id'],
            'from_value'     => $info['from_value'],
            'to_value'       => $info['to_value'],
            'before_value'   => $info['before_value'],
            'after_value'    => $info['after_value'],
            'create_time'    => time(),
            'create_date'    => date('Y-m-d H:i:s')
        ];
        
        $re = M('money_to_token_log')->add($data_log);
        if(!$re){
            return false;
        }

        return $re;
    }

    protected function doExchangeToken($info){
        $redis = new \Web\Lib\Redis\PlayerRedis(['table' => 'club_user', 'club_id'=>$info['club_id']]);
        $exists = $redis->exists($info['player_id']);
        if($exists){
            $data = $redis->hgetall($info['player_id']);
            if($data['player_amount'] * 100 < $info['from_value']){
                $r1 = $r2 = false;
                $msg = '电子卡余额不足';
            }else{
                $r1 = $redis->hdecrby($info['player_id'], 'player_amount', (int)($info['from_value']/100));
                // $r1返回剩余的数,可能是0
                $r2 = $redis->hincrby($info['player_id'], 'player_tokens', $info['to_value']);
            }
        }else{
            $CPM = M('club_player');
            $club_player = $CPM->lock(true)->where('id = '.$info['from_card_id'])->find();
            if($club_player['player_amount'] * 100 < $info['from_value']){
                $r1 = $r2 = false;
                $msg = '电子卡余额不足';
            }else{
                $r1 = $CPM->where('id = '.$info['from_card_id'])->setDec('player_amount',(int)($info['from_value']/100));
                $r2 = $CPM->where('id = '.$info['from_card_id'])->setInc('player_tokens',$info['to_value']);
            }
        }

        $r3 = M('money_to_token_log')->where(['order_id'=>$info['order_id']])->save(['status'=>3,'update_time'=>time()]);

        if($r1 !== false && $r2 !== false && $r3){
            return ['status'=>true];
        }else{
            \Think\Log::write("------------- r1=$r1, r2=$r2, r3=$r3 ----------------", 'INFO');
            if($exists){
                if($r1 !== false){
                    $redis->hincrby($info['player_id'], 'player_amount', (int)($info['from_value']/100));
                }
                if($r2 !== false){
                    $redis->hdecrby($info['player_id'], 'player_tokens', $info['to_value']);
                }
            }
            return ['status'=>false, 'msg'=>isset($msg) ? $msg : '更新数据失败'];
        }
    }

    protected function requestExchangeToken($info){
        // 'player_id'      => $player_id,
        // 'club_id'        => $club_id,
        // 'from_card_type' => $card_type,
        // 'from_card_id'   => $card[1],
        // 'to_card_type'   => 1,
        // 'to_card_id'     => $club_player['id'], 
        // 'goods_id'       => $goods_id,
        // 'from_value'     => 0,
        // 'to_value'       => 0
    
        // return ['status'=>true];


        $http = new \Web\Lib\Service\HttpService();
        $data = [
            'action'     => 'uxuncointransfer',
            'version'    => 'v10001',
            'key_value'  => 1,
            'flag_value' => 1,
            'sign_value' => time(),
            'data_value' =>
                [
                    'app_id'          =>$info['app_id'],
                    'club_id'         =>$info['club_id'],
                    'player_id'       =>$info['player_id'], 
                    'card_id'         =>$info['from_card_id'],
                    'task_pay_type'   =>2,// 余额
                    'task_out_type'   =>1,// 代币
                    'task_pay_points' =>(int)($info['from_value']/100),// 余额数
                    'task_out_points' =>$info['to_value'],// 代币数
                    'transfer_type'   =>2,// 2为优讯卡转电子卡
                    'order_type'      =>0,
                    'player_token'    =>'SFNtQW9meEhxZVVZbTYwa3hRNHg0RVVwbVhVUHZaZkpqQT09'
                ]
        ];
        
        $return = $http->get(C('PLAYER_CARD_CHANGE_MONEY') . json_encode($data));
        // \Think\Log::write('[ uxuncointransfer ]'.$return,'INFO');
        $result = json_decode($return, true);
        if(!empty($result) && $result['data_value']['code_value'] == 0 && $result['data_value']['data']['error'] == 0){
            M('money_to_token_log')->where(['order_id'=>$info['order_id']])->save(['status'=>2,'update_time'=>time(),'order_sync_task_id'=>$result['data_value']['data']['order_id']]);
            return ['status'=>true];
        }else{
            \Think\Log::write('[ exchange uxuncointransfer error ]'.$return,'INFO');
            return ['status'=>false, 'msg'=>$result['data_value']['desc_value']];
        }
    }

    public function test(){
        
    }


}