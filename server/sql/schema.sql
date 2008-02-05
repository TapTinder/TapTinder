-- Do not edit this file.
-- Generated from: 'sql\schema.wiki'

-- table list:
-- `client`, `conf`, `project`, `rep`, `rep_file`, `rep_path`, `rep_test`, `rev`, `tdiag_msg`, `tfile`, `tresult`, `trun`, `tskipall_msg`, `ttest`, `user`, `user_rep`

-- Drop all tables:
SET FOREIGN_KEY_CHECKS=0; DROP TABLE IF EXISTS `client`, `conf`, `project`, `rep`, `rep_file`, `rep_path`, `rep_test`, `rev`, `tdiag_msg`, `tfile`, `tresult`, `trun`, `tskipall_msg`, `ttest`, `user`, `user_rep`;

-- line: 6
SET FOREIGN_KEY_CHECKS=0;
start transaction;


-- line: 17
CREATE TABLE user (
    user_id     INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    login       VARCHAR(20) NOT NULL,
    passwd      VARCHAR(20) NOT NULL,
    active      BOOLEAN NOT NULL DEFAULT 1,
    created     DATETIME NOT NULL,
    last_login  DATETIME DEFAULT NULL,
    INDEX login (login)
) TYPE=InnoDB;


-- line: 40
CREATE TABLE client (
    client_id       INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    passwd          VARCHAR(20) NOT NULL,
    user_id         INT UNSIGNED NOT NULL,
    created         DATETIME NOT NULL,
    last_login      DATETIME DEFAULT NULL,
    ip              VARCHAR(15) DEFAULT NULL,
    cpuarch         VARCHAR(50) DEFAULT NULL,
    osname          VARCHAR(50) DEFAULT NULL,
    archname        VARCHAR(255) DEFAULT NULL,
    active          BOOLEAN NOT NULL DEFAULT 1,
    prev_client_id  INT UNSIGNED DEFAULT NULL,
    CONSTRAINT `fk_client_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
    CONSTRAINT `fk_client_prev_client_id` FOREIGN KEY (`prev_client_id`) REFERENCES `client` (`client_id`)
) TYPE=InnoDB;


-- line: 63
CREATE TABLE project (
    project_id      INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    name            VARCHAR(255) NOT NULL,
    url             VARCHAR(255) NOT NULL,
    info            TEXT DEFAULT NULL
) TYPE=InnoDB;


-- line: 81
CREATE TABLE rep (
    rep_id      INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    project_id  INT UNSIGNED NOT NULL,
    active      BOOLEAN NOT NULL DEFAULT 1,
    name        VARCHAR(255) NOT NULL,
    path        VARCHAR(255) NOT NULL,
    url         VARCHAR(255) DEFAULT NULL,
    info        TEXT DEFAULT NULL,
    CONSTRAINT `fk_rep_project_id` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`)
) TYPE=InnoDB;


