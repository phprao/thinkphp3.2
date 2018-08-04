/*
Navicat MySQL Data Transfer

Source Server         : 192.168.1.210
Source Server Version : 50713
Source Host           : 192.168.1.210:3306
Source Database       : dc_xingyun

Target Server Type    : MYSQL
Target Server Version : 50713
File Encoding         : 65001

Date: 2018-06-06 14:34:06
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for dc_club_player
-- ----------------------------
DROP TABLE IF EXISTS `dc_club_player`;
CREATE TABLE `dc_club_player` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一id',
  `club_id` int(11) DEFAULT '0' COMMENT '俱乐部id',
  `player_id` int(11) DEFAULT NULL COMMENT '玩家ID',
  `player_tokens` bigint(20) DEFAULT '0' COMMENT '代币',
  `player_lottery` bigint(20) DEFAULT '0' COMMENT '彩票',
  `player_amount` bigint(20) DEFAULT '0' COMMENT '余额',
  `player_zombie_coin` bigint(20) DEFAULT '0' COMMENT '僵尸金币',
  `join_time` int(11) DEFAULT '0' COMMENT '加入时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2075 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='玩家和俱乐部信息表（玩家电子卡信息）';
