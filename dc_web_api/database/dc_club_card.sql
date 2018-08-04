/*
Navicat MySQL Data Transfer

Source Server         : 192.168.1.210
Source Server Version : 50713
Source Host           : 192.168.1.210:3306
Source Database       : dc_xingyun

Target Server Type    : MYSQL
Target Server Version : 50713
File Encoding         : 65001

Date: 2018-06-06 14:33:46
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for dc_club_card
-- ----------------------------
DROP TABLE IF EXISTS `dc_club_card`;
CREATE TABLE `dc_club_card` (
  `club_card_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一id',
  `club_card_app_id` int(11) DEFAULT '0' COMMENT '项目id(1:优讯)',
  `club_card_serial_no` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '场地编号',
  `club_card_card_no` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '会员卡号',
  `club_card_member_no` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '会员编号',
  `club_card_status` int(11) DEFAULT '0' COMMENT '状态(1:绑定中,2:绑定完成)',
  `club_card_player_id` int(11) DEFAULT '0' COMMENT '玩家id',
  `club_card_club_id` int(11) DEFAULT '0' COMMENT '俱乐部id',
  `club_card_pwd_check` int(11) DEFAULT '0',
  `club_card_user_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '用户名',
  `club_card_task_id` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '任务id备用',
  `club_card_token` bigint(20) DEFAULT '0' COMMENT '代币',
  `club_card_card_amount` bigint(20) DEFAULT '0' COMMENT '余额',
  `club_card_lottery` bigint(20) DEFAULT '0' COMMENT '彩票',
  `join_time` int(11) DEFAULT '0' COMMENT '加入',
  `update_time` int(11) DEFAULT '0' COMMENT '改变时间',
  PRIMARY KEY (`club_card_id`),
  KEY `club_card_id` (`club_card_id`)
) ENGINE=InnoDB AUTO_INCREMENT=377 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='玩家实体卡信息';
