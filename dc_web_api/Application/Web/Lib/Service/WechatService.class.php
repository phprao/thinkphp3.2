<?php

namespace Web\Lib\Service;

class WechatService{

    private $appid;

    private $secret;

    private $http;

    const  REDIRECT_URL = 'https://open.weixin.qq.com/connect/oauth2/authorize?';

    const  TOKEN_URL = 'https://api.weixin.qq.com/sns/oauth2/access_token?';

    const USERINFO_URL = 'https://api.weixin.qq.com/sns/userinfo?';


    public function __construct()
    {
        $this->appid  = C('APPID');
        $this->secret = C('APPSECRET');
        $this->http = new \Web\Lib\Service\HttpService();
    }

    public function getRedirectUrl($redirect_uri, $scope = 'snsapi_userinfo')
    {
        $data = [
            'appid' => $this->appid,
            'redirect_uri' => $redirect_uri,
            'response_type' => 'code',
            'scope' => $scope,
            'state' => 'STATE',
        ];
        return self::REDIRECT_URL . http_build_query($data) . '#wechat_redirect';
    }

    public function getAccessToken($code)
    {
        $data = [
            'appid' => $this->appid,
            'secret' => $this->secret,
            'code' => $code,
            'grant_type' => 'authorization_code'
        ];

        return $this->http->get(self::TOKEN_URL . http_build_query($data));
    }

    public function getUserInfo($access_token, $openid)
    {
        $data = [
          'access_token' => $access_token,
          'openid' => $openid,
          'lang' => 'zh_CN'
        ];

        return $this->http->get(self::USERINFO_URL . http_build_query($data));
    }
}