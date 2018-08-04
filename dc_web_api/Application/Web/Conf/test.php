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
			'port'       => '55001',
			'password'   => 'zyl12345!QWEASD901',
			'select'     => 0,
			'timeout'    => 0,
			'expire'     => 60,
			'persistent' => false,
			'prefix'     => '',
		],

		'WEIXIN_CHARGE_PAGE_URL'     =>'http://192.168.1.210/dc_web/index.html',
		
		// 实体卡相关接口
		'PLAYER_CARD_FLUSH_INFO'=>'',
		'PLAYER_CARD_CHANGE_MONEY'=>'',
	
	), 
	is_file(APP_PATH . 'Web/Conf/common.php') ? require APP_PATH . 'Web/Conf/common.php' : []
);