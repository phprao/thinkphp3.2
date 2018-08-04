<?php
return array(
	//'配置项'=>'配置值'
	'HTML_CACHE_ON'     =>    false, // 开启静态缓存

	'MODULE_ALLOW_LIST'    =>    array('Web'),
	'DEFAULT_MODULE'       =>    'Web',  // 默认模块

	// 日志设置
	'LOG_RECORD'            =>  true,   // 默认不记录日志
	'LOG_TYPE'              =>  'File', // 日志记录类型 默认为文件方式
	'LOG_LEVEL'             =>  'EMERG,ALERT,CRIT,ERR,WARN,NOTICE,DEBUG,SQL',// 允许记录的日志级别
	'LOG_EXCEPTION_RECORD'  =>  true,    // 是否记录异常信息日志

	// URL设置
	'URL_CASE_INSENSITIVE'  =>  true,   // 默认false 表示URL区分大小写 true则表示不区分大小写
	'URL_MODEL'             =>  2,       // URL访问模式,可选参数0、1、2、3,代表以下四种模式：
	// 0 (普通模式); 1 (PATHINFO 模式); 2 (REWRITE  模式); 3 (兼容模式)  默认为PATHINFO 模式
	'URL_ROUTER_ON'   		=>  false,//默认false,   // 是否开启URL路由
	'URL_PATHINFO_DEPR'     =>  '/',    // PATHINFO模式下，各参数之间的分割符号
	'URL_PATHINFO_FETCH'    =>  'ORIG_PATH_INFO,REDIRECT_PATH_INFO,REDIRECT_URL', // 用于兼容判断PATH_INFO 参数的SERVER替代变量列表
	'URL_REQUEST_URI'       =>  'REQUEST_URI', // 获取当前页面地址的系统变量 默认为REQUEST_URI
	'URL_HTML_SUFFIX'       =>  '',  // URL伪静态后缀设置
	'URL_DENY_SUFFIX'       =>  'ico|png|gif|jpg', // URL禁止访问的后缀设置
	'URL_PARAMS_BIND'       =>  true, // URL变量绑定到Action方法参数
	'URL_PARAMS_BIND_TYPE'  =>  0, // URL变量绑定的类型 0 按变量名绑定 1 按变量顺序绑定
	'URL_404_REDIRECT'      =>  '', // 404 跳转页面 部署模式有效
	'URL_ROUTE_RULES'       =>  array(), // 默认路由规则 针对模块
	'URL_MAP_RULES'         =>  array(), // URL映射定义规则

	

);