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
CREATE TABLE `civilite` (
    `id`      TINYINT     UNSIGNED NOT NULL AUTO_INCREMENT,
    `abrege`  VARCHAR(5)  NOT NULL,
    `complet` VARCHAR(12) NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table utilisateur_role --
CREATE TABLE `utilisateur_role` (
    `id`      TINYINT     UNSIGNED NOT NULL AUTO_INCREMENT,
    `role`    VARCHAR(7),
    PRIMARY KEY (`id`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table utilisateur --
CREATE TABLE `utilisateur` (
    `id`              SMALLINT        UNSIGNED NOT NULL AUTO_INCREMENT,
    `email`           VARCHAR(30)     NOT NULL,
    `mot_de_passe`    VARCHAR(32)    NOT NULL,
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


-- Table livreur_statut --
CREATE TABLE `livreur_statut` (
    `id`      TINYINT     UNSIGNED NOT NULL AUTO_INCREMENT,
    `label`   VARCHAR(21),
    PRIMARY KEY (`id`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table livreur --
CREATE TABLE `livreur` (
    `id`          SMALLINT        UNSIGNED NOT NULL,
    `id_statut`   TINYINT         UNSIGNED NOT NULL,
    `latitude`    DECIMAL(9,7),
    `longitude`   DECIMAL (8,7),
    `telephone`   CHAR(10),
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_livreur_id`          FOREIGN KEY (`id`)          REFERENCES `utilisateur` (`id`)     ON DELETE CASCADE,
    CONSTRAINT `fk_livreur_id_statut`   FOREIGN KEY (`id_statut`)   REFERENCES `livreur_statut` (`id`)  ON UPDATE CASCADE,
    CONSTRAINT UNIQUE INDEX `ind_uni_telephone` (`telephone`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table client --
CREATE TABLE `client` (
    `id`          SMALLINT    UNSIGNED NOT NULL,
    `telephone`   CHAR(10),
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_client_id` FOREIGN KEY (`id`) REFERENCES `utilisateur` (`id`) ON DELETE CASCADE,
    CONSTRAINT UNIQUE INDEX `ind_uni_telephone` (`telephone`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table client_cb --
CREATE TABLE `client_cb` (
    `id`          SMALLINT    UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_client`   SMALLINT    UNSIGNED NOT NULL,
    `numero`      BIGINT      NOT NULL,
    `nom`         VARCHAR(30) NOT NULL,
    `date`        DATE        NOT NULL,
    `crypto`      CHAR(3)     NOT NULL,
    `defaut`      TINYINT     NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_client_cb_id_client` FOREIGN KEY (`id_client`) REFERENCES `client` (`id`) ON DELETE CASCADE,
    CONSTRAINT UNIQUE INDEX `ind_uni_numero` (`numero`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table adresse_livraison --
CREATE TABLE `adresse_livraison` (
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
CREATE TABLE `commande_paiement_type` (
    `id`      TINYINT     UNSIGNED NOT NULL AUTO_INCREMENT,
    `label`   VARCHAR(7)  NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table commande_statut --
CREATE TABLE `commande_statut` (
    `id`      TINYINT         UNSIGNED NOT NULL AUTO_INCREMENT,
    `label`   VARCHAR(25)     NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table commande --
CREATE TABLE `commande` (
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
CREATE TABLE `plat_type` (
    `id`      TINYINT     UNSIGNED NOT NULL AUTO_INCREMENT,
    `label`   VARCHAR(7)  NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- Table plat --
CREATE TABLE `plat` (
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
CREATE TABLE `plat_jour` (
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
CREATE TABLE `commande_plat_jour` (
    `num_commande`    MEDIUMINT   UNSIGNED NOT NULL,
    `id_plat_jour`    SMALLINT    UNSIGNED NOT NULL,
    `quantite`        TINYINT     UNSIGNED NOT NULL,
    PRIMARY KEY (`num_commande`, `id_plat_jour`),
    CONSTRAINT `fk_commande_plat_jour_num_commande` FOREIGN KEY (`num_commande`) REFERENCES `commande` (`numero`) ON DELETE CASCADE,
    CONSTRAINT `fk_commande_plat_jour_id_plat_jour` FOREIGN KEY (`id_plat_jour`) REFERENCES `plat_jour` (`id`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- ------------------------------ --
-- --------- Données ------------ --
-- ------------------------------ --

-- civilite --
INSERT INTO `civilite`
    (`abrege`, `complet`)
VALUES
    ('MME', 'MADAME'),
    ('MR', 'MONSIEUR');

-- utilisateur_role --
INSERT INTO `utilisateur_role`
    (`role`)
VALUES
    ('ADMIN'),
    ('CLIENT'),
    ('LIVREUR');

-- livreur_statut --
INSERT INTO `livreur_statut`
    (`label`)
VALUES
    ('LIBRE'),
    ('EN COURS DE LIVRAISON'),
    ('INDISPONIBLE');

-- commande_paiement_type --
INSERT INTO `commande_paiement_type`
    (`label`)
VALUES
    ('CB'),
    ('CHEQUE'),
    ('ESPECES');

-- commande_statut --
INSERT INTO `commande_statut`
    (`label`)
VALUES
    ('EN CREATION'),
    ('EN ATTENTE INFOS PAIEMENT'),
    ('EN ATTENTE DE LIVRAISON'),
    ('EN COURS DE LIVRAISON'),
    ('LIVREE'),
    ('ANNULEE');

-- plat_type --
INSERT INTO `plat_type`
    (`label`)
VALUES
    ('PLAT'),
    ('DESSERT');

-- utilisateur --
INSERT INTO `utilisateur`
    (`email`, `mot_de_passe`, `id_role`, `id_civilite`, `nom`, `prenom`)
VALUES
    ('admin@express-food.fr', '21232f297a57a5a743894a0e4a801fc3', 1, 2, 'Dune', 'Frédéric'),
    ('john.crud@express-food.fr', 'b7234ccb31cd16a52554375db94f572f', 3, 2, 'Crud', 'John'),
    ('isabelle.genet@express-food.fr', '4b5537283d01e37ac32e8f1f50213671', 3, 1, 'Genet', 'Isabelle'),
    ('julien.sayard@express-food.fr', '2643dac47fe03525a9415a9010447ee9', 3, 2, 'Sayard', 'Julien'),
    ('alan.taff243@gmail.com', 'cf0d46775e405d8a75ff8ea2d606eb2b', 2, 2, 'Taff', 'Alan'),
    ('jean.gayard@free.fr', '0130beb6f379994a806e6909c9c272b7', 2, 2, 'Gayard', 'Jean'),
    ('juliette.remi254@gmail.com', '4a537821a592020c8250d1118ab0d0ff', 2, 1, 'Remi', 'Juliette'),
    ('fred.sanpan@outlook.com', '2fb8f578a1ba1adeae2a63445a1517c6', 2, 2, 'Sanpan', 'Frederic'),
    ('lisa.prost@free.fr', '648fd349448abf4810ca8df6c3b78af0', 2, 1, 'Prost', 'Lisa');

-- livreur --
INSERT INTO `livreur`
    (`id`, `id_statut`, `latitude`, `longitude`, `telephone`)
VALUES
    (2, 1, 48.8629708,2.2740593, '0734342314'),
    (3, 2, 48.8506796,2.2985789, '0657442113'),
    (4, 3, NULL, NULL, '0624243112');

-- client --
INSERT INTO `client`
    (`id`, `telephone`)
VALUES
    (5, '0734524444'),
    (6, '0781224336'),
    (7, '0674553223'),
    (8, '0721343423'),
    (9, '0675312244');

-- client_cb --
INSERT INTO `client_cb`
    (`id_client`, `numero`, `nom`, `date`, `crypto`, `defaut`)
VALUES
    (7, 5421445536522534, 'REMI JULIETTE', '2022-11-04', '342', TRUE),
    (7, 5432556377289385, 'REMI JULIETTE', '2021-10-08', '241', FALSE),
    (8, 4567542341526354, 'F. SANPAN', '2021-10-24', '117', TRUE);

-- adresse_livraison --
INSERT INTO `adresse_livraison`
    (`id_client`, `adresse`, `code_postal`, `ville`, `info`, `defaut`)
VALUES
    (NULL, '8 Rue Mignard', '75116', 'Paris', '3eme étage', TRUE),
    (6, '26 Rue de l''Assomption', '75016', 'Paris', 'Au fond de la cour, porte jaune sur la droite, Sonner fort!.', TRUE),
    (7, '15 Rue des Quatre-Vents', '75006', 'Paris', '7eme étage', TRUE),
    (7, '30 Rue Chapon', '75003', 'Paris', 'A l\accueil, Demander la societe ATC Caractères', TRUE),
    (8, '5 Avenue du Coq', '75009', 'Paris', '5eme étage', TRUE),
    (9, '8 Rue Jarry', '75010', 'Paris', 'Porte noire 2eme étage', TRUE),
    (9, '31 Rue Fessart', '75019', 'Paris', 'Société RTC Connect', TRUE);

-- plat --
INSERT INTO `plat`
    (`id_type`, `nom`, `description`, `image`, `dernier_prix_vente`)
VALUES
    (1, 'Filet mignon de porc sauce balsamique', 'hiuhqd qsudhf iqsudhf qsidufhqisudfhqsiduf  qsdifuhqs dfuhq sdfhqsdfhqs.', '/plat/plat_1.jpeg', NULL),
    (1, 'Salade lyonnaise', 'hiuhqd qsudhf iqsudhf  qsdf fhqi sudfhqsiduf.  qsdifuhqs dfuhq sdfhqsdfhqs.', '/plat/plat_2.jpeg', 23.50),
    (1, 'Confit de cannard & pommes de terres sarladaises', ' qsudhf  qsidufhqisudfhqsiduf  qsdifuhqs dfuhq sdfhqsdfhqs.', '/plat/plat_3.jpeg', 32),
    (1, 'Filet de cabillaud sauce citron', 'hiuhqd qsqsdfqsdfudhf iqsudhf qsidufhqiduf dsf fdfd   dfuhq sdfhqsdfhqs.', '/plat/plat_4.jpeg', 27.50),
    (1, 'Boeuf bourguignon', 'hiuhqd qsudhf iqsudhf qsidufhqisudfhqsiduf  qsdifuhqs dfuhq sdfhqsdfhqs.', '/plat/plat_5.jpeg', 23.50),
    (2, 'Fondant au chocolat', 'hiuhqd qsudhf iqsudhf qsidufhqisudfhqsiduf  qsdifuhqs dfuhq sdfhqsdfhqs.', '/dessert/dessert_6.jpeg', 14.50),
    (2, 'Crumble de mangues', 'hiuhqd qsudhf iqsudhf qsidu  fhqisudfhqsiduf  qsdifuhqs dfuhq  qdfqd dhh dhf qosdfihqhdf.', '/dessert/dessert_7.jpeg', NULL),
    (2, 'Crème brulée', 'hiuhqd  iqsudhf qsidufhqisudfhqsiduf  qsdifuhqs dfuh dd dddq sdfhqsdfhqs.', '/dessert/dessert_8.jpeg', 11),
    (2, 'Salade de fruits exotique', 'hi uhqd qsucccdhf iqsudhf qsidufhqisudfhqsiduf  qsdifuhqs dfuhq sdfhqsdfhqs.', '/dessert/dessert_9.jpeg', 11),
    (2, 'Île flottante', 'hiuhqd qsudhf iqsudhf qsidufhqisudfhq siduf  qsdifuhqs dfuhq sdfhqsdfhqs.', '/dessert/dessert_10.jpeg', 12),
    (2, 'Paris Brest', 'hiuhqd qsudhf iqsqsdc udhf qsidufhqisudfhqsiduf  qsdifuhqs df  fgddfguhq .', '/dessert/dessert_11.jpeg', 14),
    (1, 'Velouté de cêpes aux lardons de foie gras', 'hi qdfqsdfqsdf deuhqd qsudhf iqsudhf qsidufhqisudfhqsiduf  qsdifuhqs dfuhq sdfhqsdfhqs.', '/plat/plat_12.jpeg', 28.50);

-- plat_jour --
INSERT INTO `plat_jour`
    (`id_plat`, `date`, `prix`)
VALUES
    (2, '2019-10-02', 22.50), (3, '2019-10-02', 31), (9, '2019-10-02', 10), (11, '2019-10-02', 13),
    (2, '2020-10-21', 23.50), (4, '2020-10-21', 27.00), (6, '2020-10-21', 14.50), (10, '2020-10-21', 12),
    (3, '2020-10-22', 32), (5, '2020-10-22', 23.00), (8, '2020-10-22', 11), (11, '2020-10-22', 14),
    (4, '2020-10-23', 27.50), (2, '2020-10-23', 23.50), (8, '2020-10-23', 11), (9, '2020-10-23', 11);


-- commande --
INSERT INTO `commande`
    (`id_statut`, `id_client`, `id_adresse`, `id_livreur`, `type_paiement`, `temps_livraison`)
VALUES
    (5, 7, 3, 2, 1, 14),
    (4, 9, 7, 3, NULL, 9),
    (6, 5, 1, 2, 2, NULL),
    (1, 6, NULL, NULL, NULL, NULL),
    (2, 8, 5, NULL, NULL, NULL),
    (3, 7, 4, NULL, 1, NULL),
    (5, 6, 2, 4, 3, 13),
    (5, 6, 6, 4, 1, 18);

INSERT INTO `commande_plat_jour`
    (`num_commande`, `id_plat_jour`, `quantite`)
VALUES
    (1, 1, 2), (1, 2, 4), (1, 3, 4), (1, 4, 2),
    (2, 5, 1), (2, 8, 1),
    (3, 9, 2), (3, 10, 1), (3, 11, 3),
    (4, 9, 1), (4, 10, 1), (4, 11, 1), (4, 12, 1),
    (5, 13, 1), (5, 15, 1),
    (6, 13, 3), (6, 14, 1), (6, 15, 2), (6, 16, 2),
    (7, 14, 2), (7, 16, 2),
    (8, 13, 4), (8, 14, 1), (8, 15, 2), (8, 16, 3);








