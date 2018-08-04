/*
Navicat MySQL Data Transfer

Source Server         : 192.168.1.210
Source Server Version : 50713
Source Host           : 192.168.1.210:3306
Source Database       : dc_xingyun

Target Server Type    : MYSQL
Target Server Version : 50713
File Encoding         : 65001

Date: 2018-06-14 18:15:04
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for dc_shop_exchange_lottery
-- ----------------------------
DROP TABLE IF EXISTS `dc_shop_exchange_lottery`;
CREATE TABLE `dc_shop_exchange_lottery` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `shop_id` int(11) DEFAULT '0' COMMENT '商店ID',
  `club_id` int(11) DEFAULT '0' COMMENT '俱乐部ID',
  `player_id` int(11) DEFAULT '0' COMMENT '玩家id',
  `cost_type` tinyint(3) DEFAULT '1' COMMENT '支付货币类型：1-彩票',
  `cost_value` int(11) DEFAULT '0' COMMENT '花费的货币数',
  `cost_before` int(11) DEFAULT '0' COMMENT '兑换前的货币数',
  `cost_after` int(11) DEFAULT '0' COMMENT '兑换后的货币数',
  `get_type` tinyint(3) DEFAULT '1' COMMENT '得到的货币类型：1-红包',
  `get_type_value` float(11,2) DEFAULT '0.00' COMMENT '得到的值：元',
  `get_type_id` int(11) DEFAULT '0' COMMENT '关联ID：红包id',
  `club_lottery_rate` float(11,4) DEFAULT '0.0000' COMMENT '俱乐部设置的彩票兑换比例',
  `create_time` int(11) DEFAULT '0',
  `create_date` varchar(20) COLLATE utf8_unicode_ci DEFAULT '',
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='商家兑换彩票记录';
