<?php
/**
 +---------------------------------------------------------- 
 * date: 2018-05-28 20:28:03
 +---------------------------------------------------------- 
 * author: Raoxiaoya
 +---------------------------------------------------------- 
 * describe: 商家入驻相关
 +---------------------------------------------------------- 
 */
namespace Web\Controller;

class ShopController extends BaseController {

    protected function _initialize()
    {
        
    }

    /**
     * 微信授权
     * @return [type] [description]
     */
    public function index(){
        $redirect_uri =  U(C('WEIXIN_SHOP_REDIRECT_URL'), [], true, true);
        $auth = $this->wxAuth($redirect_uri);
        if($auth['status']){
            header('Location:'.C('WEIXIN_SHOP_BIND_PAGE_URL') . '?code=' . $auth['msg']);
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
        $data = ['userInfo'=>$userInfo];
        

        $SBCM  = M('shop_bind_club');
            
        $bindInfo = $SBCM
                    ->where(['unionid'=>$data['userInfo']['unionid']])
                    ->order('shop_id desc')
                    ->find();
        if($bindInfo){
            if($bindInfo['status'] == 1 || $bindInfo['status'] == 3){
                $bindInfo['face_img'] = 'http://'.$_SERVER['SERVER_NAME'] . dirname($_SERVER['PHP_SELF']) .'/'.$bindInfo['face_img'];
                $data['info'] = $bindInfo;
            }
            if($bindInfo['status'] == 4){
                $club_info = M('club_info')->where(['club_id'=>$bindInfo['club_id']])->find();
                $bindInfo['qrcode']   = 'http://'.$_SERVER['SERVER_NAME'] . dirname($_SERVER['PHP_SELF']) .'/'.$bindInfo['qrcode'];
                $data['info'] = $bindInfo;
                $data['info']['club_name'] = $club_info['club_name'];
                $data['info']['club_id'] = $club_info['club_name'] . ' ( ID：'.$bindInfo['club_id'].' )';
            }

        }

        session('ShopUser', json_encode($data));

        return $this->responseJsonSuccess($data);
        
    }

    /**
     * 优惠券记录
     * @return [type] [description]
     */
    public function exchangeList(){
        $sess_info = json_decode(session('ShopUser'),true);
        if(empty($sess_info)){
            return $this->responseJsonError(402, '非法请求，请重新进入');
        }

        if(isset($sess_info['info']) && $sess_info['info']['status'] != 4){
            return $this->responseJsonError(10001, '非法请求，该商家暂未被审批');
        }

        $page    = (int)I('get.page');
        $last_id = (int)I('get.last_id');
        if($last_id > 0){
            $w = ['shop_id'=>$sess_info['info']['shop_id'], 'log_id'=>['LT', $last_id]];
        }elseif($last_id == 0){
            $w = ['shop_id'=>$sess_info['info']['shop_id']];
        }else{
            return $this->responseJsonSuccess(['list'=>[], 'last_id'=>-1, 'page'=>$page]);
        }
        $list = M('shop_exchange_lottery')
                    ->where($w)
                    ->field("log_id,player_id,create_date,get_type_value")
                    ->order("log_id desc")
                    ->limit("10")
                    ->select();
        if($list){
            $last_id = $list[count($list) - 1]['log_id'];
            foreach ($list as $key => $val) {
                $player = M('player')->where(['player_id'=>$val['player_id']])->find();
                if($player){
                    $list[$key]['nickname'] = urldecode($player['player_nickname']);
                }else{
                    $list[$key]['nickname'] = '---';
                }
                $list[$key]['get_type_value'] = cutDataByLen($val['get_type_value'], 2);
            }
        }else{
            $last_id = -1;
        }
        return $this->responseJsonSuccess(['list'=>$list, 'last_id'=>$last_id, 'page'=>$page]);
    }

    public function getExchangeSum(){
        $sess_info = json_decode(session('ShopUser'),true);
        if(empty($sess_info)){
            return $this->responseJsonError(402, '非法请求，请重新进入');
        }
        if(isset($sess_info['info']) && $sess_info['info']['status'] != 4){
            return $this->responseJsonError(10001, '非法请求，该商家暂未被审批');
        }

        $total = M('shop_exchange_lottery')->where(['shop_id'=>$sess_info['info']['shop_id']])->sum('get_type_value');
        $total = $total ? $total : 0;

        return $this->responseJsonSuccess(['total'=>cutDataByLen($total, 2)]);
    }

    /**
     * 提交入驻申请
     * @return [type] [description]
     */
    public function apply(){
        $name       = I('post.name');
        $address    = I('post.address');
        $tel        = I('post.tel');
        $club_id    = I('post.club_id');
        // $img_base64 = I('post.img_base64');
        $openid     = I('post.openid');
        $unionid    = I('post.unionid');
        if(!checkString($name, 2) || !$name || mb_strlen($name) > 30){
            return $this->responseJsonError(10000, '店铺名称格式有误');
        }
        if(!checkString($address, 2) || !$address || mb_strlen($address) > 30){
            return $this->responseJsonError(10000, '店铺地址格式有误');
        }
        if(!preg_match("/^[0-9]{11}$/",$tel)){
            return $this->responseJsonError(10000, '电话为11位数字');
        }
        if(!preg_match("/^[0-9]{1,11}$/",$club_id)){
            return $this->responseJsonError(10000, '俱乐部ID为11位数字');
        }

        if($openid == '' || $unionid == ''){
            return $this->responseJsonError(10000, '参数错误');
        }

        $SBCM = M('shop_bind_club');
        $CIM = M('club_info');
        
        // 俱乐部是否存在且正常使用
        $club_info = $CIM->where(['club_id'=>$club_id])->find();
        if(empty($club_info)){
            return $this->responseJsonError(10000, '该俱乐部不存在');
        }
        if($club_info['club_status'] == 0){
            return $this->responseJsonError(10000, '该俱乐部被禁用');
        }

        // 是否有提交过
        $r1 = $SBCM->where(['unionid'=>$unionid, 'status'=>1])->count();
        if($r1){
            return $this->responseJsonError(10000, '您有一个待审批的申请');
        }
        $r2 = $SBCM->where(['unionid'=>$unionid, 'status'=>4])->count();
        if($r2){
            return $this->responseJsonError(10000, '该微信号已被绑定了店铺');
        }

        // 校验成功
        $shop_id = $SBCM->add([
            'club_id'     =>$club_id,
            'unionid'     =>$unionid,
            'openid'      =>$openid,
            'name'        =>$name,
            'address'     =>$address,
            'tel'         =>$tel,
            'create_time' =>time()
        ]);
        if(!$shop_id){
            return $this->responseJsonError(10001, '网络繁忙，请稍后重试');
        }

        // 上传图片
        $root = 'Uploads/';
        if(!is_dir($root)){
            if(!mkdir($root, 0777)){
                $SBCM->where(['shop_id'=>$shop_id])->delete();
                return $this->responseJsonError(10002, '目录权限不够，无法创建Uploads');
            }
        }
        if(!is_dir('Uploads/ShopQrcode')){
            if(!mkdir('Uploads/ShopQrcode', 0777)){
                $SBCM->where(['shop_id'=>$shop_id])->delete();
                return $this->responseJsonError(10002, '目录权限不够，无法创建ShopQrcode');
            }
        }
        $upload = new \Think\Upload();
        $upload->maxSize  = 3145728 ;
        $upload->exts     = array('jpg', 'gif', 'png', 'jpeg');
        $upload->rootPath = $root;
        $upload->savePath = 'Shop/';
        $upload->saveName = time() . '_' . $shop_id;
        $upload->autoSub  = false;
        $info   =   $upload->uploadOne($_FILES['file']);
        if($info) {
            $fullname = $root . $info['savepath'] . $info['savename'];
            $re = $SBCM->where(['shop_id'=>$shop_id])->save(['face_img'=>$fullname]);
            if(!$re){
                $SBCM->where(['shop_id'=>$shop_id])->delete();
                return $this->responseJsonError(10002, '数据更新失败');
            }
        }else{
            $SBCM->where(['shop_id'=>$shop_id])->delete();
            return $this->responseJsonError(10002, $upload->getError());
        }

        // 生成二维码
        $encrypt = think_encrypt($shop_id, 'dc_shop_exchange');
        $url     = U(C('WEIXIN_SHOP_EXCHANGE_URL'), ['shop_id'=>$encrypt], true, true);
        $path    = $root.'ShopQrcode/qr_'.time().'_'.$shop_id.'.png';
        $size    = 6;

        $re = generateQrcodePng($url, $path, ['level'=>0,'size'=> $size,'margin'=>2]);
        if(!$re){
            unlink($fullname);
            $SBCM->where(['shop_id'=>$shop_id])->delete();
            return $this->responseJsonError(10002, '生成二维码失败');
        }else{
            $re2 = $SBCM->where(['shop_id'=>$shop_id])->save(['qrcode'=>$path,'qrcode_url'=>$url]);
            if(!$re2){
                $SBCM->where(['shop_id'=>$shop_id])->delete();
                return $this->responseJsonError(10002, '数据更新失败');
            }
        }
        
        return $this->responseJsonSuccess();
    }

    /**
     * 取消入驻申请
     * @return [type] [description]
     */
    public function cancelApply(){
        $bind_id = I('post.bind_id');
        $unionid  = I('post.unionid');
        if(!is_numeric($bind_id) || !$bind_id){
            return $this->responseJsonError(10000, '参数有误');
        }
        if(!$unionid){
            return $this->responseJsonError(10000, '参数有误');
        }
        $SBCM = M('shop_bind_club');
        $r1 = $SBCM->where(['shop_id'=>$bind_id, 'unionid'=>$unionid])->find();
        if(!$r1){
            return $this->responseJsonError(10000, '该申请记录不存在');
        }
        if($r1['status'] == 3){
            return $this->responseJsonError(10000, '该申请已被拒绝，无法取消');
        }
        if($r1['status'] == 4){
            return $this->responseJsonError(10000, '该申请已被审批通过，无法取消');
        }

        $r2 = $SBCM->where(['shop_id'=>$bind_id])->save(['status'=>2,'qrcode_url'=>'']);
        if($r2){
            unlink($r1['face_img']);
            unlink($r1['qrcode']);
            return $this->responseJsonSuccess();
        }else{
            return $this->responseJsonError(10002, '数据更新失败，请稍后重试');
        }

    }


    public function test(){
        
    }

}