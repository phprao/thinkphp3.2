<?php

return array_merge( 
	array(
		// 数据库设置
		'DB_TYPE'               =>  'mysql',     // 数据库类型
		'DB_HOST'               =>  '192.168.1.210', // 服务器地址
		'DB_NAME'               =>  'dc_xingyun',          // 数据库名
		'DB_USER'               =>  'root',      // 用户名
		'DB_PWD'                =>  '123456',          // 密码
		'DB_PORT'               =>  '',        // 端口
		'DB_PREFIX'             =>  'dc_',    // 数据库表前缀
		'DB_FIELDS_CACHE'       =>  false,        // 启用字段缓存
		'DB_CHARSET'            =>  'utf8',      // 数据库编码默认采用utf8

		'REDIS_USER_INFO'		=>  [
			'host'       => '192.168.1.210',
			'port'       => '56001',// 56002  56003
			'password'   => 'zyl12345!QWEASD901',
			'select'     => 0,
			'timeout'    => 0,
			'expire'     => 60,
			'persistent' => false,
			'prefix'     => '',
		],
		// 微信公众号充值页面
		'WEIXIN_CHARGE_PAGE_URL'        =>'http://localhost/dc_php_xingyun/trunk/dc_web/index.html',
		// 商家入驻页面
		'WEIXIN_SHOP_BIND_PAGE_URL'     =>'http://localhost/dc_php_xingyun/trunk/dc_web/shopbind.html',
		// 兑换优惠券
		'WEIXIN_SHOP_EXCHANGE_PAGE_URL' =>'http://localhost/dc_php_xingyun/trunk/dc_web/exchange.html',
		
		// 实体卡相关接口
		'PLAYER_CARD_FLUSH_INFO'   =>'http://localhost/dc_php_xingyun/trunk/dc_better/action.php?param=',
		'PLAYER_CARD_CHANGE_MONEY' =>'http://localhost/dc_php_xingyun/trunk/dc_better/action.php?param=',

		// 星云公众号微信红包
		'SEND_BONUS_CONFIG' => [
	        // 微信发红包地址
	        'send_bonus_url'      => '',
	        // 微信发红包回调地址
	        'send_bonus_callback' => '',
	        // 微信发红包名称
	        'send_bonus_name'     => 'xingyun',
	        // 微信发红包应用场景
	        'send_bonus_scanid'   => 'match',
	        // 描述
	        'send_bonus_remark'   => [
	            "act_name"  => "星云游戏城优惠券",
	            "remark"    => "星云游戏城优惠券",
	            "send_name" => "星云游戏城优惠券",
	            "wishing"   => "恭喜发财，大吉大利！"
	        ]
	    ],
	
	), 
	is_file(APP_PATH . 'Web/Conf/common.php') ? require APP_PATH . 'Web/Conf/common.php' : []
);