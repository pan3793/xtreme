CREATE TABLE IF NOT EXISTS `meta_project` (
  `id`                  VARCHAR(40)     NOT NULL,
  `version`             BIGINT(20)      NOT NULL,
  `code`                VARCHAR(100)    NOT NULL,
  `parent_id`           VARCHAR(40)     NULL,
  `parent_version`      BIGINT(20)      NULL,
  `description`         VARCHAR(500)    NOT NULL DEFAULT '',
  `status`              INT(11)         NOT NULL,
  `creator`             VARCHAR(40)     NOT NULL DEFAULT 'sys',
  `updater`             VARCHAR(40)     NOT NULL DEFAULT 'sys',
  `create_time`         DATETIME        DEFAULT CURRENT_TIMESTAMP,
  `update_time`         DATETIME        DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`, `version`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;

INSERT INTO `meta_project` (`id`,    `version`, `code`,        `parent_id`, `parent_version`, `description`,   `status`) VALUES
                           ('p_001', 1,         'project_001', NULL,        NULL,             'for unit test', 0),
                           ('p_001', 2,         'project_001', NULL,        NULL,             'for unit test', 1),
                           ('p_002', 1,         'project_001', 'p_001',     2,                'for unit test', 1);

CREATE TABLE IF NOT EXISTS `meta_relation` (
  `id`                  BIGINT(20)      NOT NULL AUTO_INCREMENT,
  `type`                VARCHAR(20)     NOT NULL DEFAULT '' COMMENT 'druid, hive, hdfs',
  `catalog`             VARCHAR(200)    NOT NULL DEFAULT '' COMMENT '1st level to identify a relation, e.g. presto (optional)',
  `schm`                VARCHAR(200)    NOT NULL DEFAULT '' COMMENT '2nd level to identify a relation, e.g. hive (optional)',
  `tbl`                 VARCHAR(255)    NOT NULL DEFAULT '' COMMENT '3rd level to identify a relation, e.g. druid',
  `format`              VARCHAR(40)     NOT NULL DEFAULT '' COMMENT 'this maybe used by spark',
  `location`            VARCHAR(2000)   NOT NULL DEFAULT '' COMMENT 'this maybe used by spark',
  `props`               JSON            NULL     COMMENT 'this maybe used by spark, e.g. delimiter, header for csv file',
  `status`              INT(11)         NOT NULL COMMENT '0 valid',
  `creator`             VARCHAR(40)     NOT NULL DEFAULT 'sys',
  `updater`             VARCHAR(40)     NOT NULL DEFAULT 'sys',
  `create_time`         DATETIME        DEFAULT CURRENT_TIMESTAMP,
  `update_time`         DATETIME        DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_type_tbl_schm_catalog` (`type`, `tbl`, `schm`, `catalog`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;

INSERT INTO `meta_relation` (`id`, `type`,  `catalog`, `schm`,    `tbl`,            `format`, `location`,     `props`, `status`) VALUES
                            (1,    'druid', '',        '',        'druid_table',    '',       '',             NULL,     0),
                            (10,   'hive',  '',        'hive_db', 'hive_fact_tbl',  '',       '',             '{"k1":"v1","k2":"v2"}', 0),
                            (11,   'hive',  '',        'hive_db', 'hive_dim_tbl_1', '',       '',             NULL,     0),
                            (12,   'hive',  '',        'hive_db', 'hive_dim_tbl_2', '',       '',             NULL,     0),
                            (100,  'hdfs',  '',        '',        '',               'orc',    'hdfs:///path', NULL,     0);

CREATE TABLE IF NOT EXISTS `meta_field` (
  `id`                  BIGINT(20)      NOT NULL AUTO_INCREMENT,
  `relation_id`         BIGINT(20)      NOT NULL,
  `name`                VARCHAR(255)    NOT NULL,
  `type`                VARCHAR(40)     NOT NULL,
  `expr`                VARCHAR(2000)   NOT NULL,
  `creator`             VARCHAR(40)     NOT NULL DEFAULT 'sys',
  `updater`             VARCHAR(40)     NOT NULL DEFAULT 'sys',
  `create_time`         DATETIME        DEFAULT CURRENT_TIMESTAMP,
  `update_time`         DATETIME        DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `u_idx_relation_id_name` (`relation_id`, `name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT='currently only define druid data_source fields';

INSERT INTO `meta_field` (`id`, `relation_id`, `name`,                   `type`,      `expr`) VALUES
                         (1,    1,             '__time',                 'LONG',      'CURRENT_TIMESTAMP'),
                         (2,    1,             'project_id',             'STRING',    'NULL'),
                         (3,    1,             'project_version',        'LONG',      'NULL'),
                         (4,    1,             'parent_project_id',      'STRING',    'NULL'),
                         (5,    1,             'parent_project_version', 'LONG',      'NULL'),
                         (6,    1,             'all',                    'STRING',    '""'),
                         (101,  1,             'qts01',                  'STRING',    'NULL'),
                         (102,  1,             'qts02',                  'STRING',    'NULL'),
                         (103,  1,             'qts03',                  'STRING',    'NULL'),
                         (104,  1,             'qts04',                  'STRING',    'NULL'),
                         (201,  1,             'qf1',                    'FLOAT',     'NULL'),
                         (202,  1,             'qf2',                    'FLOAT',     'NULL'),
                         (203,  1,             'qf3',                    'FLOAT',     'NULL'),
                         (204,  1,             'qf4',                    'FLOAT',     'NULL'),
                         (205,  1,             'qf5',                    'FLOAT',     'NULL'),
                         (206,  1,             'qf6',                    'FLOAT',     'NULL'),
                         (301,  1,             'qs1',                    'STRING',    'NULL'),
                         (302,  1,             'qs2',                    'STRING',    'NULL'),
                         (303,  1,             'qs3',                    'STRING',    'NULL'),
                         (304,  1,             'qs4',                    'STRING',    'NULL'),
                         (305,  1,             'qs5',                    'STRING',    'NULL'),
                         (306,  1,             'qs6',                    'STRING',    'NULL'),
                         (401,  1,             'ql1',                    'LONG',      'NULL'),
                         (402,  1,             'ql2',                    'LONG',      'NULL'),
                         (403,  1,             'ql3',                    'LONG',      'NULL'),
                         (404,  1,             'ql4',                    'LONG',      'NULL'),
                         (405,  1,             'ql5',                    'LONG',      'NULL'),
                         (406,  1,             'ql6',                    'LONG',      'NULL'),
                         (501,  1,             'qts1',                   'STRING',    'NULL'),
                         (502,  1,             'qts2',                   'STRING',    'NULL'),
                         (503,  1,             'qts3',                   'STRING',    'NULL'),
                         (504,  1,             'qts4',                   'STRING',    'NULL'),
                         (505,  1,             'qts5',                   'STRING',    'NULL'),
                         (506,  1,             'qts6',                   'STRING',    'NULL'),
                         (1201, 1,             'df1',                    'FLOAT',     'NULL'),
                         (1202, 1,             'df2',                    'FLOAT',     'NULL'),
                         (1203, 1,             'df3',                    'FLOAT',     'NULL'),
                         (1204, 1,             'df4',                    'FLOAT',     'NULL'),
                         (1205, 1,             'df5',                    'FLOAT',     'NULL'),
                         (1206, 1,             'df6',                    'FLOAT',     'NULL'),
                         (1301, 1,             'ds1',                    'STRING',    'NULL'),
                         (1302, 1,             'ds2',                    'STRING',    'NULL'),
                         (1303, 1,             'ds3',                    'STRING',    'NULL'),
                         (1304, 1,             'ds4',                    'STRING',    'NULL'),
                         (1305, 1,             'ds5',                    'STRING',    'NULL'),
                         (1306, 1,             'ds6',                    'STRING',    'NULL'),
                         (1401, 1,             'dl1',                    'LONG',      'NULL'),
                         (1402, 1,             'dl2',                    'LONG',      'NULL'),
                         (1403, 1,             'dl3',                    'LONG',      'NULL'),
                         (1404, 1,             'dl4',                    'LONG',      'NULL'),
                         (1405, 1,             'dl5',                    'LONG',      'NULL'),
                         (1406, 1,             'dl6',                    'LONG',      'NULL'),
                         (1501, 1,             'dts1',                   'STRING',    'NULL'),
                         (1502, 1,             'dts2',                   'STRING',    'NULL'),
                         (1503, 1,             'dts3',                   'STRING',    'NULL'),
                         (1504, 1,             'dts4',                   'STRING',    'NULL'),
                         (1505, 1,             'dts5',                   'STRING',    'NULL'),
                         (1506, 1,             'dts6',                   'STRING',    'NULL');

CREATE TABLE IF NOT EXISTS `meta_field_mapping` (
  `id`                  BIGINT(20)      NOT NULL AUTO_INCREMENT,
  `merge_id`            BIGINT(20)      NOT NULL,
  `source_relation_id`  BIGINT(20)      NOT NULL,
  `target_relation_id`  BIGINT(20)      NOT NULL,
  `source_field`        VARCHAR(255)    NOT NULL,
  `target_field`        VARCHAR(255)    NOT NULL,
  `creator`             VARCHAR(40)     NOT NULL DEFAULT 'sys',
  `updater`             VARCHAR(40)     NOT NULL DEFAULT 'sys',
  `create_time`         DATETIME        DEFAULT CURRENT_TIMESTAMP,
  `update_time`         DATETIME        DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `u_idx_merge_id_source` (`merge_id`, `source_relation_id`, `source_field`),
  UNIQUE KEY `u_idx_merge_id_target` (`merge_id`, `target_relation_id`, `target_field`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;

INSERT INTO `meta_field_mapping` (`id`, `merge_id`, `source_relation_id`, `target_relation_id`, `source_field`, `target_field`) VALUES
                                 (1,    1,          10,                   1,                    'data_time',    '__time'),
                                 (2,    1,          10,                   1,                    'p_id',         'project_id'),
                                 (3,    1,          10,                   1,                    'p_v',          'project_version'),
                                 (4,    1,          10,                   1,                    'answer_1',     'qf1'),
                                 (5,    1,          10,                   1,                    'answer_2',     'qs1'),
                                 (6,    1,          10,                   1,                    'region_id_1',  'qf2'),
                                 (7,    1,          10,                   1,                    'region_id_2',  'qs2'),
                                 (8,    1,          10,                   1,                    'catalog_id',   'qs3'),
                                 (9,    1,          100,                  1,                    'ref_id',       'qs4'),
                                 (101,  1,          11,                   1,                    'province',     'ds1'),
                                 (102,  1,          11,                   1,                    'city',         'ds2'),
                                 (103,  1,          11,                   1,                    'block',        'ds3'),
                                 (201,  1,          12,                   1,                    'catalog_l1',   'ds4'),
                                 (202,  1,          12,                   1,                    'catalog_l2',   'ds5'),
                                 (301,  1,          100,                  1,                    'ext',          'ds6');

CREATE TABLE IF NOT EXISTS `meta_merge` (
  `id`                  BIGINT(20)      NOT NULL AUTO_INCREMENT,
  `project_id`          VARCHAR(40)     NOT NULL,
  `project_version`     BIGINT(20)      NOT NULL,
  `status`              INT(11)         NOT NULL COMMENT '0 disabled, 1 enabled',
  `creator`             VARCHAR(40)     NOT NULL DEFAULT 'sys',
  `updater`             VARCHAR(40)     NOT NULL DEFAULT 'sys',
  `create_time`         DATETIME        DEFAULT CURRENT_TIMESTAMP,
  `update_time`         DATETIME        DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_project_id_project_version` (`project_id`, `project_version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;

INSERT INTO `meta_merge` (`id`, `project_id`, `project_version`, `status`) VALUES
                         (1,    'p_001',      2,                 1);

CREATE TABLE IF NOT EXISTS `meta_conjunction` (
  `id`                  BIGINT(20)      NOT NULL AUTO_INCREMENT,
  `merge_id`            BIGINT(20)      NOT NULL,
  `left_relation_id`    BIGINT(20)      NOT NULL COMMENT 'should be a fact relation, one project_id should have one left_relation_id',
  `right_relation_id`   BIGINT(20)      NOT NULL COMMENT 'should be a dimension relation',
  `priority`            INT(11)         NOT NULL COMMENT 'small means high priority',
  `type`                INT(11)         NOT NULL COMMENT '0 normal, 1 use full_expression',
  `logical_op`          VARCHAR(40)     NOT NULL DEFAULT ''  COMMENT 'and | or | not',
  `join_type`           VARCHAR(40)     NOT NULL COMMENT 'left join',
  `op`                  VARCHAR(40)     NOT NULL DEFAULT '=' COMMENT 'currently only support =',
  `left_expr`           VARCHAR(2000)   NOT NULL DEFAULT ''  COMMENT 'typically should be field name',
  `right_expr`          VARCHAR(2000)   NOT NULL DEFAULT ''  COMMENT 'typically should be field name',
  `full_expr`           VARCHAR(2000)   NOT NULL DEFAULT ''  COMMENT 'to support complex nested conjunction',
  `creator`             VARCHAR(40)     NOT NULL DEFAULT 'sys',
  `updater`             VARCHAR(40)     NOT NULL DEFAULT 'sys',
  `create_time`         DATETIME        DEFAULT CURRENT_TIMESTAMP,
  `update_time`         DATETIME        DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_merge_id` (`merge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;

INSERT INTO `meta_conjunction` (`id`, `merge_id`, `left_relation_id`, `right_relation_id`, `priority`, `type`, `logical_op`, `join_type`, `op`, `left_expr`,   `right_expr`, `full_expr`) VALUES
                               (11,   1,          10,                 11,                  1,           0,     'and',        'left join', '=',  'region_id_1', 'id_1',       ''),
                               (12,   1,          10,                 11,                  2,           0,     'and',        'left join', '=',  'region_id_2', 'id_2',       ''),
                               (21,   1,          10,                 12,                  1,           0,     'and',        'left join', '=',  'catalog_id',  'id',         ''),
                               (31,   1,          10,                 100,                 1,           0,     'and',        'left join', '=',  'ref_id',      'id',         '');

CREATE TABLE IF NOT EXISTS `schdl_job` (
  `id`                  BIGINT(20)      NOT NULL AUTO_INCREMENT,
  `project_id`          VARCHAR(40)     NOT NULL,
  `project_version`     BIGINT(20)      NOT NULL,
  `merge_id`            BIGINT(20)      NOT NULL,
  `name`                VARCHAR(200)    NOT NULL,
  `description`         VARCHAR(500)    NOT NULL DEFAULT '',
  `props`               JSON            NULL,
  `callback`            JSON            NULL,
  `type`                INT(11)         NOT NULL,
  `status`              INT(11)         NOT NULL COMMENT '0 init, 1 running, 2 success, 3 failed, 4 skipped',
  `retry_time`          INT(11)         NOT NULL DEFAULT 0,
  `max_retry_time`      INT(11)         NOT NULL,
  `last_start_time`     DATETIME        NULL,
  `last_stop_time`      DATETIME        NULL,
  `creator`             VARCHAR(40)     NOT NULL DEFAULT 'sys',
  `updater`             VARCHAR(40)     NOT NULL DEFAULT 'sys',
  `create_time`         DATETIME        DEFAULT CURRENT_TIMESTAMP,
  `update_time`         DATETIME        DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `schdl_log` (
  `id`                  BIGINT(20)      NOT NULL AUTO_INCREMENT,
  `job_id`              BIGINT(20)      NOT NULL,
  `from_state`          INT(11)         NULL,
  `to_state`            INT(11)         NULL,
  `content`             JSON            NULL,
  `creator`             VARCHAR(40)     NOT NULL DEFAULT 'sys',
  `create_time`         DATETIME        DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_job_id` (`job_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;

--foreign key
--
--alter table meta_conjunction add constraint fk_meta_conjunction_merge_id foreign key (merge_id) references meta_merge (id);
--alter table meta_conjunction add constraint fk_meta_conjunction_left_relation_id foreign key (left_relation_id) references meta_relation (id);
--alter table meta_conjunction add constraint fk_meta_conjunction_right_relation_id foreign key (right_relation_id) references meta_relation (id);
--
--alter table meta_field add constraint fk_meta_field_relation_id foreign key (relation_id) references meta_relation (id);
--
--alter table meta_field_mapping add constraint fk_meta_field_mapping_merge_id foreign key (merge_id) references meta_merge (id);
--alter table meta_field_mapping add constraint fk_meta_field_mapping_source_relation_id_field foreign key (source_relation_id, source_field) references meta_field (relation_id, name);
--alter table meta_field_mapping add constraint fk_meta_field_mapping_target_relation_id_field foreign key (target_relation_id, target_field) references meta_field (relation_id, name);
--
--alter table meta_merge add constraint fk_meta_merge_project_id_version foreign key (project_id, project_version) references meta_project (id, version);
--
--alter table meta_project add constraint fk_meta_project_parent_id foreign key (parent_id) references meta_project (id);
--
--alter table schdl_job add constraint fk_schdl_job_project_id_version foreign key (project_id, project_version) references meta_project (id, version);
--alter table schdl_job add constraint fk_schdl_job_merge_id foreign key (merge_id) references meta_merge (id);
--
--alter table schdl_log add constraint fk_schdl_log_job_id foreign key (job_id) references schdl_job (id);