-- line: 100
CREATE TABLE user_rep (
    user_rep_id     INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    rep_id          INT UNSIGNED NOT NULL,
    rep_login       VARCHAR(255) NOT NULL,
    user_id         INT UNSIGNED DEFAULT NULL,
    INDEX i_rep_id (rep_id),
    INDEX i_rep_login (rep_login),
    INDEX i_user_id (user_id),
    CONSTRAINT `fk_user_rep_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
    CONSTRAINT `fk_user_rep_rep_id` FOREIGN KEY (`rep_id`) REFERENCES `rep` (`rep_id`)
) TYPE=InnoDB;


-- line: 120
CREATE TABLE rep_path (
    rep_path_id     INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    rep_id          INT UNSIGNED NOT NULL,
    path            VARCHAR(255) NOT NULL,
    base_rev_id     INT UNSIGNED DEFAULT NULL,
    INDEX i_rep_id (rep_id),
    CONSTRAINT `fk_rep_path_rep_id` FOREIGN KEY (`rep_id`) REFERENCES `rep` (`rep_id`),
    CONSTRAINT `fk_rep_path_base_rev_id` FOREIGN KEY (`base_rev_id`) REFERENCES `rev` (`rev_id`)
) TYPE=InnoDB;


-- line: 141
CREATE TABLE rev (
    rev_id          INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    number          INT UNSIGNED NOT NULL,
    rep_path_id     INT UNSIGNED NOT NULL,
    author_id       INT UNSIGNED NOT NULL,
    date            DATETIME NOT NULL,
    msg             TEXT,
    INDEX i_number (number),
    CONSTRAINT `fk_rev_rep_path_id` FOREIGN KEY (`rep_path_id`) REFERENCES `rep_path` (`rep_path_id`),
    CONSTRAINT `fk_rev_rep_author_id` FOREIGN KEY (`author_id`) REFERENCES `user_rep` (`user_rep_id`)
) TYPE=InnoDB;


-- line: 164
CREATE TABLE rep_file (
    rep_file_id     INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    rep_path_id     INT UNSIGNED NOT NULL,
    sub_path        VARCHAR(255) NOT NULL,
    file_name       VARCHAR(255) NOT NULL,
    rev_from_id     INT UNSIGNED NOT NULL,
    rev_to_id       INT UNSIGNED DEFAULT NULL,
    tests_num       INT UNSIGNED NOT NULL,
    INDEX i_rep_path_id (rep_path_id),
    INDEX i_rev_from_id (rev_from_id),
    INDEX i_rev_to_id (rev_to_id),
    CONSTRAINT `fk_rep_file_rep_path_id` FOREIGN KEY (`rep_path_id`) REFERENCES `rep_path` (`rep_path_id`),
    CONSTRAINT `fk_rep_file_rev_from_id` FOREIGN KEY (`rev_from_id`) REFERENCES `rev` (`rev_id`),
    CONSTRAINT `fk_rep_file_rev_to_id` FOREIGN KEY (`rev_to_id`) REFERENCES `rev` (`rev_id`)
) TYPE=InnoDB;


-- line: 189
CREATE TABLE rep_test (
    rep_test_id         INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    rep_file_id         INT UNSIGNED NOT NULL,
    number              INT UNSIGNED NOT NULL,
    name                VARCHAR(255) NOT NULL,
    has_another_name    BOOLEAN NOT NULL DEFAULT 0,
    INDEX i_rep_file_id (rep_file_id),
    CONSTRAINT `fk_rep_test_rep_file_id` FOREIGN KEY (`rep_file_id`) REFERENCES `rep_file` (`rep_file_id`)
) TYPE=InnoDB;


-- line: 210
CREATE TABLE conf (
    conf_id         INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    hash            VARCHAR(50) NOT NULL,
    cc              VARCHAR(255) DEFAULT NULL,
    harness_args    VARCHAR(255) DEFAULT NULL,
    devel           VARCHAR(255) DEFAULT NULL,
    `optimize`      VARCHAR(255) DEFAULT NULL,
    alias_conf_id   INT UNSIGNED DEFAULT NULL,
    INDEX i_hash (hash),
    CONSTRAINT `fk_conf_alias_conf_id` FOREIGN KEY (`conf_id`) REFERENCES `conf` (`conf_id`)
) TYPE=InnoDB;


-- line: 236
CREATE TABLE trun (
    trun_id         INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    client_id       INT UNSIGNED NOT NULL,
    conf_id         INT UNSIGNED NOT NULL,
    rev_id          INT UNSIGNED NOT NULL,
    num_failed      INT UNSIGNED NOT NULL,
    num_notseen     INT UNSIGNED NOT NULL,
    num_todo        INT UNSIGNED NOT NULL,
    num_bonus       INT UNSIGNED NOT NULL,
    num_skip        INT UNSIGNED NOT NULL,
    num_ok          INT UNSIGNED NOT NULL,
    INDEX i_client_id (client_id),
    INDEX i_conf_id (conf_id),
    CONSTRAINT `fk_trun_client_id` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`),
    CONSTRAINT `fk_trun_conf_id` FOREIGN KEY (`conf_id`) REFERENCES `conf` (`conf_id`)
) TYPE=InnoDB;


-- line: 260
CREATE TABLE tskipall_msg (
    tskipall_msg_id     INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    msg                 TEXT,
    hash                VARCHAR(50) NOT NULL,
    INDEX i_hash (hash)
) TYPE=InnoDB;


-- line: 275
CREATE TABLE tfile (
    tfile_id            INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    trun_id             INT UNSIGNED NOT NULL,
    all_passed          BOOLEAN NOT NULL DEFAULT 0,
    tskippall_msg_id    INT UNSIGNED DEFAULT NULL,
    INDEX i_trun_id (trun_id),
    CONSTRAINT `fk_tfile_trun_id` FOREIGN KEY (`trun_id`) REFERENCES `trun` (`trun_id`)
) TYPE=InnoDB;


-- line: 291
CREATE TABLE tresult (
    tresult_id      INT UNSIGNED NOT NULL PRIMARY KEY,
    title           VARCHAR(10),
    info            VARCHAR(255)
) TYPE=InnoDB;


-- line: 304
CREATE TABLE ttest (
    ttest_id            INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    rep_test_id         INT UNSIGNED NOT NULL,
    tresult_id          INT UNSIGNED NOT NULL,
    INDEX i_rep_test_id (rep_test_id),
    INDEX i_tresult_id (tresult_id),
    CONSTRAINT `fk_ttest_rep_test_id` FOREIGN KEY (`rep_test_id`) REFERENCES `rep_test` (`rep_test_id`),
    CONSTRAINT `fk_ttest_tresult_id` FOREIGN KEY (`tresult_id`) REFERENCES `tresult` (`tresult_id`)
) TYPE=InnoDB;


-- line: 322
CREATE TABLE tdiag_msg (
    tdiag_msg_id    INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ttest_id        INT UNSIGNED NOT NULL,
    msg             TEXT,
    hash            VARCHAR(50) NOT NULL,
    INDEX i_ttest_id (ttest_id),
    INDEX i_hash (hash),
    CONSTRAINT `fk_tdiag_msg_ttest_id` FOREIGN KEY (`ttest_id`) REFERENCES `ttest` (`ttest_id`)
) TYPE=InnoDB;


-- line: 334
commit;

