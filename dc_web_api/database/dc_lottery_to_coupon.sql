/*
Navicat MySQL Data Transfer

Source Server         : 192.168.1.210
Source Server Version : 50713
Source Host           : 192.168.1.210:3306
Source Database       : dc_xingyun

Target Server Type    : MYSQL
Target Server Version : 50713
File Encoding         : 65001

Date: 2018-06-06 14:36:21
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for dc_lottery_to_coupon
-- ----------------------------
DROP TABLE IF EXISTS `dc_lottery_to_coupon`;
CREATE TABLE `dc_lottery_to_coupon` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shop_id` int(11) DEFAULT '0' COMMENT '商家ID',
  `club_id` int(11) DEFAULT '0' COMMENT '俱乐部ID',
  `player_id` int(11) DEFAULT '0' COMMENT '玩家id',
  `from_card_type` tinyint(3) DEFAULT '1' COMMENT '支付卡类型：1-电子卡，2-实体卡',
  `from_card_id` int(11) DEFAULT '0' COMMENT '卡片id：电子卡id，实体卡club_card_id',
  `from_value` int(11) DEFAULT '0' COMMENT '使用彩票数',
  `to_value` int(11) DEFAULT '0' COMMENT '兑换礼券数：分',
  `from_value_before` int(11) DEFAULT '0' COMMENT '兑换前的彩票数',
  `from_value_after` int(11) DEFAULT '0' COMMENT '兑换后的彩票数',
  `create_time` int(11) DEFAULT '0',
  `create_date` varchar(20) COLLATE utf8_unicode_ci DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='电子卡彩票兑换优惠券记录';
