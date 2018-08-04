<?php

/**
 * 合并数组
 * @param $a
 * @param $b
 * @return array|mixed
 */
function mergeArray($a, $b)
{
    $args = func_get_args();
    $res = array_shift($args);
    while (!empty($args)) {
        $next = array_shift($args);
        foreach ($next as $k => $v) {
            if (is_integer($k)) {
                isset($res[$k]) ? $res[] = $v : $res[$k] = $v;
            } elseif (is_array($v) && isset($res[$k]) && is_array($res[$k])) {
                $res[$k] = mergeArray($res[$k], $v);
            } else {
                $res[$k] = $v;
            }
        }
    }
    return $res;
}

/**
 * 跨域程序
 * @param $config
 */
function headerCrossDomain($config)
{
    $domain = '';
    if (isset($_SERVER['HTTP_ORIGIN'])) {
        $domain = $_SERVER['HTTP_ORIGIN'];
    }
    $config = array_flip((array)$config);
    if (isset($config[$domain])) {
        crossDomain($domain);
    } elseif (isset($config['*'])) {
        crossDomain('*');
    }
}

/**
 * 添加跨域
 * @param $domain
 */
function crossDomain($domain)
{
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Allow-Origin: ' . $domain);
}

/**
 * 保留两位小数
 * @param  [type]  $data [description]
 * @param  integer $len  [description]
 * @return [type]        [description]
 */
function cutDataByLen($data,$len = 2){
    return sprintf("%.".$len."f",$data);
}

/**
 * 显示金钱
 * @param $money
 * @param int $type
 * @return int|string
 */
function getViewMoney($money, $type = 3)
{
    switch ($type) {
        case 1 :
            //todo 元
            $money = floor($money * 100) / 100;
            return sprintf('%.2f', $money);
            break;
        case 2 :
            //todo 角
            $money = floor($money * 10) / 10;
            return sprintf('%.2f', $money / 10);
            break;
        case 3 :
            //todo 分
            $money = floor($money);
            return sprintf('%.2f', $money / 100);
            break;
        default :
            return 0;
    }
}

/**
 * 美化
 * @param $string
 * @return string
 */
function getPretty($string)
{
    $string = lcfirst($string);
    $len = strlen($string);
    $out = $string[0];
    for ($i = 1; $i < $len; $i++) {
        $ch = $string[$i];
        if (preg_match("/^[A-Z]/", $ch)) {
            $out .= '_' . strtolower($ch);
        } else {
            $out .= $ch;
        }
    }
    return $out;
}

function checkString($string = '',$mode = 1){
    switch($mode)
    {
        case 1:
            /* a-z,A-Z,0-9,~,!,@,#,$,%,^,&,*,(,),_,+
             * 登录账号或者密码
             */
            $exp = "/^[a-zA-Z0-9]{6,16}$/";
            break;
        case 2:
            /**
             * 存在非可见字符
             */
            $exp = "/^\s*$/";
            break;
        case 3:
            // 手机号
            $exp = "/^1[356789]{1}\d{9}$/";
            break;
        case 4:
            $exp = "/^[0-9]+$/";
            break;
        default:
            return false;
    }

    $re = preg_match($exp,$string);
    if($re){
        $result = true;
    }else{
        $result = false;
    }
    if($mode == 2){
        $result = !$result;
    }

    return $result;
}

//获取客户端的真实Ip
function get_real_ip(){

    global $ip; 

    if (getenv("HTTP_CLIENT_IP")) 
    $ip = getenv("HTTP_CLIENT_IP"); 
    else if(getenv("HTTP_X_FORWARDED_FOR")) 
    $ip = getenv("HTTP_X_FORWARDED_FOR"); 
    else if(getenv("REMOTE_ADDR")) 
    $ip = getenv("REMOTE_ADDR"); 
    else 
    $ip = "Unknow"; 

    return $ip;                 
}
// 随机生成字符串
function create_rand_str($length){
    $stt = join('',range('a','z')) . join('',range('A','Z')) . join('',range(0,9));
    $len = strlen($stt);
    $re = '';
    for($i=0;$i<$length;$i++){
        $re .= $stt[rand(0,$len-1)];
    }
    return $re;
}

function createOrderId ($length = 24) {
    $seed=md5(microtime());
    $pwd='';
    for($i=0;$i<$length;$i++){
        $pwd.=$seed{mt_rand(0,31)};
    }
    $hash=md5($pwd);
    return substr($hash,0,$length);
}

