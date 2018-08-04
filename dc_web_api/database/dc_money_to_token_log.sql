/*
Navicat MySQL Data Transfer

Source Server         : 192.168.1.210
Source Server Version : 50713
Source Host           : 192.168.1.210:3306
Source Database       : dc_xingyun

Target Server Type    : MYSQL
Target Server Version : 50713
File Encoding         : 65001

Date: 2018-06-06 14:36:46
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for dc_money_to_token_log
-- ----------------------------
DROP TABLE IF EXISTS `dc_money_to_token_log`;
CREATE TABLE `dc_money_to_token_log` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) DEFAULT '0' COMMENT '玩家id',
  `club_id` int(11) DEFAULT '0' COMMENT '俱乐部id',
  `status` tinyint(3) DEFAULT '1' COMMENT '状态：1-下单，2-支付成功，3-兑换成功，4-处理失败',
  `order_sync_task_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '任务order_no',
  `from_card_type` tinyint(3) DEFAULT '0' COMMENT '源卡类型：1-电子卡，2-实体卡',
  `from_card_id` int(11) DEFAULT '0' COMMENT '源卡id：电子卡id，实体卡club_card_id',
  `to_card_type` tinyint(3) DEFAULT '0' COMMENT '目标卡类型：1-电子卡，2-实体卡',
  `to_card_id` int(11) DEFAULT '0' COMMENT '目标卡id：电子卡id，实体卡club_card_id',
  `goods_id` int(11) DEFAULT '0' COMMENT '商品id',
  `from_value` bigint(20) DEFAULT '0' COMMENT '支付余额数：*100',
  `to_value` bigint(20) DEFAULT '0' COMMENT '换取代币数',
  `before_value` bigint(20) DEFAULT '0' COMMENT '电子卡兑换前代币数',
  `after_value` bigint(20) DEFAULT '0' COMMENT '电子卡兑换后代币数',
  `create_time` int(11) DEFAULT '0' COMMENT '下单时间',
  `create_date` varchar(20) COLLATE utf8_unicode_ci DEFAULT '',
  `update_time` int(11) DEFAULT '0' COMMENT '换取成功时间',
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='余额换代币订单记录';
