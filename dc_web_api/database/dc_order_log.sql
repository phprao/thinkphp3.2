/*
Navicat MySQL Data Transfer

Source Server         : 192.168.1.210
Source Server Version : 50713
Source Host           : 192.168.1.210:3306
Source Database       : dc_xingyun

Target Server Type    : MYSQL
Target Server Version : 50713
File Encoding         : 65001

Date: 2018-06-06 14:36:53
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for dc_order_log
-- ----------------------------
DROP TABLE IF EXISTS `dc_order_log`;
CREATE TABLE `dc_order_log` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_player_id` int(11) DEFAULT '0' COMMENT '下单玩家',
  `order_club_id` int(11) DEFAULT '0' COMMENT '俱乐部id',
  `order_club_card_type` tinyint(3) DEFAULT '0' COMMENT '卡片类型：1-电子卡，2-实体卡',
  `order_club_card_value` varchar(255) DEFAULT '' COMMENT '卡片标识：电子卡-id，实体卡-club_card_id',
  `order_goods_id` int(11) DEFAULT '0' COMMENT '商品id',
  `order_price` int(11) DEFAULT NULL COMMENT '价格:分',
  `order_get_type` int(11) DEFAULT '2' COMMENT '所得商品类型1.余额2.金币3.彩票4.代币5.钻石',
  `order_get_price` int(11) DEFAULT '0' COMMENT '得到的货币值(如金币数量)',
  `order_pay_type` int(11) DEFAULT '0' COMMENT '支付类型：1=android  2=ios  （未知）',
  `order_is_send` int(11) DEFAULT '0' COMMENT '是否付款0没款1付款',
  `order_sync_status` tinyint(3) DEFAULT '0' COMMENT '实体卡异步订单状态：0-不操作，1-支付成功，2-处理完成，3-处理失败',
  `order_sync_task_id` varchar(255) DEFAULT '' COMMENT '任务order_no',
  `order_orderno` varchar(255) DEFAULT '' COMMENT '订单号',
  `order_out_transaction_id` varchar(255) DEFAULT '' COMMENT '第三方订单号',
  `order_create_time` int(11) DEFAULT '0' COMMENT '下单时间',
  `order_update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  `order_extension` varchar(1000) DEFAULT '' COMMENT '订单的额外信息',
  `order_pay_channel` int(11) DEFAULT '1' COMMENT '支付渠道 1=微信支付，2=支付宝，3=苹果支付，4=web支付，5=优讯支付，6-微信公众号支付',
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16409 DEFAULT CHARSET=utf8 COMMENT='订单表';
