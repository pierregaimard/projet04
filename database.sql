-- ------------------------------ --
-- ------ Base de donnee -------- --
-- ------------------------------ --

DROP DATABASE IF EXISTS `express_food`;
CREATE DATABASE `express_food` CHARACTER SET 'utf8mb4';

USE express_food;

-- ------------------------------ --
-- ---------- Tables ------------ --
-- ------------------------------ --

-- Table civilite --
CREATE TABLE IF NOT EXISTS `civilite` (
    `id`      TINYINT     UNSIGNED NOT NULL AUTO_INCREMENT,
    `abrege`  VARCHAR(5)  NOT NULL,
    `complet` VARCHAR(12) NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table utilisateur_role --
CREATE TABLE IF NOT EXISTS `utilisateur_role` (
    `id`      TINYINT     UNSIGNED NOT NULL AUTO_INCREMENT,
    `role`    VARCHAR(7),
    PRIMARY KEY (`id`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table utilisateur --
CREATE TABLE IF NOT EXISTS `utilisateur` (
    `id`              SMALLINT        UNSIGNED NOT NULL AUTO_INCREMENT,
    `email`           VARCHAR(30)     NOT NULL,
    `mot_de_passe`    VARCHAR(100)    NOT NULL,
    `id_role`         TINYINT         UNSIGNED NOT NULL,
    `id_civilite`     TINYINT         UNSIGNED NOT NULL,
    `nom`             VARCHAR(20)     NOT NULL,
    `prenom`          VARCHAR(20),
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_utilisateur_id_role` FOREIGN KEY (`id_role`) REFERENCES `utilisateur_role` (`id`) ON UPDATE CASCADE,
    CONSTRAINT UNIQUE INDEX `ind_uni_email` (`email`),
    INDEX `ind_nom` (`nom`(10))
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table admin --
CREATE TABLE IF NOT EXISTS `administrateur` (
    `id` SMALLINT    UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_administrateur_id` FOREIGN KEY (`id`) REFERENCES `utilisateur` (`id`) ON DELETE CASCADE
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table livreur_statut --
CREATE TABLE IF NOT EXISTS `livreur_statut` (
    `id`      TINYINT     UNSIGNED NOT NULL AUTO_INCREMENT,
    `label`   VARCHAR(20),
    PRIMARY KEY (`id`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table livreur --
CREATE TABLE IF NOT EXISTS `livreur` (
    `id`          SMALLINT        UNSIGNED NOT NULL,
    `id_statut`   TINYINT         UNSIGNED NOT NULL,
    `latitude`    DECIMAL(10,8),
    `longitude`   DECIMAL (11,8),
    `telephone`   CHAR(10),
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_livreur_id`          FOREIGN KEY (`id`)          REFERENCES `utilisateur` (`id`)     ON DELETE CASCADE,
    CONSTRAINT `fk_livreur_id_statut`   FOREIGN KEY (`id_statut`)   REFERENCES `livreur_statut` (`id`)  ON UPDATE CASCADE,
    CONSTRAINT UNIQUE INDEX `ind_uni_telephone` (`telephone`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table client --
CREATE TABLE IF NOT EXISTS `client` (
    `id`          SMALLINT    UNSIGNED NOT NULL,
    `telephone`   CHAR(10),
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_client_id` FOREIGN KEY (`id`) REFERENCES `utilisateur` (`id`) ON DELETE CASCADE,
    CONSTRAINT UNIQUE INDEX `ind_uni_telephone` (`telephone`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table client_cb --
CREATE TABLE IF NOT EXISTS `client_cb` (
    `id`          SMALLINT    UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_client`   SMALLINT    UNSIGNED NOT NULL,
    `numero`      CHAR(16)    NOT NULL,
    `annee`       YEAR        NOT NULL,
    `mois`        CHAR(2)     NOT NULL,
    `crypto`      CHAR(3)     NOT NULL,
    `defaut`      TINYINT     NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_client_cb_id_client` FOREIGN KEY (`id_client`) REFERENCES `client` (`id`) ON DELETE CASCADE,
    CONSTRAINT UNIQUE INDEX `ind_uni_numero` (`numero`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table adresse_livraison --
CREATE TABLE IF NOT EXISTS `adresse_livraison` (
    `id`          SMALLINT        UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_client`   SMALLINT        UNSIGNED,
    `adresse`     VARCHAR(100)    NOT NULL,
    `code_postal` CHAR(5)         NOT NULL,
    `ville`       VARCHAR(30)     NOT NULL,
    `info`        TINYTEXT,
    `defaut`      TINYINT         NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_adresse_livraison_id_client` FOREIGN KEY (`id_client`) REFERENCES `client` (`id`) ON DELETE SET NULL
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table commande_paiement_type --
CREATE TABLE IF NOT EXISTS `commande_paiement_type` (
    `id`      TINYINT     UNSIGNED NOT NULL AUTO_INCREMENT,
    `label`   VARCHAR(7)  NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table commande_statut --
CREATE TABLE IF NOT EXISTS `commande_statut` (
    `id`      TINYINT         UNSIGNED NOT NULL AUTO_INCREMENT,
    `label`   VARCHAR(20)     NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table commande --
CREATE TABLE IF NOT EXISTS `commande` (
    `numero`          MEDIUMINT   UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_statut`       TINYINT     UNSIGNED NOT NULL,
    `id_client`       SMALLINT    UNSIGNED,
    `id_adresse`      SMALLINT    UNSIGNED,
    `id_livreur`      SMALLINT    UNSIGNED,
    `type_paiement`   TINYINT     UNSIGNED,
    `temps_livraison` TINYINT     UNSIGNED,
    PRIMARY KEY (`numero`),
    CONSTRAINT `fk_commande_id_statut`      FOREIGN KEY (`id_statut`)       REFERENCES `commande_statut` (`id`)         ON UPDATE CASCADE,
    CONSTRAINT `fk_commande_id_client`      FOREIGN KEY (`id_client`)       REFERENCES `client` (`id`)                  ON DELETE SET NULL,
    CONSTRAINT `fk_commande_id_adresse`     FOREIGN KEY (`id_adresse`)      REFERENCES `adresse_livraison` (`id`)       ON DELETE SET NULL,
    CONSTRAINT `fk_commande_id_livreur`     FOREIGN KEY (`id_livreur`)      REFERENCES `livreur` (`id`)                 ON DELETE SET NULL,
    CONSTRAINT `fk_commande_type_paiement`  FOREIGN KEY (`type_paiement`)   REFERENCES `commande_paiement_type` (`id`)  ON UPDATE CASCADE
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table Type --
CREATE TABLE IF NOT EXISTS `plat_type` (
    `id`      TINYINT     UNSIGNED NOT NULL AUTO_INCREMENT,
    `label`   VARCHAR(7)  NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table plat --
CREATE TABLE IF NOT EXISTS `plat` (
    `id`                  TINYINT         UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_type`             TINYINT         UNSIGNED NOT NULL,
    `nom`                 VARCHAR(50)     NOT NULL,
    `description`         TINYTEXT        NOT NULL,
    `image`               VARCHAR(30),
    `dernier_prix_vente`  DECIMAL(4,2),
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_plat_id_type` FOREIGN KEY (`id_type`) REFERENCES `plat_type` (`id`) ON UPDATE CASCADE,
    CONSTRAINT UNIQUE INDEX `ind_uni_nom` (`nom`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table plat_jour --
CREATE TABLE IF NOT EXISTS `plat_jour` (
    `id`          SMALLINT        UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_plat`     TINYINT         UNSIGNED,
    `date`        DATE            NOT NULL,
    `prix`        DECIMAL(4,2)    NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_plat_jour_id_plat` FOREIGN KEY (`id_plat`) REFERENCES `plat` (`id`) ON DELETE SET NULL
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table commande_plat --
CREATE TABLE IF NOT EXISTS `commande_plat_jour` (
    `num_commande`    MEDIUMINT   UNSIGNED NOT NULL,
    `id_plat_jour`    SMALLINT    UNSIGNED NOT NULL,
    `quantite`        TINYINT     UNSIGNED NOT NULL,
    PRIMARY KEY (`num_commande`, `id_plat_jour`),
    CONSTRAINT `fk_commande_plat_jour_num_commande` FOREIGN KEY (`num_commande`) REFERENCES `commande` (`numero`) ON DELETE CASCADE,
    CONSTRAINT `fk_commande_plat_jour_id_plat_jour` FOREIGN KEY (`id_plat_jour`) REFERENCES `plat_jour` (`id`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;