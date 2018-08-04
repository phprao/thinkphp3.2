/*
Navicat MySQL Data Transfer

Source Server         : 192.168.1.210
Source Server Version : 50713
Source Host           : 192.168.1.210:3306
Source Database       : dc_xingyun

Target Server Type    : MYSQL
Target Server Version : 50713
File Encoding         : 65001

Date: 2018-06-11 19:35:50
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for dc_shop_bind_club
-- ----------------------------
DROP TABLE IF EXISTS `dc_shop_bind_club`;
CREATE TABLE `dc_shop_bind_club` (
  `shop_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商家ＩＤ',
  `club_id` int(11) DEFAULT '0' COMMENT '俱乐部ｉｄ',
  `unionid` varchar(300) COLLATE utf8_unicode_ci DEFAULT '',
  `openid` varchar(300) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(300) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '店铺名称',
  `address` varchar(300) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '地址',
  `tel` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '电话',
  `face_img` varchar(300) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '门店图片',
  `qrcode` varchar(300) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '二维码图片',
  `qrcode_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `status` tinyint(3) DEFAULT '1' COMMENT '状态：１－申请，２－取消，３－拒绝，４－通过，５－禁用',
  `refuse_reason` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '拒绝理由',
  `create_time` int(11) DEFAULT '0',
  `cancel_time` int(11) DEFAULT '0' COMMENT '取消时间',
  `approve_time` int(11) DEFAULT '0' COMMENT '通过时间',
  `refuse_time` int(11) DEFAULT '0' COMMENT '拒绝时间',
  `disabled_time` int(11) DEFAULT '0' COMMENT '禁用时间',
  PRIMARY KEY (`shop_id`)
) ENGINE=InnoDB AUTO_INCREMENT=600018 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='商家绑定游艺厅';
