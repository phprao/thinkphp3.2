<?php
return array(
	// SESSION设置
	'SESSION_AUTO_START'    =>  true,    // 是否自动开启Session
	'SESSION_OPTIONS'       =>  array(), // session 配置数组 支持type name id path expire domain 等参数
	'SESSION_PREFIX'        =>  'web_', // session 前缀

	// 扩展
	'AUTOLOAD_NAMESPACE' 	=> array(
		'Web\Lib'         => APP_PATH.'Web/Lib',
		'Web\Lib\Service' => APP_PATH.'Web/Lib/Service',
		'Web\Lib\Notify'  => APP_PATH.'Web/Lib/Notify',
		'Web\Lib\Redis'   => APP_PATH.'Web/Lib/Redis',
	),

	// 星云游戏城公众号配置列表
	'APPID'     =>'',
	'APPSECRET' =>'',
	'MCHID'     =>'',
	'KEY'		=>'',


	// 公众号充值
	'WEIXIN_CHARGE_REDIRECT_URL' =>'Index/index', // 微信授权回调地址
	'WEIXIN_CHARGE_NOTIFY_URL'	 =>'Server/wxPayNotifyAction',

	// 商家入驻
	'WEIXIN_SHOP_REDIRECT_URL'	 =>'Shop/index',
	'WEIXIN_SHOP_EXCHANGE_URL'	 =>'Exchange/index',

);