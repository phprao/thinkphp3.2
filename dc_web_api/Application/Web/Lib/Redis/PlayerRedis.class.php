<?php
/**
 +---------------------------------------------------------- 
 * date: 2018-05-02 10:42:20
 +---------------------------------------------------------- 
 * author: Raoxiaoya
 +---------------------------------------------------------- 
 * describe: 玩家
 +---------------------------------------------------------- 
 */

namespace Web\Lib\Redis;

use Think\Cache\Driver\Redis;

/**
 * Class PlayerRedis
 */
class PlayerRedis
{

    public static $redis = null;
    public static $prefix = '';
    public static $user_config = 'REDIS_USER_INFO';
    public static $table;
    public static $club_id;

    public function __construct($param = ['table' => 'user_info', 'club_id'=>0]){
        self::$table   = $param['table'];
        self::$club_id = $param['club_id'];
    }

    public static function getDb($playerId)
    {
        $db = $playerId % 10;
        C(self::$user_config . '.select', $db);
        $index = $playerId % 1000;
        $keys = floor($index / 10);
        if(self::$table == 'user_info'){
            self::$prefix = self::$table . ':' . $keys . ':';
        }elseif(self::$table == 'club_user'){
            self::$prefix = self::$table . ':' . self::$club_id . ':' . $keys . ':';
        }
    }

    public static function init($playerId)
    {
        self::getDb($playerId);

        if (!self::$redis) {

            $options = C(self::$user_config);

            if (!extension_loaded('redis')) {
                throw new \BadFunctionCallException('not support: redis');
            }

            if (empty($options)){
                throw new \BadFunctionCallException('not config: redis');
            }

            self::$redis = new \Redis;
            if ($options['persistent']) {
                self::$redis->pconnect($options['host'], $options['port'], $options['timeout'], 'persistent_id_' . $options['select']);
            } else {
                self::$redis->connect($options['host'], $options['port'], $options['timeout']);
            }

            if ('' != $options['password']) {
                self::$redis->auth($options['password']);
            }

            if (0 != $options['select']) {
                self::$redis->select($options['select']);
            }
        }

        return self::$redis;
    }

    public static function hset($playerId, $field, $value)
    {
        self::init($playerId);
        return self::$redis->hset(self::$prefix . $playerId, $field, $value);
    }

    public static function hmset($playerId, $data = [])
    {
        if(empty($data)){
            return false;
        }
        self::init($playerId);
        return self::$redis->hmset(self::$prefix . $playerId, $data);
    }

    public static function hmget($playerId, $fields = [])
    {
        if(empty($fields)){
            return false;
        }
        self::init($playerId);
        $result = self::$redis->hmget(self::$prefix . $playerId, $fields);
        return $result;
    }

    public static function hget($playerId, $field)
    {
        self::init($playerId);
        return self::$redis->hget(self::$prefix . $playerId, $field);
    }

    public static function hgetall($playerId)
    {
        self::init($playerId);
        return self::$redis->hgetall(self::$prefix . $playerId);
    }

    public static function hincrby($playerId, $field, $value)
    {
        self::init($playerId);
        return self::$redis->hIncrBy(self::$prefix . $playerId, $field, $value);
    }

    public static function hdecrby($playerId, $field, $value = 1)
    {
        self::init($playerId);
        return self::$redis->hIncrBy(self::$prefix . $playerId, $field, -$value);
    }

    public static function exists($playerId)
    {
        self::init($playerId);
        return self::$redis->exists(self::$prefix . $playerId);
    }



}