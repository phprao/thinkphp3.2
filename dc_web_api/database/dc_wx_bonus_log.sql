/*
Navicat MySQL Data Transfer

Source Server         : 192.168.1.210
Source Server Version : 50713
Source Host           : 192.168.1.210:3306
Source Database       : dc_xingyun

Target Server Type    : MYSQL
Target Server Version : 50713
File Encoding         : 65001

Date: 2018-06-14 18:15:11
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for dc_wx_bonus_log
-- ----------------------------
DROP TABLE IF EXISTS `dc_wx_bonus_log`;
CREATE TABLE `dc_wx_bonus_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(11) unsigned DEFAULT '1' COMMENT '来源：1-商家彩票兑换',
  `type_id_ext` int(11) DEFAULT '0' COMMENT '额外的分类',
  `receiver_id` int(11) unsigned DEFAULT '0' COMMENT '红包接受者id，player_id，shop_id等',
  `openid` varchar(100) DEFAULT '' COMMENT '星云公众号的 openid',
  `unionid` varchar(100) DEFAULT '' COMMENT '平台唯一标识',
  `mch_billno` varchar(40) DEFAULT '' COMMENT '本地订单编号',
  `send_listid` varchar(32) DEFAULT '' COMMENT '红包订单编号，微信返回的',
  `total_amount` float(6,2) unsigned DEFAULT '0.00' COMMENT '红包总金额：元',
  `total_num` smallint(5) unsigned DEFAULT '1' COMMENT '红包发送总人数',
  `status` tinyint(4) DEFAULT '0' COMMENT '红包状态：\r\n0-未处理\r\n1-SENDING:发放中\r\n2-SENT:已发放待领取\r\n3-FAILED：发放失败\r\n4-RECEIVED:已领取\r\n5-RFUND_ING:退款中\r\n6-REFUND:已退款',
  `send_time` varchar(30) DEFAULT '' COMMENT '发送红包时间',
  `receive_time` varchar(30) DEFAULT '' COMMENT '领取时间',
  `refund_time` varchar(30) DEFAULT '' COMMENT '退回时间',
  `create_time` int(11) DEFAULT '0',
  `create_date` varchar(30) DEFAULT '' COMMENT '写入时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
