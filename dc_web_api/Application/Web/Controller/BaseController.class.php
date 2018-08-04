<?php
namespace Web\Controller;
use Think\Controller;

class BaseController extends Controller {

	/**
	 * 添加跨域
	 */
	public function addCrossDomain(){
		$host_name = isset($_SERVER['HTTP_ORIGIN']) ? $_SERVER['HTTP_ORIGIN'] : "*";
        header('Access-Control-Allow-Origin:' . $host_name);
        header('Access-Control-Allow-Credentials:true');
        header('Access-Control-Allow-Headers:x-token,x-uid,x-token-check,x-requested-with,content-type,Host');
	}
    
    /**
     * 成功响应
     * @param  [type]  $data    [description]
     * @param  string  $message [description]
     * @param  integer $code    [description]
     * @return [type]           [description]
     */
    public function responseJsonSuccess($data = [], $message = 'success', $code = 0){
    	$this->addCrossDomain();
    	$data = [
			'status' =>$code,
			'msg'    =>$message,
			'data'   =>$data
    	];
        \Think\Log::write(json_encode($data),'INFO');
    	$this->ajaxReturn($data, 'JSON');
    }

    /**
     * 失败响应
     * @param  integer $code    [description]
     * @param  string  $message [description]
     * @param  [type]  $data    [description]
     * @return [type]           [description]
     */
    public function responseJsonError($code = 400, $message = 'error', $data = []){
    	$this->addCrossDomain();
    	$data = [
			'status' =>$code,
			'msg'    =>$message,
			'data'   =>$data
    	];
        \Think\Log::write(json_encode($data),'INFO');
    	$this->ajaxReturn($data, 'JSON');
    }

    public function getWxUserInfoByAuth($redirect_uri = ''){
        $WechatService = new \Web\Lib\Service\WechatService();

        if(!$redirect_uri){
            return ['status'=>false, 'msg'=>'redirect_uri is null'];
        }

        $code = I('get.code');

        if (empty($code)) {
            $url = $WechatService->getRedirectUrl($redirect_uri);
            header("Location:" . $url);
        }else{
            // 获取用户基本信息
            $accessToken = $WechatService->getAccessToken($code);
            if (!$accessToken) {
                return ['status'=>false, 'msg'=>'请在微信打开此链接'];
            }
            
            $jsData = json_decode($accessToken, true);
            if (isset($jsData['errcode'])) {
                return ['status'=>false, 'msg'=>$jsData['errmsg']];
            }
            $access_token = $jsData['access_token'];
            $refresh_token = $jsData['refresh_token'];
            $openid = $jsData['openid'];
            $userRes = $WechatService->getUserInfo($access_token, $openid);
            if (!$userRes) {
                return ['status'=>false, 'msg'=>'获取用户基本信息失败'];
            }
            $js_userinfo = json_decode($userRes, true);
            if (isset($js_userinfo['errcode'])) {
                return ['status'=>false, 'msg'=>'获取用户基本信息失败'];
            }

            return ['status'=>true, 'msg'=>$js_userinfo];
        }
    }

    public function wxAuth($redirect_uri = ''){
        $WechatService = new \Web\Lib\Service\WechatService();

        if(!$redirect_uri){
            return ['status'=>false, 'msg'=>'redirect_uri is null'];
        }

        $code = I('get.code');

        if (empty($code)) {
            $url = $WechatService->getRedirectUrl($redirect_uri);
            header("Location:" . $url);
        } else {
            return ['status'=>true, 'msg'=>$code];
        }
    }

    public function getWxUserInfoByCode($code = ''){
        if(!$code){
            return ['status'=>false, 'msg'=>'code参数错误'];
        }
        $WechatService = new \Web\Lib\Service\WechatService();
        // 获取用户基本信息
        $accessToken = $WechatService->getAccessToken($code);
        if (!$accessToken) {
            return ['status'=>false, 'msg'=>'请在微信打开此链接'];
        }
        
        $jsData = json_decode($accessToken, true);
        if (isset($jsData['errcode'])) {
            return ['status'=>false, 'msg'=>$jsData['errmsg'], 'errcode'=>$jsData['errcode']];
        }
        $access_token = $jsData['access_token'];
        $refresh_token = $jsData['refresh_token'];
        $openid = $jsData['openid'];
        $userRes = $WechatService->getUserInfo($access_token, $openid);
        if (!$userRes) {
            return ['status'=>false, 'msg'=>'获取用户基本信息失败'];
        }
        $js_userinfo = json_decode($userRes, true);
        if (isset($js_userinfo['errcode'])) {
            return ['status'=>false, 'msg'=>'获取用户基本信息失败'];
        }

        return ['status'=>true, 'msg'=>$js_userinfo];
    }

    /**
     * 刷新实体卡信息
     * @param  [type] $club_id   [description]
     * @param  [type] $player_id [description]
     * @return [type]            [description]
     */
    public function flushClubCardInfo($player_id){
        $http = new \Web\Lib\Service\HttpService();
        $list = M('club_card')
                ->where(['club_card_player_id'=>$player_id,'club_card_status'=>2])
                ->group('club_card_app_id')
                ->select();
        if(!empty($list)){
            foreach($list as $val){
                $data = [
                    'action'     => 'uxuncardinfo',
                    'version'    => 'v10001',
                    'key_value'  => 1,
                    'flag_value' => 1,
                    'sign_value' => time(),
                    'data_value' =>
                        [
                            'player_id'=>$val['club_card_player_id'], 
                            'player_token'=>'SFNtQW9meEhxZVVZbTYwa3hRNHg0RVVwbVhVUHZaZkpqQT09', 
                            'app_id'=>$val['club_card_app_id']
                        ]
                ];
                $return = $http->get(C('PLAYER_CARD_FLUSH_INFO') . json_encode($data));
                // \Think\Log::write('[ flush card info ]：'.$return,'INFO');
            }
            
        }
        
    }

}
