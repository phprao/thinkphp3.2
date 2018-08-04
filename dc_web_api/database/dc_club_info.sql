/*
Navicat MySQL Data Transfer

Source Server         : 192.168.1.210
Source Server Version : 50713
Source Host           : 192.168.1.210:3306
Source Database       : dc_xingyun

Target Server Type    : MYSQL
Target Server Version : 50713
File Encoding         : 65001

Date: 2018-06-06 14:33:58
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for dc_club_info
-- ----------------------------
DROP TABLE IF EXISTS `dc_club_info`;
CREATE TABLE `dc_club_info` (
  `club_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '电玩厅id',
  `club_name` varchar(300) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '电玩厅名称',
  `club_channel_id` int(11) DEFAULT '0' COMMENT '渠道ID',
  `club_partner_id` int(11) DEFAULT '0' COMMENT '合作方ID',
  `club_head_image` varchar(300) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '电玩厅头像',
  `club_card_head_image` varchar(300) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '卡管理卡头像',
  `club_status` int(5) DEFAULT '1' COMMENT '状态 0是关闭 1是正常',
  `club_time` int(11) DEFAULT '0' COMMENT '创建时间',
  `club_addr` varchar(250) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '电玩厅地址',
  `club_tel` varchar(20) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '电玩厅电话',
  `club_auth` tinyint(1) DEFAULT '0' COMMENT '是否店铺认证（0为否，1为是）',
  `club_pic` varchar(300) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '店铺实景照片',
  `club_price_to_money` float(11,4) DEFAULT '1.0000' COMMENT '1人民币对应的余额：默认1比1',
  `club_money_rate` float(11,4) DEFAULT '2.0000' COMMENT '1余额对应的代币：默认2',
  `club_lottery_rate` float(11,4) DEFAULT '100.0000' COMMENT '1人民币兑换的彩票数：默认100',
  `club_residue_money` bigint(20) DEFAULT '0' COMMENT '门店剩余余额数',
  `club_card_serial_no` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '场地编号',
  `club_recommend` int(5) DEFAULT '0' COMMENT '是否推荐的',
  PRIMARY KEY (`club_id`),
  UNIQUE KEY `club_id` (`club_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='俱乐部信息';
