/*
Navicat MySQL Data Transfer

Source Server         : 192.168.1.210
Source Server Version : 50713
Source Host           : 192.168.1.210:3306
Source Database       : dc_xingyun

Target Server Type    : MYSQL
Target Server Version : 50713
File Encoding         : 65001

Date: 2018-06-06 14:37:01
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for dc_pay_record
-- ----------------------------
DROP TABLE IF EXISTS `dc_pay_record`;
CREATE TABLE `dc_pay_record` (
  `recore_id` int(11) NOT NULL AUTO_INCREMENT,
  `recore_player_id` int(11) NOT NULL DEFAULT '0' COMMENT '玩家id',
  `recore_club_id` int(11) DEFAULT '0' COMMENT '俱乐部id',
  `recore_type` int(11) NOT NULL DEFAULT '0' COMMENT '类型 1微信支付 2 支付宝支付,3 苹果支付,4web支付，5-为公众号支付',
  `recore_price` int(11) NOT NULL DEFAULT '0' COMMENT '冲值金额(单位为分)',
  `recore_get_type` int(11) DEFAULT '2' COMMENT '所得商品类型1余额2金币3彩票',
  `recore_get_price` int(11) NOT NULL DEFAULT '0' COMMENT '得到的货币值(如金币数量)',
  `recore_before_money` bigint(21) NOT NULL DEFAULT '0' COMMENT '充值前金币',
  `recore_order_id` int(11) DEFAULT '0' COMMENT '订单id',
  `recore_after_money` bigint(21) NOT NULL DEFAULT '0' COMMENT '充值后金币',
  `recore_create_time` int(11) NOT NULL DEFAULT '0' COMMENT '充值时间',
  PRIMARY KEY (`recore_id`),
  KEY `recore_player_id` (`recore_player_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15294 DEFAULT CHARSET=utf8 COMMENT='充值记录表';
