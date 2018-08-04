/*
Navicat MySQL Data Transfer

Source Server         : 192.168.1.210
Source Server Version : 50713
Source Host           : 192.168.1.210:3306
Source Database       : dc_xingyun

Target Server Type    : MYSQL
Target Server Version : 50713
File Encoding         : 65001

Date: 2018-06-04 16:40:41
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for dc_player_info
-- ----------------------------
DROP TABLE IF EXISTS `dc_player_info`;
CREATE TABLE `dc_player_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一id',
  `player_id` int(11) DEFAULT '0' COMMENT '玩家id',
  `player_coins` bigint(20) DEFAULT '0' COMMENT '金币',
  `player_masonry` bigint(20) DEFAULT '0' COMMENT '钻石',
  `player_safe_box` bigint(20) unsigned DEFAULT '0' COMMENT '保险箱',
  `player_safe_box_password` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '保险箱密码',
  `player_lottery` int(11) DEFAULT '0' COMMENT '彩票（废弃）',
  `player_club_id` int(11) DEFAULT '0' COMMENT '绑定俱乐部id',
  `player_header_image` varchar(200) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '玩家图像',
  `player_sex` int(11) DEFAULT '1' COMMENT '性别（1男2女）',
  `player_signature` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '玩家个性签名',
  `player_login_time` int(11) DEFAULT '0',
  `player_login_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `player_author` int(2) DEFAULT '0' COMMENT '玩家实名认证',
  PRIMARY KEY (`id`),
  UNIQUE KEY `player_id` (`player_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=496681 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='玩家属性';