function fomatBigData($data = 0){
    if($data >= 100000000){
        return sprintf("%.4f", $data / 100000000) . ' 亿';
    }elseif($data >= 10000){
        return sprintf("%.2f", $data / 10000) . ' 万';
    }else{
        return sprintf("%.2f", $data);
    }
}

function fomatMoneyData($data = 0){
    if($data >= 100000000){
        return sprintf("%.4f", $data / 100000000) . ' 亿';
    }elseif($data >= 10000){
        return sprintf("%.2f", $data / 10000) . ' 万';
    }else{
        return sprintf("%.2f", $data) . ' 元';
    }
}

/**
 * 系统加密方法
 * @param string $data 要加密的字符串
 * @param string $key  加密密钥
 * @param int $expire  过期时间 单位 秒
 * return string
 * @author 麦当苗儿 <zuojiazi@vip.qq.com>
 */
function think_encrypt($data, $key = '', $expire = 0) {
    $key  = md5(empty($key) ? config('DATA_AUTH_KEY') : $key);
    $data = base64_encode($data);
    $x    = 0;
    $len  = strlen($data);
    $l    = strlen($key);
    $char = '';
    for ($i = 0; $i < $len; $i++) {
        if ($x == $l) $x = 0;
        $char .= substr($key, $x, 1);
        $x++;
    }
    $str = sprintf('%010d', $expire ? $expire + time():0);
    for ($i = 0; $i < $len; $i++) {
        $str .= chr(ord(substr($data, $i, 1)) + (ord(substr($char, $i, 1)))%256);
    }
    return str_replace(array('+','/','='),array('-','_',''),base64_encode($str));
}
/**
 * 系统解密方法
 * @param  string $data 要解密的字符串 （必须是think_encrypt方法加密的字符串）
 * @param  string $key  加密密钥
 * return string
 * @author 麦当苗儿 <zuojiazi@vip.qq.com>
 */
function think_decrypt($data, $key = ''){
    $key    = md5(empty($key) ? config('DATA_AUTH_KEY') : $key);
    $data   = str_replace(array('-','_'),array('+','/'),$data);
    $mod4   = strlen($data) % 4;
    if ($mod4) {
       $data .= substr('====', $mod4);
    }
    $data   = base64_decode($data);
    $expire = substr($data,0,10);
    $data   = substr($data,10);
    if($expire > 0 && $expire < time()) {
        return '';
    }
    $x      = 0;
    $len    = strlen($data);
    $l      = strlen($key);
    $char   = $str = '';
    for ($i = 0; $i < $len; $i++) {
        if ($x == $l) $x = 0;
        $char .= substr($key, $x, 1);
        $x++;
    }
    for ($i = 0; $i < $len; $i++) {
        if (ord(substr($data, $i, 1))<ord(substr($char, $i, 1))) {
            $str .= chr((ord(substr($data, $i, 1)) + 256) - ord(substr($char, $i, 1)));
        }else{
            $str .= chr(ord(substr($data, $i, 1)) - ord(substr($char, $i, 1)));
        }
    }
    return base64_decode($str);
}

// 处理base64图片
function uploadBase64Img($img_base64, $dir = '', $name = '', $ext = ''){
    $allowType = ['png','jpg','jpeg','png'];
    if(!$dir){
        $dir = './Public/Default/' . date('Ymd');
    }
    
    $base_data = explode(',', $img_base64);
    $img = base64_decode($base_data[1]);
    
    if(!is_dir($dir)){
        if(!mkdir($dir, 0777)){
            return ['status'=>false, 'msg'=>'目录权限不够'];
        }
    }
    // 'data:image/png;base64';
    preg_match('#image/(\S+);#', $base_data[0], $match);
    if(!in_array($match[1], $allowType)){
        return ['status'=>false, 'msg'=>'图片格式有误'];
    }
    if(!$name){
        $name = uniqid('default_', true);
    }
    if(!$ext){
        $ext = $match[1];
    }
    $url = $dir . '/' . $name . '.' . $ext;
    $re = file_put_contents($url, $img);
    if(!$re){
        return ['status'=>false, 'msg'=>'图片保存失败'];
    }

    return ['status'=>true, 'msg'=>'保存成功', 'info'=>['dir'=>$dir, 'path'=>$url, 'name'=>$name . '.' . $ext]];
}

function generateQrcodePng($url, $path, $ext = []){
    import('Web.Lib.Phpqrcode.phpqrcode');
    $level  = isset($ext['level']) ? $ext['level'] : 0;
    $size   = isset($ext['size']) ? $ext['size'] : 3;
    $margin = isset($ext['margin']) ? $ext['margin'] : 4;
    $re = \QRcode::png($url, $path, $level, $size, $margin);
    return $re;
}
