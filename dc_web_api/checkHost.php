<?php

$hostList = [
    //测试
    'test' => [
        '192.168.1.210',
    ],
    //开发、联调
    'dev' => [
        'xingyun.dcgames.cn',
    ],
    //本地
    'local' => [
        'localhost',
        '127.0.0.1',
    ],
    //正式
    'product' => [
        'xxx',
    ],
];

$hostListInit = [];
foreach ($hostList as $k => $item) {
    foreach ($item as $v) {
        $hostListInit[$v] = $k;
    }
}

if (isset($_SERVER['HTTP_HOST']) && isset($hostListInit[$_SERVER['HTTP_HOST']])) {
    return $hostListInit[$_SERVER['HTTP_HOST']];
} else {
    return 'local';
}

