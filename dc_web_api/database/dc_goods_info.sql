/*
Navicat MySQL Data Transfer

Source Server         : 192.168.1.210
Source Server Version : 50713
Source Host           : 192.168.1.210:3306
Source Database       : dc_xingyun

Target Server Type    : MYSQL
Target Server Version : 50713
File Encoding         : 65001

Date: 2018-06-06 14:36:37
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for dc_goods_info
-- ----------------------------
DROP TABLE IF EXISTS `dc_goods_info`;
CREATE TABLE `dc_goods_info` (
  `goods_id` int(11) NOT NULL AUTO_INCREMENT,
  `goods_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '商品名称',
  `goods_price` int(11) DEFAULT '0' COMMENT '单位为分',
  `goods_type` int(11) DEFAULT '0' COMMENT '类型1余额2金币3彩票4代币 5钻石',
  `goods_status` int(11) DEFAULT '1' COMMENT '状态 0 是关闭 1是正常',
  `goods_card` int(11) DEFAULT '0' COMMENT '商品数量',
  `goods_club_id` int(11) DEFAULT '0' COMMENT '俱乐部id',
  `goods_desc` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '商品描述',
  `goods_time` int(11) DEFAULT '0' COMMENT '添加时间',
  `goods_sort` int(11) DEFAULT '1' COMMENT '排序',
  `goods_get_price` bigint(21) DEFAULT '0' COMMENT '得到的货币值(如金币数量)',
  `goods_product_item` int(11) DEFAULT '0' COMMENT '苹果商品id',
  `goods_product_type` int(11) DEFAULT '1' COMMENT '1普通商品2苹果商品',
  `goods_product_id` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '苹果商品支付id',
  PRIMARY KEY (`goods_id`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='商品表';

-- ----------------------------
-- Records of dc_goods_info
-- ----------------------------
INSERT INTO `dc_goods_info` VALUES ('1', '10万金币', '1000', '2', '1', '10', '0', '金币', '1514860349', '1', '100000', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('2', '20万金币', '2000', '2', '1', '20', '3', '金币', '1514860349', '1', '200000', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('3', '50万金币', '5000', '2', '1', '50', '0', '金币', '1514860349', '1', '500000', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('4', '100万金币', '10000', '2', '1', '100', '0', '金币', '1514860349', '1', '1000000', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('5', '200万金币', '20000', '2', '1', '200', '0', '金币', '1514860349', '1', '2000000', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('6', '3000万金币', '30000', '2', '1', '300', '0', '金币', '1514860349', '1', '30000000', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('13', '6钻石', '600', '5', '1', '6', '0', '钻石', '1518141484', '1', '6', '0', '2', 'com.dachuan.cupid4.gold1');
INSERT INTO `dc_goods_info` VALUES ('14', '30钻石', '3000', '5', '1', '30', '0', '钻石', '1518141484', '1', '30', '0', '2', 'com.dachuan.cupid4.gold5');
INSERT INTO `dc_goods_info` VALUES ('15', '68钻石', '6800', '5', '1', '68', '0', '钻石', '1518141484', '1', '68', '0', '2', 'com.dachuan.cupid4.gold10');
INSERT INTO `dc_goods_info` VALUES ('16', '128钻石', '12800', '5', '1', '128', '0', '钻石', '1518141484', '1', '128', '0', '2', 'com.dachuan.cupid4.gold20');
INSERT INTO `dc_goods_info` VALUES ('17', '198钻石', '19800', '5', '1', '198', '0', '钻石', '1518141484', '1', '198', '0', '2', 'com.dachuan.cupid4.gold30');
INSERT INTO `dc_goods_info` VALUES ('18', '288钻石', '28800', '5', '1', '288', '0', '钻石', '1518141484', '1', '288', '0', '2', 'com.dachuan.cupid4.gold46');
INSERT INTO `dc_goods_info` VALUES ('19', '42000金币', '600', '2', '1', '42000', '0', '金币', '1514860349', '1', '42000', '0', '2', 'com.dachuan.cupid4.gold1');
INSERT INTO `dc_goods_info` VALUES ('20', '210000金币', '3000', '2', '1', '210000', '0', '金币', '1514860349', '1', '210000', '0', '2', 'com.dachuan.cupid4.gold5');
INSERT INTO `dc_goods_info` VALUES ('21', '476000金币', '6800', '2', '1', '476000', '0', '金币', '1514860349', '1', '476000', '0', '2', 'com.dachuan.cupid4.gold10');
INSERT INTO `dc_goods_info` VALUES ('22', '896000金币', '12800', '2', '1', '896000', '0', '金币', '1514860349', '1', '896000', '0', '2', 'com.dachuan.cupid4.gold20');
INSERT INTO `dc_goods_info` VALUES ('23', '1386000金币', '19800', '2', '1', '1386000', '0', '金币', '1514860349', '1', '1386000', '0', '2', 'com.dachuan.cupid4.gold30');
INSERT INTO `dc_goods_info` VALUES ('24', '2016000金币', '28800', '2', '1', '2016000', '0', '金币', '1514860349', '1', '2016000', '0', '2', 'com.dachuan.cupid4.gold46');
INSERT INTO `dc_goods_info` VALUES ('25', '10代币', '1000', '4', '1', '10', '1', '代币', '1514860349', '1', '10', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('26', '20代币', '2000', '4', '1', '20', '1', '代币', '1514860349', '2', '20', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('27', '50代币', '5000', '4', '1', '50', '1', '代币', '1514860349', '3', '50', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('28', '100代币', '10000', '4', '1', '100', '1', '代币', '1514860349', '4', '100', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('29', '200代币', '20000', '4', '1', '200', '1', '代币', '1514860349', '5', '200', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('30', '3000代币', '30000', '4', '1', '300', '1', '金币', '1514860349', '6', '3000', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('37', '10代币', '1000', '4', '1', '10', '0', '代币', '1514860349', '2', '10', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('38', '20代币', '2000', '4', '1', '20', '0', '代币', '1514860349', '1', '20', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('39', '50代币', '5000', '4', '1', '50', '0', '代币', '1514860349', '1', '50', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('40', '100代币', '10000', '4', '1', '100', '0', '代币', '1514860349', '1', '100', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('41', '200代币', '20000', '4', '1', '200', '0', '代币', '1514860349', '1', '200', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('42', '3000代币', '30000', '4', '1', '300', '0', '金币', '1514860349', '3', '3000', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('43', '10余额', '1000', '1', '1', '10', '0', '余额', '1514860349', '4', '10', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('44', '20余额', '2000', '1', '1', '20', '0', '余额', '1514860349', '1', '20', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('45', '50余额', '5000', '1', '1', '50', '0', '余额', '1514860349', '1', '50', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('46', '100余额', '10000', '1', '1', '100', '0', '余额', '1514860349', '1', '100', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('47', '200余额', '20000', '1', '1', '200', '0', '余额', '1514860349', '1', '200', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('48', '3000余额', '30000', '1', '1', '300', '0', '余额', '1514860349', '1', '300', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('49', '10余额', '1000', '1', '1', '10', '1', '余额', '1527668906', '4', '10', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('50', '20余额', '2000', '1', '1', '20', '1', '余额', '1527668906', '1', '20', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('51', '50余额', '5000', '1', '1', '50', '1', '余额', '1527668906', '1', '50', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('52', '100余额', '10000', '1', '1', '100', '1', '余额', '1527668907', '1', '100', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('53', '200余额', '20000', '1', '1', '200', '1', '余额', '1527668907', '1', '200', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('54', '3000余额', '30000', '1', '1', '300', '1', '余额', '1527668907', '1', '300', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('56', '10代币', '1000', '4', '1', '10', '96', '代币', '1528169236', '2', '10', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('57', '20代币', '2000', '4', '1', '20', '96', '代币', '1528169236', '1', '20', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('58', '50代币', '5000', '4', '1', '50', '96', '代币', '1528169236', '1', '50', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('59', '100代币', '10000', '4', '1', '100', '96', '代币', '1528169236', '1', '100', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('60', '200代币', '20000', '4', '1', '200', '96', '代币', '1528169236', '1', '200', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('61', '3000代币', '30000', '4', '1', '300', '96', '金币', '1528169236', '3', '3000', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('62', '10余额', '1000', '1', '1', '10', '96', '余额', '1528169236', '4', '10', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('63', '20余额', '2000', '1', '1', '20', '96', '余额', '1528169236', '1', '20', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('64', '50余额', '5000', '1', '1', '50', '96', '余额', '1528169236', '1', '50', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('65', '100余额', '10000', '1', '1', '100', '96', '余额', '1528169236', '1', '100', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('66', '200余额', '20000', '1', '1', '200', '96', '余额', '1528169236', '1', '200', '0', '1', '');
INSERT INTO `dc_goods_info` VALUES ('67', '3000余额', '30000', '1', '1', '300', '96', '余额', '1528169236', '1', '300', '0', '1', '');
