/*
Navicat MySQL Data Transfer

Source Server         : 192.168.1.210
Source Server Version : 50713
Source Host           : 192.168.1.210:3306
Source Database       : dc_xingyun

Target Server Type    : MYSQL
Target Server Version : 50713
File Encoding         : 65001

Date: 2018-05-30 19:06:42
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for dc_admin_users
-- ----------------------------
DROP TABLE IF EXISTS `dc_admin_users`;
CREATE TABLE `dc_admin_users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_login` varchar(60) NOT NULL DEFAULT '' COMMENT '用户名',
  `user_type` tinyint(4) DEFAULT '1' COMMENT '账号类型：1-俱乐部，2-合作方，3-公司',
  `user_pass` varchar(64) NOT NULL DEFAULT '' COMMENT '登录密码；sp_password加密',
  `user_real_name` varchar(50) NOT NULL DEFAULT '' COMMENT '玩家真实姓名',
  `user_identity_card` char(18) NOT NULL DEFAULT '' COMMENT '身份证',
  `user_phone` char(11) NOT NULL DEFAULT '' COMMENT '用户手机',
  `user_email` varchar(64) NOT NULL DEFAULT '' COMMENT '用户邮箱',
  `user_status` int(11) NOT NULL DEFAULT '1' COMMENT '用户状态 0：禁用； 1：正常 ；2：未验证',
  `user_agent_id` int(11) NOT NULL DEFAULT '0' COMMENT '关联的代理商ID',
  `player_id` int(11) NOT NULL DEFAULT '0' COMMENT '关联的游戏用户ID',
  `user_is_agree` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否同意推广协议 0.不同意 1.同意',
  `last_login_ip` varchar(16) NOT NULL DEFAULT '' COMMENT '最后登录ip',
  `last_login_time` datetime NOT NULL DEFAULT '2001-01-01 00:00:00' COMMENT '最后登录时间',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '注册时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_login_key` (`user_login`),
  KEY `union_key` (`user_phone`,`user_status`,`user_agent_id`,`player_id`)
) ENGINE=InnoDB AUTO_INCREMENT=141 DEFAULT CHARSET=utf8 COMMENT='用户表';

-- ----------------------------
-- Table structure for dc_change_money_info
-- ----------------------------
DROP TABLE IF EXISTS `dc_change_money_info`;
CREATE TABLE `dc_change_money_info` (
  `change_money_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一id',
  `change_money_player_id` int(11) DEFAULT '0' COMMENT '玩家id',
  `change_money_player_club_id` int(11) DEFAULT '0' COMMENT '玩家所在俱乐部id',
  `change_money_club_id` int(11) DEFAULT '0' COMMENT '俱乐部id',
  `change_money_club_room_id` int(11) DEFAULT '0' COMMENT '俱乐部房间id',
  `change_money_club_desk_no` int(11) DEFAULT '0' COMMENT '俱乐部桌子号',
  `change_money_club_desk_id` int(11) DEFAULT '0' COMMENT '桌子唯一id',
  `change_money_club_room_no` int(11) DEFAULT '0' COMMENT '包间号',
  `change_money_game_id` int(11) DEFAULT '0' COMMENT '游戏id',
  `change_money_room_id` int(11) DEFAULT '0' COMMENT '房间id',
  `change_money_desk_no` int(11) DEFAULT '0' COMMENT '桌子号',
  `change_money_type` int(11) DEFAULT '1' COMMENT '数据改变类型(1:充值金币,2:游戏消耗(包括服务费),3:单扣服务费、4新用户注册赠送)5.钻石对换 6.金库出入 7.道具消耗，10-充值余额',
  `change_money_tax` int(11) unsigned DEFAULT '0' COMMENT '服务费(税)',
  `change_money_money_type` int(11) DEFAULT '0' COMMENT '货币类型：1-金币，2-余额',
  `change_money_money_value` bigint(20) DEFAULT '0' COMMENT '改变货币值',
  `change_money_begin_value` bigint(20) DEFAULT '0' COMMENT '改变前数据',
  `change_money_after_value` bigint(20) DEFAULT '0' COMMENT '改变后数据',
  `change_money_time` int(11) DEFAULT '0' COMMENT '记录时间',
  `change_money_param` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '订单信息price_value(订单金额：分)',
  UNIQUE KEY `change_money_id` (`change_money_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2499 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='货币币消耗数据信息队列(redis同步到database)';

-- ----------------------------
-- Table structure for dc_change_money_info_record
-- ----------------------------
DROP TABLE IF EXISTS `dc_change_money_info_record`;
CREATE TABLE `dc_change_money_info_record` (
  `change_money_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一id',
  `change_money_player_id` int(11) DEFAULT '0' COMMENT '玩家id',
  `change_money_player_club_id` int(11) DEFAULT '0' COMMENT '玩家所在俱乐部id',
  `change_money_club_id` int(11) DEFAULT '0' COMMENT '俱乐部id',
  `change_money_club_room_id` int(11) DEFAULT '0' COMMENT '俱乐部房间id',
  `change_money_club_desk_no` int(11) DEFAULT '0' COMMENT '俱乐部桌子号',
  `change_money_club_desk_id` int(11) DEFAULT '0' COMMENT '桌子唯一id',
  `change_money_club_room_no` int(11) DEFAULT '0' COMMENT '包间号',
  `change_money_game_id` int(11) DEFAULT '0' COMMENT '游戏id',
  `change_money_room_id` int(11) DEFAULT '0' COMMENT '房间id',
  `change_money_desk_no` int(11) DEFAULT '0' COMMENT '桌子号',
  `change_money_type` int(11) DEFAULT '1' COMMENT '数据改变类型(1:充值,2:游戏消耗)',
  `change_money_tax` int(11) unsigned DEFAULT '0' COMMENT '服务费(税)',
  `change_money_money_type` int(11) DEFAULT '0' COMMENT '货币类型',
  `change_money_money_value` bigint(20) DEFAULT '0' COMMENT '改变货币值',
  `change_money_begin_value` bigint(20) DEFAULT '0' COMMENT '改变前数据',
  `change_money_after_value` bigint(20) DEFAULT '0' COMMENT '改变后数据',
  `change_money_time` int(11) DEFAULT '0' COMMENT '记录时间',
  `change_money_param` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '保留字段',
  UNIQUE KEY `change_money_id` (`change_money_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='货币币消耗数据信息记录，数据保存3-5个月  备份表';

-- ----------------------------
-- Table structure for dc_channel
-- ----------------------------
DROP TABLE IF EXISTS `dc_channel`;
CREATE TABLE `dc_channel` (
  `channel_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '管理系统表主键',
  `channel_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '管理系统名称',
  `channel_status` int(1) DEFAULT '1' COMMENT '0不可用，1可用',
  `channel_desc` varchar(300) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '详细描述',
  `channel_time` int(11) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`channel_id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='管理系统（渠道）表';

-- ----------------------------
-- Table structure for dc_channel_divide
-- ----------------------------
DROP TABLE IF EXISTS `dc_channel_divide`;
CREATE TABLE `dc_channel_divide` (
  `divide_id` int(11) NOT NULL AUTO_INCREMENT,
  `divide_channel_id` int(11) DEFAULT NULL COMMENT '渠道商的ID',
  `divide_proportion` int(10) DEFAULT '0' COMMENT '分成比列',
  `divide_time` int(11) DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`divide_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='渠道分成比列表';

-- ----------------------------
-- Table structure for dc_channel_user
-- ----------------------------
DROP TABLE IF EXISTS `dc_channel_user`;
CREATE TABLE `dc_channel_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `channel_id` int(11) DEFAULT '0' COMMENT '管理系统表的主键id',
  `user_id` int(11) DEFAULT '0' COMMENT '星云系统中的用户ID',
  `role_id` int(11) DEFAULT '0' COMMENT '权限ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for dc_club_admin_user
-- ----------------------------
DROP TABLE IF EXISTS `dc_club_admin_user`;
CREATE TABLE `dc_club_admin_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `club_id` int(11) DEFAULT '0' COMMENT '俱乐部的主键id',
  `user_id` int(11) DEFAULT '0' COMMENT '星云系统中的用户ID',
  `role_id` int(11) DEFAULT '0' COMMENT '权限ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
) ENGINE=InnoDB AUTO_INCREMENT=367 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='玩家实体卡信息';

-- ----------------------------
-- Table structure for dc_club_card_default_icon
-- ----------------------------
DROP TABLE IF EXISTS `dc_club_card_default_icon`;
CREATE TABLE `dc_club_card_default_icon` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `img_url` varchar(300) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '默认图片的地址',
  `status` int(1) DEFAULT '1' COMMENT '1可用，0不可用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for dc_club_coin_info
-- ----------------------------
DROP TABLE IF EXISTS `dc_club_coin_info`;
CREATE TABLE `dc_club_coin_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coin_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '货币名字',
  `coin_key_name` varchar(50) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '类型name',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for dc_club_coin_type
-- ----------------------------
DROP TABLE IF EXISTS `dc_club_coin_type`;
CREATE TABLE `dc_club_coin_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `club_id` int(11) DEFAULT '0' COMMENT '场地ID',
  `coin_id` int(11) DEFAULT '0' COMMENT '货币ID',
  `status` int(1) DEFAULT '0' COMMENT '0不可用1可用',
  `sort_id` int(11) DEFAULT '0' COMMENT '排序ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for dc_club_desk
-- ----------------------------
DROP TABLE IF EXISTS `dc_club_desk`;
CREATE TABLE `dc_club_desk` (
  `club_desk_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一id',
  `club_desk_club_id` int(11) DEFAULT '0' COMMENT '俱乐部id',
  `club_desk_club_room_id` int(11) DEFAULT '0' COMMENT '俱乐部房间id',
  `club_desk_club_room_desk_no` int(11) DEFAULT '0' COMMENT '俱乐部桌子号',
  `club_desk_game_id` int(11) DEFAULT '0' COMMENT '游戏id',
  `club_desk_room_id` int(11) DEFAULT '0' COMMENT '房间id',
  `club_desk_desk_no` int(11) DEFAULT '0' COMMENT '桌子id',
  `club_desk_room_no` int(11) DEFAULT '0' COMMENT '包间号',
  `club_desk_player_id` int(11) DEFAULT '0' COMMENT '玩家id(创建者,备用字段)',
  `club_desk_param` varchar(1024) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '桌子参数',
  `club_desk_time` int(11) DEFAULT '0' COMMENT '时间',
  `club_desk_status` int(11) DEFAULT '1' COMMENT '状态',
  PRIMARY KEY (`club_desk_id`),
  UNIQUE KEY `club_desk_id` (`club_desk_id`) USING HASH
) ENGINE=InnoDB AUTO_INCREMENT=23704 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='俱乐部信息表';

-- ----------------------------
-- Table structure for dc_club_desk_record
-- ----------------------------
DROP TABLE IF EXISTS `dc_club_desk_record`;
CREATE TABLE `dc_club_desk_record` (
  `club_desk_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一id',
  `club_desk_club_id` int(11) DEFAULT '0' COMMENT '俱乐部id',
  `club_desk_club_room_id` int(11) DEFAULT '0' COMMENT '俱乐部房间id',
  `club_desk_club_room_desk_no` int(11) DEFAULT '0' COMMENT '俱乐部桌子号',
  `club_desk_game_id` int(11) DEFAULT '0' COMMENT '游戏id',
  `club_desk_room_id` int(11) DEFAULT '0' COMMENT '房间id',
  `club_desk_desk_no` int(11) DEFAULT '0' COMMENT '桌子id',
  `club_desk_room_no` int(11) DEFAULT '0' COMMENT '包间号',
  `club_desk_player_id` int(11) DEFAULT '0' COMMENT '创建者玩家id',
  `club_desk_param` varchar(1024) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '桌子参数',
  `club_desk_time` int(11) DEFAULT '0' COMMENT '时间',
  `club_desk_status` int(11) DEFAULT '0' COMMENT '状态',
  PRIMARY KEY (`club_desk_id`),
  KEY `club_desk_id` (`club_desk_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=23698 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='俱乐部信息表';

-- ----------------------------
-- Table structure for dc_club_game
-- ----------------------------
DROP TABLE IF EXISTS `dc_club_game`;
CREATE TABLE `dc_club_game` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一id',
  `club_id` int(11) DEFAULT '0' COMMENT '俱乐部id',
  `game_id` int(11) DEFAULT '0' COMMENT '游戏id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `club_id` (`game_id`)
) ENGINE=InnoDB AUTO_INCREMENT=208 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='俱乐部游戏';

-- ----------------------------
-- Table structure for dc_club_game_config
-- ----------------------------
DROP TABLE IF EXISTS `dc_club_game_config`;
CREATE TABLE `dc_club_game_config` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增长ID',
  `club_id` int(11) NOT NULL COMMENT '俱乐部ID',
  `club_room_id` int(11) NOT NULL COMMENT '游戏俱乐部房间ID',
  `game_level` tinyint(6) NOT NULL COMMENT '游戏难度等级',
  `exchange_percent` int(11) NOT NULL COMMENT '彩票产出率',
  `rule_param` varchar(1024) COLLATE utf8_unicode_ci DEFAULT '{}' COMMENT '游戏中的特殊玩法',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
  `club_price_to_money` int(11) DEFAULT '10000' COMMENT '1人民币对应的余额（*1000）：本为四位小数，默认1比1',
  `club_money_rate` int(11) DEFAULT '2' COMMENT '1余额对应的代币：默认2',
  `club_lottery_rate` int(11) DEFAULT '0' COMMENT '1人民币兑换的彩票数',
  `club_residue_money` bigint(20) DEFAULT '0' COMMENT '门店剩余余额数',
  `club_card_serial_no` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '场地编号',
  `club_recommend` int(5) DEFAULT '0' COMMENT '是否推荐的',
  PRIMARY KEY (`club_id`),
  UNIQUE KEY `club_id` (`club_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='俱乐部信息';

-- ----------------------------
-- Table structure for dc_club_money_log
-- ----------------------------
DROP TABLE IF EXISTS `dc_club_money_log`;
CREATE TABLE `dc_club_money_log` (
  `club_money_id` int(11) NOT NULL COMMENT '主键ID',
  `club_money_clubinfo_id` int(11) DEFAULT '0' COMMENT '（俱乐部）门店DI',
  `club_before_money` bigint(20) DEFAULT '0' COMMENT '修改前余额',
  `club_money` bigint(20) DEFAULT '0' COMMENT '修改的余额',
  `club_after_money` bigint(20) DEFAULT '0' COMMENT '修改后余额',
  `club_money_time` int(11) DEFAULT '0' COMMENT '生成时间',
  `club_money_desc` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`club_money_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for dc_club_player
-- ----------------------------
DROP TABLE IF EXISTS `dc_club_player`;
CREATE TABLE `dc_club_player` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一id',
  `club_id` int(11) DEFAULT '0' COMMENT '俱乐部id',
  `player_id` int(11) DEFAULT NULL COMMENT '玩家ID',
  `player_tokens` bigint(20) DEFAULT '0' COMMENT '代币',
  `player_lottery` bigint(20) DEFAULT '0' COMMENT '彩票',
  `player_amount` bigint(20) DEFAULT '0' COMMENT '余额',
  `player_zombie_coin` bigint(20) DEFAULT '0' COMMENT '僵尸金币',
  `join_time` int(11) DEFAULT '0' COMMENT '加入时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2071 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='玩家和俱乐部信息表（玩家电子卡信息）';

-- ----------------------------
-- Table structure for dc_club_room
-- ----------------------------
DROP TABLE IF EXISTS `dc_club_room`;
CREATE TABLE `dc_club_room` (
  `club_room_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一id',
  `club_room_club_id` int(11) DEFAULT '0' COMMENT '俱乐部id',
  `club_room_game_id` int(11) DEFAULT '0' COMMENT '游戏id',
  `club_room_desk_count` int(11) DEFAULT '100' COMMENT '桌子数',
  `club_room_is_work` int(11) DEFAULT '0' COMMENT '是否开启(1是开启)',
  `club_room_is_open` int(11) DEFAULT '0' COMMENT '作为dc_room_info 字段的is_open',
  `club_room_type` int(11) DEFAULT '1' COMMENT '房间类型,1:坐下,2:搓桌,3:搓桌2,4: 创建包间',
  `club_room_level` int(11) DEFAULT '0' COMMENT '房间等级',
  `club_room_basic_points` int(11) DEFAULT '0' COMMENT '底分',
  `club_room_min_coin` int(11) DEFAULT '0' COMMENT '最低金币',
  `club_room_max_coin` int(11) DEFAULT '0' COMMENT '最大金币',
  `club_room_rule_id` int(11) DEFAULT '0' COMMENT '规则玩法id(dc_club_rule)',
  `club_room_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '房间名',
  `club_room_desk_param` varchar(1024) COLLATE utf8_unicode_ci DEFAULT '{}' COMMENT '桌子玩法',
  PRIMARY KEY (`club_room_id`),
  KEY `club_room_club_id` (`club_room_club_id`),
  KEY `club_room_game_id` (`club_room_game_id`),
  KEY `club_room_is_work` (`club_room_is_work`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='俱乐部房间信息 (虚拟出的房间信息)';

-- ----------------------------
-- Table structure for dc_club_rule
-- ----------------------------
DROP TABLE IF EXISTS `dc_club_rule`;
CREATE TABLE `dc_club_rule` (
  `club_room_rule_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一id',
  `club_room_rule_game_id` int(11) DEFAULT '0' COMMENT '游戏id',
  `club_room_rule_club_id` int(11) DEFAULT '0' COMMENT '俱乐部id',
  `club_room_rule_name` varchar(11) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '名称',
  `club_room_rule_param` varchar(1024) COLLATE utf8_unicode_ci DEFAULT '{}' COMMENT '玩法规则',
  `club_room_rule_status` int(11) DEFAULT '1' COMMENT '状态0是禁用1是开启',
  UNIQUE KEY `club_room_rule_id` (`club_room_rule_id`) USING HASH
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='游戏规则表';

-- ----------------------------
-- Table structure for dc_config
-- ----------------------------
DROP TABLE IF EXISTS `dc_config`;
CREATE TABLE `dc_config` (
  `config_id` int(11) NOT NULL AUTO_INCREMENT,
  `config_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '名称',
  `config_desc` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `config_type` tinyint(3) DEFAULT '0' COMMENT '类型：待定',
  `config_start_time` int(11) DEFAULT '0' COMMENT '开始时间',
  `config_end_time` int(11) DEFAULT '0' COMMENT '结束时间',
  `config_config` varchar(500) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '配置',
  `config_status` int(5) DEFAULT '1' COMMENT '状态 0 关闭 1 正常',
  `config_create_time` int(11) DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='综合配置表';

-- ----------------------------
-- Table structure for dc_feedback
-- ----------------------------
DROP TABLE IF EXISTS `dc_feedback`;
CREATE TABLE `dc_feedback` (
  `feedback_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `feedback_content` varchar(200) NOT NULL DEFAULT '' COMMENT '反馈的内容',
  `feedback_player_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '反馈的用户id',
  `feedback_create_time` int(10) NOT NULL DEFAULT '0' COMMENT '反馈的时间',
  PRIMARY KEY (`feedback_id`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8 COMMENT='反馈信息表';

-- ----------------------------
-- Table structure for dc_game_beat_record
-- ----------------------------
DROP TABLE IF EXISTS `dc_game_beat_record`;
CREATE TABLE `dc_game_beat_record` (
  `game_beat_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '战绩id',
  `game_beat_board_id` int(11) DEFAULT '0' COMMENT '对应牌局id',
  `game_beat_player_id` int(11) DEFAULT '0' COMMENT '玩家id',
  `game_beat_player_nick` varchar(300) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '玩家昵称',
  `game_beat_player_head` varchar(300) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '玩家头像',
  `game_beat_room_no` int(11) DEFAULT '0' COMMENT '包间战绩>0，金币场=0',
  `game_beat_readback` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '录像',
  `game_beat_over_time` int(11) DEFAULT '0' COMMENT '游戏结束时间',
  `game_beat_game_id` int(11) DEFAULT '0' COMMENT '游戏id',
  `game_beat_game_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '游戏名称',
  `game_beat_player_club_id` int(22) DEFAULT '0' COMMENT '玩家所在俱乐部id',
  `game_beat_club_id` int(11) DEFAULT '0' COMMENT '俱乐部id',
  `game_beat_win_state` tinyint(2) DEFAULT '0' COMMENT '输赢状态(0:输,1:赢)',
  `game_beat_score_type` int(11) DEFAULT '1' COMMENT '输赢分数类型(1:金币',
  `game_beat_score_value` int(11) DEFAULT '0' COMMENT '输赢分数值',
  `game_beat_time` int(11) DEFAULT '0' COMMENT '时间',
  `game_beat_room_id` int(11) DEFAULT '0' COMMENT '房间ID',
  `game_beat_room_name` varchar(50) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '房间名称',
  PRIMARY KEY (`game_beat_id`),
  KEY `game_beat_board_id` (`game_beat_board_id`) USING BTREE,
  KEY `game_beat_player_id` (`game_beat_player_id`) USING BTREE,
  KEY `game_beat_over_time` (`game_beat_over_time`) USING BTREE,
  KEY `game_beat_game_id` (`game_beat_game_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=102731 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for dc_game_board_info
-- ----------------------------
DROP TABLE IF EXISTS `dc_game_board_info`;
CREATE TABLE `dc_game_board_info` (
  `game_board_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一id',
  `game_board_room_id` int(11) DEFAULT '0' COMMENT '游戏房间id',
  `game_board_desk_no` int(11) DEFAULT '0' COMMENT '游戏桌子号',
  `game_board_game_over_time` int(11) DEFAULT '0' COMMENT '游戏一局结束时间',
  `game_board_time` int(11) DEFAULT '0' COMMENT '记录时间',
  PRIMARY KEY (`game_board_id`),
  UNIQUE KEY `game_board_id` (`game_board_id`) USING BTREE,
  KEY `game_board_room_id` (`game_board_room_id`) USING BTREE,
  KEY `game_board_desk_no` (`game_board_desk_no`) USING BTREE,
  KEY `game_board_game_over_time` (`game_board_game_over_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10031669 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='生成牌局id辅助表(数据可以保留1周时间)';

-- ----------------------------
-- Table structure for dc_game_info
-- ----------------------------
DROP TABLE IF EXISTS `dc_game_info`;
CREATE TABLE `dc_game_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一id',
  `game_id` int(11) DEFAULT '0' COMMENT '游戏id',
  `game_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '游戏名字',
  `game_desk_members_count` int(11) DEFAULT '0' COMMENT '桌子人数',
  `game_kind` int(11) DEFAULT '1' COMMENT '游戏分类 1麻将 2牌类 3字牌',
  `game_version` int(11) DEFAULT '0' COMMENT '游戏服务端版本',
  `game_status` int(11) DEFAULT '0' COMMENT '状态 0为禁用 1为启用',
  `game_type` int(1) DEFAULT '0' COMMENT '游戏开房模式。1搓桌房，2好友，,0都有',
  `game_free` int(11) DEFAULT '0' COMMENT '0收费 1不收费',
  `game_sit_random` int(11) DEFAULT '0' COMMENT '1随机坐桌',
  `game_dissolve_time` int(11) DEFAULT '100' COMMENT '解散时间',
  `game_deduction_rate` int(11) DEFAULT '100' COMMENT '扣费率',
  `game_play_count` int(11) DEFAULT '0' COMMENT '每单位费用玩多少局',
  `game_active_time` int(11) DEFAULT '0' COMMENT '桌子有效时间(单位分)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `game_id` (`game_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='游戏信息';

-- ----------------------------
-- Table structure for dc_game_kind
-- ----------------------------
DROP TABLE IF EXISTS `dc_game_kind`;
CREATE TABLE `dc_game_kind` (
  `game_kind_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键,作为游戏分类的id',
  `game_kind_name` varchar(55) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '分类名称',
  `game_kind_type` tinyint(1) DEFAULT '1' COMMENT '扩展字段',
  `game_kind_time` int(11) DEFAULT '0' COMMENT '分类创建时间',
  PRIMARY KEY (`game_kind_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for dc_game_record
-- ----------------------------
DROP TABLE IF EXISTS `dc_game_record`;
CREATE TABLE `dc_game_record` (
  `game_record_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一id',
  `game_record_player_id` int(11) DEFAULT '0' COMMENT '玩家id',
  `game_record_player_club_id` int(11) DEFAULT '0' COMMENT '玩家所在俱乐部id',
  `game_record_club_id` int(11) DEFAULT '0' COMMENT '俱乐部id',
  `game_record_club_room_id` int(11) DEFAULT '0' COMMENT '俱乐部房间id',
  `game_record_club_room_desk_no` int(11) DEFAULT '0' COMMENT '俱乐部桌子号',
  `game_record_club_desk_id` int(11) DEFAULT '0' COMMENT '俱乐部桌子id',
  `game_record_club_room_no` int(11) DEFAULT '0' COMMENT '包间号',
  `game_record_game_id` int(11) DEFAULT '0' COMMENT '游戏id',
  `game_record_room_id` int(11) DEFAULT '0' COMMENT '房间id',
  `game_record_desk_no` int(11) DEFAULT '0' COMMENT '桌子号',
  `game_record_win_state` int(11) DEFAULT '0' COMMENT '输赢状态(0:输,1:赢)',
  `game_record_score_type` int(11) DEFAULT '1' COMMENT '输赢分数类型(1:金币)',
  `game_record_score_value` int(11) DEFAULT '0' COMMENT '输赢分数值',
  `game_record_game_over_time` int(11) DEFAULT '0' COMMENT '游戏结束时间',
  `game_record_time` int(11) DEFAULT '0' COMMENT '记录时间',
  `game_record_desc` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '备注',
  `game_record_param` varchar(512) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '保留参数',
  `game_record_data_type` int(11) DEFAULT '0' COMMENT '游戏数据类型',
  `game_record_data_value` text COLLATE utf8_unicode_ci COMMENT '游戏数据值',
  PRIMARY KEY (`game_record_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17035 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='游戏记录数据  队列';

-- ----------------------------
-- Table structure for dc_game_record_log
-- ----------------------------
DROP TABLE IF EXISTS `dc_game_record_log`;
CREATE TABLE `dc_game_record_log` (
  `game_log_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '唯一id',
  `game_log_board_id` varchar(30) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '牌局id',
  `game_log_player_id` int(11) DEFAULT '0' COMMENT '玩家id',
  `game_log_player_club_id` int(11) DEFAULT '0' COMMENT '玩家所在俱乐部id',
  `game_log_club_id` int(11) DEFAULT '0' COMMENT '俱乐部id',
  `game_log_club_room_id` int(11) DEFAULT '0' COMMENT '俱乐部房间id',
  `game_log_club_room_desk_no` int(11) DEFAULT '0' COMMENT '俱乐部桌子号',
  `game_log_club_desk_id` int(11) DEFAULT '0' COMMENT '俱乐部桌子id',
  `game_log_club_room_no` int(11) DEFAULT '0' COMMENT '包间号',
  `game_log_game_id` int(11) DEFAULT '0' COMMENT '游戏id',
  `game_log_room_id` int(11) DEFAULT '0' COMMENT '房间id',
  `game_log_desk_no` int(11) DEFAULT '0' COMMENT '桌子号',
  `game_log_win_state` int(11) DEFAULT '0' COMMENT '输赢状态(0:输,1:赢)',
  `game_log_score_type` int(11) DEFAULT '1' COMMENT '输赢分数类型(1:金币)',
  `game_log_score_value` int(11) DEFAULT '0' COMMENT '输赢分数值',
  `game_log_game_over_time` int(11) DEFAULT '0' COMMENT '游戏结束时间',
  `game_log_desc` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '备注',
  `game_log_param` varchar(512) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '保留参数',
  `game_log_data_type` int(11) DEFAULT '0' COMMENT '游戏数据类型',
  `game_log_data_value` text COLLATE utf8_unicode_ci COMMENT '游戏数据值',
  `game_log_game_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '游戏名称',
  `game_log_time` int(11) DEFAULT '0' COMMENT '记录时间',
  `game_log_data` varchar(30) COLLATE utf8_unicode_ci DEFAULT '',
  UNIQUE KEY `game_log_id` (`game_log_id`) USING BTREE,
  KEY `game_log_board_id` (`game_log_board_id`) USING BTREE,
  KEY `game_log_player_id` (`game_log_player_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=102634 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='游戏记录数据 三个月数据';

-- ----------------------------
-- Table structure for dc_game_record_store
-- ----------------------------
DROP TABLE IF EXISTS `dc_game_record_store`;
CREATE TABLE `dc_game_record_store` (
  `game_log_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '唯一id',
  `game_log_board_id` varchar(30) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '牌局id',
  `game_log_player_id` int(11) DEFAULT '0' COMMENT '玩家id',
  `game_log_player_club_id` int(11) DEFAULT '0' COMMENT '玩家所在俱乐部id',
  `game_log_club_id` int(11) DEFAULT '0' COMMENT '俱乐部id',
  `game_log_club_room_id` int(11) DEFAULT '0' COMMENT '俱乐部房间id',
  `game_log_club_room_desk_no` int(11) DEFAULT '0' COMMENT '俱乐部桌子号',
  `game_log_club_desk_id` int(11) DEFAULT '0' COMMENT '俱乐部桌子id',
  `game_log_club_room_no` int(11) DEFAULT '0' COMMENT '包间号',
  `game_log_game_id` int(11) DEFAULT '0' COMMENT '游戏id',
  `game_log_room_id` int(11) DEFAULT '0' COMMENT '房间id',
  `game_log_desk_no` int(11) DEFAULT '0' COMMENT '桌子号',
  `game_log_win_state` int(11) DEFAULT '0' COMMENT '输赢状态(0:输,1:赢)',
  `game_log_score_type` int(11) DEFAULT '1' COMMENT '输赢分数类型(1:金币)',
  `game_log_score_value` int(11) DEFAULT '0' COMMENT '输赢分数值',
  `game_log_game_over_time` int(11) DEFAULT '0' COMMENT '游戏结束时间',
  `game_log_desc` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '备注',
  `game_log_param` varchar(512) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '保留参数',
  `game_log_data_type` int(11) DEFAULT '0' COMMENT '游戏数据类型',
  `game_log_data_value` text COLLATE utf8_unicode_ci COMMENT '游戏数据值',
  `game_log_game_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '游戏名称',
  `game_log_time` int(11) DEFAULT '0' COMMENT '记录时间',
  `game_log_data` varchar(30) COLLATE utf8_unicode_ci DEFAULT '',
  UNIQUE KEY `game_log_id` (`game_log_id`) USING BTREE,
  KEY `game_log_board_id` (`game_log_board_id`) USING BTREE,
  KEY `game_log_player_id` (`game_log_player_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=102632 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='游戏记录数据备份';

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
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='商品表';

-- ----------------------------
-- Table structure for dc_menu
-- ----------------------------
DROP TABLE IF EXISTS `dc_menu`;
CREATE TABLE `dc_menu` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `parentid` int(11) unsigned NOT NULL DEFAULT '0',
  `role_id` int(11) DEFAULT '1' COMMENT '角色id',
  `page_url` varchar(255) DEFAULT '' COMMENT '对应的页面地址',
  `app` varchar(255) DEFAULT '' COMMENT '应用名称app',
  `model` varchar(255) DEFAULT '' COMMENT '控制器',
  `action` varchar(255) DEFAULT '' COMMENT '操作名称',
  `data` varchar(255) DEFAULT '' COMMENT '额外参数',
  `type` tinyint(3) DEFAULT '0' COMMENT '菜单类型  1：权限认证+菜单；0：只作为菜单',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '状态，1显示，0不显示',
  `name` varchar(255) DEFAULT '' COMMENT '菜单名称',
  `icon` varchar(255) DEFAULT '' COMMENT '菜单图标',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `listorder` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '排序ID',
  PRIMARY KEY (`id`),
  KEY `status` (`status`) USING BTREE,
  KEY `parentid` (`parentid`) USING BTREE,
  KEY `model` (`model`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=374 DEFAULT CHARSET=utf8 COMMENT='后台菜单表';

-- ----------------------------
-- Table structure for dc_message
-- ----------------------------
DROP TABLE IF EXISTS `dc_message`;
CREATE TABLE `dc_message` (
  `message_id` int(11) NOT NULL AUTO_INCREMENT,
  `message_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '消息类型 1.系统公告 2.BUG反馈',
  `message_apply_group` tinyint(1) NOT NULL DEFAULT '0' COMMENT '消息适用群体 1.所有玩家 2.俱乐部玩家 3.游戏玩家 4.房间玩家 5.桌子玩家 6.个人',
  `message_apply_group_params` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '消息适用群体参数配置 此字段只记录message_apply_group对应的俱乐部、游戏等等ID集合',
  `message_title` varchar(30) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '消息标题',
  `message_content` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '消息内容',
  `message_attach_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '消息附件类型 0.无附件 1.文字或语音 2.具体礼品 3.礼包',
  `message_attach_params` varchar(1000) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '消息附件参数配置 对应附件类型 仅当附件类型为0以上时启用',
  `message_create_time` int(11) NOT NULL DEFAULT '0' COMMENT '消息创建时间',
  `message_remark` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '消息备注',
  PRIMARY KEY (`message_id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='消息信息表';

-- ----------------------------
-- Table structure for dc_money_rate_info
-- ----------------------------
DROP TABLE IF EXISTS `dc_money_rate_info`;
CREATE TABLE `dc_money_rate_info` (
  `money_rate_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一id',
  `money_rate_type` int(11) DEFAULT '0' COMMENT '货币类型(1:金币)',
  `money_rate_value` int(11) DEFAULT '0' COMMENT '兑率值',
  `money_rate_unit` int(11) DEFAULT '1' COMMENT '单位值',
  `money_rate_unit_type` int(11) DEFAULT '1' COMMENT '单位类型(1:元,2:角,3:分)',
  `money_rate_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '名',
  `money_rate_param` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '保留字段',
  PRIMARY KEY (`money_rate_id`),
  KEY `money_rate_id` (`money_rate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='货币兑换比率信息表';

-- ----------------------------
-- Table structure for dc_notice
-- ----------------------------
DROP TABLE IF EXISTS `dc_notice`;
CREATE TABLE `dc_notice` (
  `notice_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '公告id',
  `notice_club_id` int(11) DEFAULT '0' COMMENT '俱乐部id',
  `notice_type` tinyint(2) unsigned NOT NULL DEFAULT '0' COMMENT '公告类型 1= 系统公告，2=跑马灯公告',
  `notice_title` varchar(100) NOT NULL DEFAULT '' COMMENT '公告标题',
  `notice_name` varchar(100) DEFAULT '' COMMENT '公告名',
  `notice_content` varchar(200) NOT NULL DEFAULT '' COMMENT '公告内容',
  `notice_create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '公告的创建时间',
  `notice_param` varchar(255) DEFAULT '' COMMENT '保留字段',
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='公告表';

-- ----------------------------
-- Table structure for dc_order_log
-- ----------------------------
DROP TABLE IF EXISTS `dc_order_log`;
CREATE TABLE `dc_order_log` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_player_id` int(11) DEFAULT '0' COMMENT '下单玩家',
  `order_club_id` int(11) DEFAULT '0' COMMENT '俱乐部id',
  `order_goods_id` int(11) DEFAULT '0' COMMENT '商品id',
  `order_price` int(11) DEFAULT NULL COMMENT '价格:分',
  `order_get_type` int(11) DEFAULT '2' COMMENT '所得商品类型1.余额2.金币3.彩票4.代币5.钻石',
  `order_get_price` int(11) DEFAULT '0' COMMENT '得到的货币值(如金币数量)',
  `order_pay_type` int(11) DEFAULT '0' COMMENT '支付类型：1=android  2=ios  （未知）',
  `order_is_send` int(11) DEFAULT '0' COMMENT '是否付款0没款1付款',
  `order_orderno` varchar(255) DEFAULT '' COMMENT '订单号',
  `order_out_transaction_id` varchar(255) DEFAULT '' COMMENT '第三方订单号',
  `order_create_time` int(11) DEFAULT '0' COMMENT '下单时间',
  `order_update_time` int(11) DEFAULT '0' COMMENT '更新时间',
  `order_extension` varchar(1000) DEFAULT '' COMMENT '订单的额外信息',
  `order_pay_channel` int(11) DEFAULT '1' COMMENT '支付渠道 1=微信支付，2=支付宝，3=苹果支付，4=web支付，5=优讯支付，6-微信公众号支付',
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16382 DEFAULT CHARSET=utf8 COMMENT='订单表';

-- ----------------------------
-- Table structure for dc_partner
-- ----------------------------
DROP TABLE IF EXISTS `dc_partner`;
CREATE TABLE `dc_partner` (
  `partner_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `partner_name` varchar(60) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '合作方名字',
  `partner_desc` varchar(500) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '合作方的描述',
  `partner_status` int(5) DEFAULT '1' COMMENT '0是注销 1是正常',
  `partner_time` int(11) DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`partner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='合作方表';

-- ----------------------------
-- Table structure for dc_partner_divide
-- ----------------------------
DROP TABLE IF EXISTS `dc_partner_divide`;
CREATE TABLE `dc_partner_divide` (
  `partner_divide_id` int(11) NOT NULL AUTO_INCREMENT,
  `partner_divide_partner_id` int(11) DEFAULT '0' COMMENT '合作商ID',
  `partner_divide_proportion` int(11) DEFAULT '0' COMMENT '合作商分成比列',
  `partner_divide_time` int(11) DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`partner_divide_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='合作商分成比列';

-- ----------------------------
-- Table structure for dc_partner_user
-- ----------------------------
DROP TABLE IF EXISTS `dc_partner_user`;
CREATE TABLE `dc_partner_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `partner_id` int(11) DEFAULT '0' COMMENT '合作方的主键id',
  `user_id` int(11) DEFAULT '0' COMMENT '星云系统中的用户ID',
  `role_id` int(11) DEFAULT '0' COMMENT '权限ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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

-- ----------------------------
-- Table structure for dc_player
-- ----------------------------
DROP TABLE IF EXISTS `dc_player`;
CREATE TABLE `dc_player` (
  `player_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '玩家id',
  `player_name` varchar(50) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '玩家用户名',
  `player_nickname` varchar(350) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '玩家昵称',
  `player_password` varchar(50) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '密码',
  `player_salt` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '随机加盐',
  `player_phone` varchar(20) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '手机号码',
  `player_pcid` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '设备id',
  `player_openid_app` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT 'app授权',
  `player_openid_gzh` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '公众号授权',
  `player_unionid` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT 'unionid',
  `player_status` int(11) DEFAULT '1' COMMENT '玩家状态（1为正常 0为禁用）',
  `player_vip_level` int(11) DEFAULT '0' COMMENT 'vip等级',
  `player_resigter_time` int(11) DEFAULT '0' COMMENT '注册时间',
  `player_robot` int(11) DEFAULT '0' COMMENT '是否为机器人(1为机器人，0为真实用户)',
  `player_guest` int(11) DEFAULT '0' COMMENT '是否为游客玩家(1为游客，0注册用户)',
  `player_icon_id` int(11) DEFAULT '0' COMMENT '系统头像id',
  `player_identification_number` varchar(50) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '实名认证身份证号',
  `player_identification_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '实名认证姓名',
  `player_channel` tinyint(3) NOT NULL DEFAULT '0' COMMENT '1-andriod-pcid注册(游客)，2-ios-pcid注册(游客)，3-安卓微信注册 ，4-IOS微信注册 ，5-h5微信注册(微信推广) 6-h5后台账户注册',
  PRIMARY KEY (`player_id`),
  UNIQUE KEY `player_id` (`player_id`) USING HASH,
  KEY `player_pcid` (`player_pcid`) USING BTREE,
  KEY `player_name` (`player_name`) USING HASH,
  KEY `player_resigter_time` (`player_resigter_time`) USING BTREE,
  KEY `player_unionid` (`player_unionid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1097817 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='玩家基本信息';

-- ----------------------------
-- Table structure for dc_player_info
-- ----------------------------
DROP TABLE IF EXISTS `dc_player_info`;
CREATE TABLE `dc_player_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一id',
  `player_id` int(11) DEFAULT '0' COMMENT '玩家id',
  `player_money` bigint(20) DEFAULT '0' COMMENT '佘额',
  `player_coins` bigint(20) DEFAULT '0' COMMENT '金币',
  `player_masonry` bigint(20) DEFAULT '0' COMMENT '钻石',
  `player_safe_box` bigint(20) unsigned DEFAULT '0' COMMENT '保险箱',
  `player_safe_box_password` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '保险箱密码',
  `player_lottery` int(11) DEFAULT '0' COMMENT '彩票',
  `player_club_id` int(11) DEFAULT '0' COMMENT '绑定俱乐部id',
  `player_header_image` varchar(200) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '玩家图像',
  `player_sex` int(11) DEFAULT '1' COMMENT '性别（1男2女）',
  `player_signature` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '玩家个性签名',
  `player_login_time` int(11) DEFAULT '0',
  `player_login_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `player_author` int(2) DEFAULT '0' COMMENT '玩家实名认证',
  PRIMARY KEY (`id`),
  UNIQUE KEY `player_id` (`player_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=496678 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='玩家属性';

-- ----------------------------
-- Table structure for dc_player_message
-- ----------------------------
DROP TABLE IF EXISTS `dc_player_message`;
CREATE TABLE `dc_player_message` (
  `player_message_id` int(11) NOT NULL AUTO_INCREMENT,
  `player_message_message_id` int(11) NOT NULL DEFAULT '0' COMMENT '消息ID',
  `player_message_player_id` int(11) NOT NULL DEFAULT '0' COMMENT '玩家ID',
  `player_message_is_read` tinyint(1) NOT NULL DEFAULT '0' COMMENT '消息是否已读  0.未读 1.已读',
  `player_message_is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '消息是否删除  0.未删除 1.已删除',
  `player_message_is_attach_receive` tinyint(1) NOT NULL DEFAULT '0' COMMENT '消息附件是否接收 0.未接收 1.已接收',
  `player_message_create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `player_message_modify_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`player_message_id`),
  KEY `union_message_player_time` (`player_message_message_id`,`player_message_player_id`,`player_message_create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=378 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='玩家消息信息表';

-- ----------------------------
-- Table structure for dc_player_propinfo
-- ----------------------------
DROP TABLE IF EXISTS `dc_player_propinfo`;
CREATE TABLE `dc_player_propinfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一id',
  `prop_player_id` int(11) DEFAULT '0' COMMENT '玩家id',
  `prop_id` int(11) DEFAULT '0' COMMENT '道具id',
  `prop_num` int(11) DEFAULT '0' COMMENT '道具数量',
  PRIMARY KEY (`id`),
  KEY `playerid` (`prop_player_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for dc_player_prop_log
-- ----------------------------
DROP TABLE IF EXISTS `dc_player_prop_log`;
CREATE TABLE `dc_player_prop_log` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `log_prop_club_id` int(11) NOT NULL DEFAULT '-1' COMMENT '道具所属俱乐部ID -1、适用于所有俱乐部',
  `log_prop_game_id` int(11) NOT NULL DEFAULT '-1' COMMENT '道具所属游戏ID -1、适用于俱乐部下所有游戏',
  `log_player_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '玩家ID',
  `log_prop_id` int(11) NOT NULL DEFAULT '0' COMMENT '道具ID',
  `log_prop_price` bigint(20) NOT NULL DEFAULT '0' COMMENT '道具单价 默认钱类型为金币',
  `log_action_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '道具行为类型 1、玩家非付费使用 2、玩家付费使用 3、玩家购买 4、玩家赠送 5、系统赠送',
  `log_action_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '道具行为状态 0、正常 1、无数量限制(某些道具没有数量限制或玩家为VIP)',
  `log_action_prop_num_before` int(11) NOT NULL DEFAULT '0' COMMENT '玩家道具行为前拥有数量',
  `log_action_num` int(11) NOT NULL DEFAULT '0' COMMENT '道具行为数量 发生道具行为时 所消耗或获得道具数量',
  `log_action_prop_num_after` int(11) NOT NULL DEFAULT '0' COMMENT '玩家道具行为后拥有数量',
  `log_action_total_fee` bigint(20) NOT NULL DEFAULT '0' COMMENT '道具行为总额 仅当道具行为类型为2和3时启用',
  `log_to_other_player_id` int(11) NOT NULL DEFAULT '0' COMMENT '其他玩家ID 仅当道具行为类型为4时 对其他玩家使用或赠送道具时启用',
  `log_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '记录时间',
  `log_remark` varchar(500) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`log_id`),
  KEY `union_player_id_and_prop_id` (`log_player_id`,`log_prop_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1418 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='玩家道具使用记录表';

-- ----------------------------
-- Table structure for dc_player_prop_log_day
-- ----------------------------
DROP TABLE IF EXISTS `dc_player_prop_log_day`;
CREATE TABLE `dc_player_prop_log_day` (
  `log_day_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `log_day_player_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '玩家ID',
  `log_day_prop_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '道具ID',
  `log_day_prop_consumed_num` int(11) NOT NULL DEFAULT '0' COMMENT '玩家消耗的道具总数',
  `log_day_prop_get_num` int(11) NOT NULL DEFAULT '0' COMMENT '玩家获得的道具总数',
  `log_day_prop_total_fee` bigint(20) NOT NULL DEFAULT '0' COMMENT '玩家在道具上花费的金额总数 默认钱类型为金币',
  `log_day_date` date NOT NULL DEFAULT '0000-00-00' COMMENT '日期',
  PRIMARY KEY (`log_day_id`),
  UNIQUE KEY `union_ps_pr_em_date` (`log_day_player_id`,`log_day_prop_id`,`log_day_date`)
) ENGINE=InnoDB AUTO_INCREMENT=202 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='玩家道具使用日志表(按天统计)';

-- ----------------------------
-- Table structure for dc_prop
-- ----------------------------
DROP TABLE IF EXISTS `dc_prop`;
CREATE TABLE `dc_prop` (
  `prop_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `prop_club_id` int(11) NOT NULL DEFAULT '-1' COMMENT '道具所属俱乐部ID -1、适用于所有俱乐部',
  `prop_game_id` int(11) NOT NULL DEFAULT '-1' COMMENT '道具所属游戏ID -1、适用于俱乐部下所有游戏',
  `prop_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '道具名称',
  `prop_category` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '道具分类 1、互动表情',
  `prop_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '道具类型(保留字段)',
  `prop_apply_group` tinyint(1) NOT NULL DEFAULT '0' COMMENT '道具适用群体 0、所有玩家 1、VIP',
  `prop_weight` smallint(5) NOT NULL DEFAULT '0' COMMENT '道具权重(用于排序 保留字段)',
  `prop_num` int(11) NOT NULL DEFAULT '0' COMMENT '道具数量(保留字段) -1、无数量限制',
  `prop_price` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '道具单价 默认单位金币',
  `prop_vip_level` tinyint(1) NOT NULL DEFAULT '0' COMMENT '哪一层级的VIP可用 当prop_apply_group为1时启用(保留字段)',
  `prop_specific_config` varchar(500) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '道具特有属性配置信息',
  `prop_expire_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '道具有效期(保留字段) 0、无有效期 其他、具体的有效期',
  `prop_created` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `prop_modified` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  `prop_remark` varchar(1000) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`prop_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='道具信息表';

-- ----------------------------
-- Table structure for dc_ranking
-- ----------------------------
DROP TABLE IF EXISTS `dc_ranking`;
CREATE TABLE `dc_ranking` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ranking_player_id` int(10) unsigned NOT NULL COMMENT '玩家id',
  `ranking_number` int(11) DEFAULT '0' COMMENT '名次，1,2,3.，，，',
  `ranking_nick_name` varchar(300) NOT NULL DEFAULT '' COMMENT '玩家昵称',
  `ranking_player_image` varchar(300) NOT NULL DEFAULT '' COMMENT '玩家图像',
  `ranking_player_coins` bigint(20) DEFAULT '0' COMMENT '玩家的金币数量',
  `ranking_coins_type` tinyint(2) DEFAULT '1' COMMENT '类型：1-金币 2-代币 3-彩票',
  `ranking_time` varchar(20) DEFAULT '' COMMENT '时间',
  `ranking_clubid` int(11) DEFAULT '0' COMMENT '电玩厅id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6424 DEFAULT CHARSET=utf8 COMMENT='排行榜';

-- ----------------------------
-- Table structure for dc_role
-- ----------------------------
DROP TABLE IF EXISTS `dc_role`;
CREATE TABLE `dc_role` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL COMMENT '角色名称',
  `status` tinyint(1) unsigned DEFAULT NULL COMMENT '状态',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='角色表';

-- ----------------------------
-- Table structure for dc_room_info
-- ----------------------------
DROP TABLE IF EXISTS `dc_room_info`;
CREATE TABLE `dc_room_info` (
  `room_id` int(11) NOT NULL AUTO_INCREMENT,
  `room_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '房间名',
  `room_game_id` int(11) DEFAULT '0' COMMENT '游戏id',
  `room_rule` int(11) DEFAULT '0' COMMENT '游戏规则（1为金币场，0为练习币场）',
  `room_desk_count` int(11) DEFAULT '100' COMMENT '桌子数量',
  `room_status` int(11) DEFAULT '0' COMMENT '状态 0为禁用 1为启用',
  `room_is_open` int(11) DEFAULT '1' COMMENT '是否开启分配房间',
  `room_min_money` bigint(20) DEFAULT '0' COMMENT '进入最少金币 0为不限制',
  `room_max_money` bigint(20) DEFAULT '0' COMMENT '进入最大金币 0为不限制',
  `room_srv_host` varchar(50) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '房间服务器IP',
  `room_srv_port` int(11) DEFAULT '0' COMMENT '房间服务器端口',
  `room_srv_dll_name` varchar(50) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '加载游戏服务器组件dll模块名称',
  `room_encrypt` int(11) DEFAULT '0' COMMENT '是否加密房 1是，0不是',
  `room_password` varchar(50) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '房间密码',
  `room_tax` int(11) DEFAULT '0' COMMENT '税百分百比',
  `room_base_point` int(11) DEFAULT '0' COMMENT '房间底分',
  `room_vip` int(11) DEFAULT '0' COMMENT 'VIP等级限制（预留 默认0）',
  `room_type` int(11) DEFAULT '0' COMMENT '游戏桌类型，1百人游戏，0非百人游戏',
  PRIMARY KEY (`room_id`),
  KEY `room_id` (`room_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='房间信息';

-- ----------------------------
-- Table structure for dc_safe_box_log
-- ----------------------------
DROP TABLE IF EXISTS `dc_safe_box_log`;
CREATE TABLE `dc_safe_box_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `player_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '玩家的id',
  `trade_type` tinyint(2) unsigned DEFAULT '1' COMMENT '交易类型，1= 存入 2= 转出',
  `trade_cion` bigint(20) unsigned DEFAULT '0' COMMENT '交易的金币数量',
  `trade_time` int(10) DEFAULT '0' COMMENT '交易的时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='保险箱流水日志';

-- ----------------------------
-- Table structure for dc_system_config
-- ----------------------------
DROP TABLE IF EXISTS `dc_system_config`;
CREATE TABLE `dc_system_config` (
  `system_config_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '唯一id',
  `system_config_platform` int(11) DEFAULT '0' COMMENT '平台(0:所有平台,1:ios,2:android,3:windows)',
  `system_config_club_id` int(11) DEFAULT '0' COMMENT '俱乐部id',
  `system_config_type` int(11) DEFAULT '1' COMMENT '1:推送服务器',
  `system_config_data` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '保留字段',
  PRIMARY KEY (`system_config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='系统配置信息表';

-- ----------------------------
-- Table structure for jd_area
-- ----------------------------
DROP TABLE IF EXISTS `jd_area`;
CREATE TABLE `jd_area` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentid` int(12) NOT NULL COMMENT '父id',
  `cityname` varchar(180) NOT NULL DEFAULT '' COMMENT '城市名字',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53693 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for jd_banner
-- ----------------------------
DROP TABLE IF EXISTS `jd_banner`;
CREATE TABLE `jd_banner` (
  `banner_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `banner_tag_id` int(11) DEFAULT '0' COMMENT 'banner图对应一个tagID',
  `banner_goods_id` int(11) DEFAULT '0' COMMENT '商品ID',
  `banner_img_url` varchar(300) COLLATE utf8_unicode_ci DEFAULT '' COMMENT 'banner图片地址',
  `banner_status` int(1) DEFAULT '0' COMMENT '0不可用，1可用',
  `banner_type` int(11) DEFAULT '0' COMMENT '0商品类型跳珠，1商品跳转',
  `banner_order_id` int(11) DEFAULT '0' COMMENT '排序ID，越大越后',
  `banner_desc` varchar(300) COLLATE utf8_unicode_ci DEFAULT '' COMMENT 'banner描述',
  `banner_create_time` int(11) DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`banner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Table structure for jd_category
-- ----------------------------
DROP TABLE IF EXISTS `jd_category`;
CREATE TABLE `jd_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentid` int(12) NOT NULL,
  `categoryname` varchar(180) NOT NULL,
  `order_id` int(3) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for jd_gift
-- ----------------------------
DROP TABLE IF EXISTS `jd_gift`;
CREATE TABLE `jd_gift` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT '名字',
  `img_url` varchar(255) DEFAULT '' COMMENT '图片',
  `params` varchar(255) DEFAULT '' COMMENT '参数',
  `desc` varchar(100) DEFAULT '' COMMENT '产品描述',
  `voucher` int(11) DEFAULT NULL COMMENT '兑换该商品所需的礼券',
  `order_id` int(11) unsigned DEFAULT '0' COMMENT '礼品来进行排序，ID越小排越前',
  `status` int(1) DEFAULT '0' COMMENT '状态',
  `create_time` int(11) DEFAULT NULL COMMENT '创建时间',
  `cid` int(11) NOT NULL COMMENT '所属分类的id',
  `tagid` smallint(5) unsigned DEFAULT '0' COMMENT '标签',
  `channel` varchar(4) DEFAULT '' COMMENT '默认0:全部，1：APP，2：微信公众号',
  `sku` bigint(20) DEFAULT NULL COMMENT '京东商品号',
  `is_jd` tinyint(3) unsigned NOT NULL COMMENT '是否京东：1是，0否；',
  PRIMARY KEY (`id`),
  KEY `sku` (`sku`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8 COMMENT='礼品表';

-- ----------------------------
-- Table structure for jd_gift_bak
-- ----------------------------
DROP TABLE IF EXISTS `jd_gift_bak`;
CREATE TABLE `jd_gift_bak` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT '名字',
  `img_url` varchar(255) DEFAULT '' COMMENT '图片',
  `params` varchar(255) DEFAULT '' COMMENT '参数',
  `desc` varchar(100) DEFAULT '' COMMENT '产品描述',
  `voucher` int(11) DEFAULT NULL COMMENT '兑换该商品所需的礼券',
  `order_id` int(11) unsigned DEFAULT '0' COMMENT '礼品来进行排序，ID越小排越前',
  `status` int(1) DEFAULT '0' COMMENT '状态',
  `create_time` int(11) DEFAULT NULL COMMENT '创建时间',
  `cid` int(11) NOT NULL COMMENT '所属分类的id',
  `tagid` smallint(5) unsigned DEFAULT '0' COMMENT '标签',
  `channel` varchar(4) DEFAULT '' COMMENT '默认0:全部，1：APP，2：微信公众号',
  `sku` bigint(20) DEFAULT NULL COMMENT '京东商品号',
  `is_jd` tinyint(3) unsigned NOT NULL COMMENT '是否京东：1是，0否；',
  PRIMARY KEY (`id`),
  KEY `sku` (`sku`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='礼品表';

-- ----------------------------
-- Table structure for jd_jdorder
-- ----------------------------
DROP TABLE IF EXISTS `jd_jdorder`;
CREATE TABLE `jd_jdorder` (
  `jdOrderId` char(50) NOT NULL COMMENT '京东订单号',
  `freight` decimal(8,2) DEFAULT NULL COMMENT '订单总运费 = 基础运费 + 总的超重偏远附加运费',
  `orderPrice` decimal(10,2) DEFAULT NULL COMMENT '商品总价格',
  `orderNakedPrice` decimal(10,2) DEFAULT NULL COMMENT '订单裸价',
  `orderTaxPrice` decimal(10,2) DEFAULT NULL COMMENT '订单税额',
  `skuId` bigint(20) DEFAULT NULL COMMENT '商品ID',
  `num` int(11) NOT NULL DEFAULT '1' COMMENT '数量',
  `category` int(11) DEFAULT NULL COMMENT '分类',
  `price` decimal(10,2) DEFAULT NULL COMMENT '商品价格',
  `name` varchar(255) DEFAULT NULL COMMENT '商品名字',
  `tax` int(11) DEFAULT NULL COMMENT '税率',
  `taxPrice` decimal(8,2) DEFAULT NULL COMMENT '税额',
  `nakedPrice` decimal(8,2) DEFAULT NULL COMMENT '商品裸价',
  `type` tinyint(3) NOT NULL DEFAULT '0' COMMENT '0，普通，1，附件，2，赠品',
  `oid` int(11) NOT NULL DEFAULT '0' COMMENT '主商品ID',
  `remoteRegionFrieight` decimal(8,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`jdOrderId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for jd_msg_log
-- ----------------------------
DROP TABLE IF EXISTS `jd_msg_log`;
CREATE TABLE `jd_msg_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mobile` varchar(12) NOT NULL DEFAULT '' COMMENT '手机号码',
  `code` smallint(5) DEFAULT '0' COMMENT '验证码',
  `send_time` int(10) NOT NULL DEFAULT '0' COMMENT '发送时间',
  `expire_time` int(10) NOT NULL DEFAULT '0' COMMENT '过期时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for jd_oauth
-- ----------------------------
DROP TABLE IF EXISTS `jd_oauth`;
CREATE TABLE `jd_oauth` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_key` varchar(32) DEFAULT NULL,
  `app_secret` varchar(64) DEFAULT NULL COMMENT '加密盐',
  `signature` varchar(64) DEFAULT NULL COMMENT '加密串',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for jd_order
-- ----------------------------
DROP TABLE IF EXISTS `jd_order`;
CREATE TABLE `jd_order` (
  `order_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `order_num` varchar(50) NOT NULL COMMENT '唯一流水号',
  `channel` tinyint(3) unsigned DEFAULT '1' COMMENT '渠道：1，公众号；2，APP',
  `uid` bigint(20) NOT NULL COMMENT '用户ID',
  `before_voucher` int(11) NOT NULL DEFAULT '0' COMMENT '之前礼券',
  `voucher` int(11) NOT NULL COMMENT '兑换礼券',
  `after_voucher` int(11) DEFAULT '0' COMMENT '当前礼券',
  `province` int(10) unsigned NOT NULL COMMENT '省ID',
  `city` int(10) unsigned NOT NULL COMMENT '市ID',
  `county` int(11) DEFAULT NULL,
  `town` int(11) DEFAULT NULL,
  `address` varchar(255) NOT NULL COMMENT '详细地址',
  `username` varchar(100) NOT NULL COMMENT '收货人',
  `tel` varchar(12) NOT NULL COMMENT '收货人手机',
  `status` tinyint(4) DEFAULT '0' COMMENT '1,已收货；0，未收货',
  `jd_order_id` varchar(80) DEFAULT '' COMMENT '京东订单号',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `order_num` (`order_num`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for jd_order_gift
-- ----------------------------
DROP TABLE IF EXISTS `jd_order_gift`;
CREATE TABLE `jd_order_gift` (
  `order_gift_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) NOT NULL COMMENT '订单ID',
  `gift_id` bigint(20) NOT NULL COMMENT '礼品ID',
  `gift_sku` bigint(20) DEFAULT NULL COMMENT '京东商品ID',
  `gift_name` varchar(255) NOT NULL COMMENT '礼品名',
  `gift_num` int(11) NOT NULL COMMENT '数量',
  `gift_voucher` int(11) NOT NULL COMMENT '礼券',
  `gift_params` varchar(255) DEFAULT '' COMMENT '参数',
  `gift_img_url` varchar(255) DEFAULT '' COMMENT '图片',
  `gift_desc` varchar(100) DEFAULT '' COMMENT '产品描述',
  PRIMARY KEY (`order_gift_id`)
) ENGINE=InnoDB AUTO_INCREMENT=170 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for jd_product
-- ----------------------------
DROP TABLE IF EXISTS `jd_product`;
CREATE TABLE `jd_product` (
  `sku` bigint(11) NOT NULL COMMENT '商品号',
  `name` varchar(255) NOT NULL COMMENT '商品名称',
  `brandName` varchar(255) DEFAULT '' COMMENT '品牌名',
  `category` varchar(255) NOT NULL COMMENT '种类，1,2,3级以分号隔开',
  `saleUnit` char(20) DEFAULT '' COMMENT '单位',
  `weight` double unsigned DEFAULT NULL COMMENT '重量',
  `productArea` char(255) DEFAULT '' COMMENT '产地',
  `wareQD` varchar(255) DEFAULT '' COMMENT '规格与包装',
  `imagePath` varchar(255) DEFAULT '' COMMENT '图片地址',
  `param` text COMMENT '产品参数',
  `state` tinyint(4) DEFAULT NULL COMMENT '状态，0.下架，1.上架',
  `upc` varchar(255) DEFAULT '',
  `introduction` text COMMENT '产品介绍',
  `dc_state` tinyint(3) unsigned DEFAULT '1' COMMENT '默认1为可选，0为不可选',
  PRIMARY KEY (`sku`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for jd_product_bak
-- ----------------------------
DROP TABLE IF EXISTS `jd_product_bak`;
CREATE TABLE `jd_product_bak` (
  `sku` bigint(11) NOT NULL COMMENT '商品号',
  `name` varchar(255) NOT NULL COMMENT '商品名称',
  `brandName` varchar(255) DEFAULT '' COMMENT '品牌名',
  `category` varchar(255) NOT NULL COMMENT '种类，1,2,3级以分号隔开',
  `saleUnit` char(20) DEFAULT '' COMMENT '单位',
  `weight` double unsigned DEFAULT NULL COMMENT '重量',
  `productArea` char(255) DEFAULT '' COMMENT '产地',
  `wareQD` varchar(255) DEFAULT '' COMMENT '规格与包装',
  `imagePath` varchar(255) DEFAULT '' COMMENT '图片地址',
  `param` text COMMENT '产品参数',
  `state` tinyint(4) DEFAULT NULL COMMENT '状态，0.下架，1.上架',
  `upc` varchar(255) DEFAULT '',
  `introduction` text COMMENT '产品介绍',
  `dc_state` tinyint(3) unsigned DEFAULT '1' COMMENT '默认1为可选，0为不可选',
  PRIMARY KEY (`sku`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for jd_product_log
-- ----------------------------
DROP TABLE IF EXISTS `jd_product_log`;
CREATE TABLE `jd_product_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL COMMENT '对应playerinfo表中的uid',
  `product_id` int(11) DEFAULT NULL COMMENT '对应dc_product中的id',
  `name` varchar(30) DEFAULT NULL COMMENT '姓名',
  `mobile` varchar(30) DEFAULT NULL COMMENT '电话',
  `num` int(11) DEFAULT NULL COMMENT '兑换商品的数量',
  `redeem_voucher` int(11) DEFAULT NULL COMMENT '兑换花费的礼券数目',
  `redeem_time` int(11) DEFAULT NULL COMMENT '兑换时间',
  `status` int(11) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for jd_tag
-- ----------------------------
DROP TABLE IF EXISTS `jd_tag`;
CREATE TABLE `jd_tag` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(10) NOT NULL DEFAULT '' COMMENT '标签名称',
  `tag_image` varchar(300) DEFAULT '' COMMENT '商品分类背景图',
  `cid` int(10) unsigned NOT NULL COMMENT '分类',
  `order_id` int(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for jd_user_address
-- ----------------------------
DROP TABLE IF EXISTS `jd_user_address`;
CREATE TABLE `jd_user_address` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) unsigned NOT NULL COMMENT '用户ID',
  `username` varchar(255) NOT NULL DEFAULT '收货人',
  `province` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '省',
  `city` int(10) unsigned DEFAULT '0' COMMENT '市',
  `county` int(10) unsigned DEFAULT '0' COMMENT '区',
  `town` int(10) unsigned DEFAULT '0' COMMENT '镇',
  `address` varchar(255) NOT NULL,
  `tel` varchar(12) NOT NULL COMMENT '手机',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

-- ----------------------------
-- View structure for dc_view_club_game
-- ----------------------------
DROP VIEW IF EXISTS `dc_view_club_game`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `dc_view_club_game` AS select `dc_club_game`.`id` AS `id`,`dc_club_game`.`club_id` AS `club_id`,`dc_club_game`.`game_id` AS `game_id`,`dc_game_info`.`game_name` AS `game_name` from (`dc_club_game` join `dc_game_info`) where (`dc_club_game`.`game_id` = `dc_game_info`.`game_id`) ;

-- ----------------------------
-- View structure for dc_view_club_player
-- ----------------------------
DROP VIEW IF EXISTS `dc_view_club_player`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `dc_view_club_player` AS select `dc_club_info`.`club_id` AS `club_id`,`dc_club_info`.`club_name` AS `club_name`,`dc_club_info`.`club_status` AS `club_status`,`dc_club_info`.`club_time` AS `club_time`,`dc_club_player`.`player_id` AS `player_id`,`dc_club_player`.`player_tokens` AS `player_tokens` from (`dc_club_info` join `dc_club_player`) where (`dc_club_info`.`club_id` = `dc_club_player`.`club_id`) ;

-- ----------------------------
-- View structure for dc_view_club_room
-- ----------------------------
DROP VIEW IF EXISTS `dc_view_club_room`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `dc_view_club_room` AS select `dc_club_room`.`club_room_id` AS `club_room_id`,`dc_club_room`.`club_room_club_id` AS `club_room_club_id`,`dc_club_room`.`club_room_game_id` AS `club_room_game_id`,`dc_club_room`.`club_room_desk_count` AS `club_room_desk_count`,`dc_game_info`.`game_desk_members_count` AS `club_room_desk_members_count`,`dc_club_room`.`club_room_name` AS `club_room_name`,`dc_club_room`.`club_room_is_open` AS `club_room_is_open`,`dc_club_room`.`club_room_is_work` AS `club_room_is_work`,`dc_club_room`.`club_room_type` AS `club_room_type`,`dc_club_room`.`club_room_level` AS `club_room_level`,`dc_club_room`.`club_room_basic_points` AS `club_room_basic_points`,`dc_club_room`.`club_room_min_coin` AS `club_room_min_coin`,`dc_club_room`.`club_room_max_coin` AS `club_room_max_coin`,`dc_club_room`.`club_room_desk_param` AS `club_room_desk_param`,`dc_club_room`.`club_room_rule_id` AS `club_room_rule_id` from (`dc_club_room` join `dc_game_info`) where (`dc_game_info`.`game_id` = `dc_club_room`.`club_room_game_id`) ;

-- ----------------------------
-- View structure for dc_view_player_info
-- ----------------------------
DROP VIEW IF EXISTS `dc_view_player_info`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `dc_view_player_info` AS select `dc_player`.`player_id` AS `player_id`,`dc_player`.`player_name` AS `player_name`,`dc_player`.`player_nickname` AS `player_nickname`,`dc_player`.`player_password` AS `player_password`,`dc_player`.`player_phone` AS `player_phone`,`dc_player`.`player_pcid` AS `player_pcid`,`dc_player`.`player_status` AS `player_status`,`dc_player`.`player_vip_level` AS `player_vip_level`,`dc_player`.`player_resigter_time` AS `player_resigter_time`,`dc_player`.`player_robot` AS `player_robot`,`dc_player`.`player_guest` AS `player_guest`,`dc_player`.`player_icon_id` AS `player_icon_id`,`dc_player_info`.`player_money` AS `player_money`,`dc_player_info`.`player_coins` AS `player_coins`,`dc_player_info`.`player_safe_box` AS `player_safe_box`,`dc_player_info`.`player_safe_box_password` AS `player_safe_box_password`,`dc_player_info`.`player_club_id` AS `player_club_id`,`dc_player_info`.`player_header_image` AS `player_header_image`,`dc_player_info`.`player_sex` AS `player_sex`,`dc_player_info`.`player_signature` AS `player_signature`,`dc_player_info`.`player_author` AS `player_author` from (`dc_player` join `dc_player_info`) where (`dc_player`.`player_id` = `dc_player_info`.`player_id`) ;

-- ----------------------------
-- Function structure for urldecode
-- ----------------------------
DROP FUNCTION IF EXISTS `urldecode`;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `urldecode`(s VARCHAR(4096)) RETURNS varchar(4096) CHARSET utf8 COLLATE utf8_unicode_ci
    DETERMINISTIC
BEGIN
       DECLARE c VARCHAR(4096) DEFAULT '';
       DECLARE pointer INT DEFAULT 1;
       DECLARE h CHAR(2);
       DECLARE h1 CHAR(1);
       DECLARE h2 CHAR(1);
       DECLARE s2 VARCHAR(4096) DEFAULT '';


       IF ISNULL(s) THEN
          RETURN NULL;
       ELSE
       SET s2 = '';
       WHILE pointer <= LENGTH(s) DO
          SET c = MID(s,pointer,1);
          IF c = '+' THEN
             SET c = ' ';
          ELSEIF c = '%' AND pointer + 2 <= LENGTH(s) THEN
             SET h1 = LOWER(MID(s,pointer+1,1));
             SET h2 = LOWER(MID(s,pointer+2,1));
             IF (h1 BETWEEN '0' AND '9' OR h1 BETWEEN 'a' AND 'f')
                 AND
                 (h2 BETWEEN '0' AND '9' OR h2 BETWEEN 'a' AND 'f') 
                 THEN
                   SET h = CONCAT(h1,h2);
                   SET pointer = pointer + 2;
                   SET c = CHAR(CONV(h,16,10));
              END IF;
          END IF;
          SET s2 = CONCAT(s2,c);
          SET pointer = pointer + 1;
       END while;
       END IF;
       RETURN s2;
END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for url_decode
-- ----------------------------
DROP FUNCTION IF EXISTS `url_decode`;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `url_decode`(original_text TEXT) RETURNS text CHARSET utf8
BEGIN  
    DECLARE new_text TEXT DEFAULT NULL;  
    DECLARE pointer INT DEFAULT 1;  
    DECLARE end_pointer INT DEFAULT 1;  
    DECLARE encoded_text TEXT DEFAULT NULL;  
    DECLARE result_text TEXT DEFAULT NULL;  
   
    SET new_text = REPLACE(original_text,'+',' ');  
    SET new_text = REPLACE(new_text,'%0A','\r\n');  
   
    SET pointer = LOCATE("%", new_text);  
    while pointer <> 0 && pointer < (CHAR_LENGTH(new_text) - 2) DO  
        SET end_pointer = pointer + 3;  
        while MID(new_text, end_pointer, 1) = "%" DO  
            SET end_pointer = end_pointer+3;  
        END while;  
   
        SET encoded_text = MID(new_text, pointer, end_pointer - pointer);  
        SET result_text = CONVERT(UNHEX(REPLACE(encoded_text, "%", "")) USING utf8);  
        SET new_text = REPLACE(new_text, encoded_text, result_text);  
        SET pointer = LOCATE("%", new_text, pointer + CHAR_LENGTH(result_text));  
    END while;  
   
    return new_text;  
  
END
;;
DELIMITER ;
