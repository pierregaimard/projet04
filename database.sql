-- ------------------------------ --
-- ------ Base de donnee -------- --
-- ------------------------------ --

DROP DATABASE IF EXISTS `express_food`;
CREATE DATABASE `express_food` CHARACTER SET 'utf8mb4';

USE express_food;

SET lc_time_names = 'fr_FR';


-- ------------------------------ --
-- ---------- Tables ------------ --
-- ------------------------------ --


-- -------------- --
-- Table civilite --
-- -------------- --
CREATE TABLE `civilite` (
    `id`      TINYINT     UNSIGNED NOT NULL AUTO_INCREMENT,
    `abrege`  VARCHAR(3)  NOT NULL,
    `complet` VARCHAR(8) NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- ---------------------- --
-- Table utilisateur_role --
-- ---------------------- --
CREATE TABLE `utilisateur_role` (
    `id`      TINYINT     UNSIGNED NOT NULL AUTO_INCREMENT,
    `role`    VARCHAR(7),
    PRIMARY KEY (`id`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- ----------------- --
-- Table utilisateur --
-- ----------------- --
CREATE TABLE `utilisateur` (
    `id`              SMALLINT        UNSIGNED NOT NULL AUTO_INCREMENT,
    `email`           VARCHAR(30)     NOT NULL,
    `mot_de_passe`    VARCHAR(32)     NOT NULL,
    `id_role`         TINYINT         UNSIGNED NOT NULL,
    `id_civilite`     TINYINT         UNSIGNED NOT NULL,
    `nom`             VARCHAR(20)     NOT NULL,
    `prenom`          VARCHAR(20),
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_utilisateur_id_role` FOREIGN KEY (`id_role`) REFERENCES `utilisateur_role` (`id`), -- suppression/modification interdite si utilisé par un `utilisateur`
    CONSTRAINT `fk_utilisateur_id_civilite` FOREIGN KEY (`id_civilite`) REFERENCES `civilite` (`id`), -- suppression/modification interdite si utilisé par un ' utilisateur`
    CONSTRAINT UNIQUE INDEX `ind_uni_email` (`email`), -- `email` doit être unique
    INDEX `ind_nom` (`nom`(10)) -- optimisation de la recherche sur le `nom` (utilisé pour les clients principalement)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- -------------------- --
-- Table livreur_statut --
-- -------------------- --
CREATE TABLE `livreur_statut` (
    `id`      TINYINT     UNSIGNED NOT NULL AUTO_INCREMENT,
    `label`   VARCHAR(21),
    PRIMARY KEY (`id`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- ------------- --
-- Table livreur --
-- ------------- --
CREATE TABLE `livreur` (
    `id`          SMALLINT        UNSIGNED NOT NULL,
    `id_statut`   TINYINT         UNSIGNED NOT NULL,
    `latitude`    DECIMAL(9,7),
    `longitude`   DECIMAL (8,7),
    `telephone`   CHAR(10),
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_livreur_id`          FOREIGN KEY (`id`)          REFERENCES `utilisateur` (`id`)     ON DELETE CASCADE, -- le `livreur` est lié a l' `utilisateur` (héritage)
    CONSTRAINT `fk_livreur_id_statut`   FOREIGN KEY (`id_statut`)   REFERENCES `livreur_statut` (`id`),  -- suppression/modification interdite si utilisé par un `livreur`
    CONSTRAINT UNIQUE INDEX `ind_uni_telephone` (`telephone`) -- le `telephone` doit être unique
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- ------------ --
-- Table client --
-- ------------ --
CREATE TABLE `client` (
    `id`          SMALLINT    UNSIGNED NOT NULL,
    `telephone`   CHAR(10),
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_client_id` FOREIGN KEY (`id`) REFERENCES `utilisateur` (`id`) ON DELETE CASCADE, -- le `client` est lié a l' `utilisateur` (héritage)
    CONSTRAINT UNIQUE INDEX `ind_uni_telephone` (`telephone`) -- le `telephone` doit être unique
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- --------------- --
-- Table client_cb --
-- --------------- --
CREATE TABLE `client_cb` (
    `id`          SMALLINT    UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_client`   SMALLINT    UNSIGNED NOT NULL,
    `numero`      BIGINT      NOT NULL,
    `nom`         VARCHAR(30) NOT NULL,
    `date`        DATE        NOT NULL,
    `crypto`      CHAR(3)     NOT NULL,
    `defaut`      TINYINT     NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_client_cb_id_client` FOREIGN KEY (`id_client`) REFERENCES `client` (`id`) ON DELETE CASCADE, -- la `client_cb` est liée au `client`
    CONSTRAINT UNIQUE INDEX `ind_uni_numero` (`numero`) -- le `numero` de cb doit être unique
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- ----------------------- --
-- Table adresse_livraison --
-- ----------------------- --
CREATE TABLE `adresse_livraison` (
    `id`          SMALLINT        UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_client`   SMALLINT        UNSIGNED,
    `adresse`     VARCHAR(100)    NOT NULL,
    `code_postal` CHAR(5)         NOT NULL,
    `ville`       VARCHAR(30)     NOT NULL,
    `info`        TINYTEXT,
    `defaut`      TINYINT         NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_adresse_livraison_id_client` FOREIGN KEY (`id_client`) REFERENCES `client` (`id`) ON DELETE SET NULL -- si un client est supprimé, on conserve l'adresse pour les commandes mais on supprime la liaison au client
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- ---------------------------- --
-- Table commande_paiement_type --
-- ---------------------------- --
CREATE TABLE `commande_paiement_type` (
    `id`      TINYINT     UNSIGNED NOT NULL AUTO_INCREMENT,
    `label`   VARCHAR(7)  NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- --------------------- --
-- Table commande_statut --
-- --------------------- --
CREATE TABLE `commande_statut` (
    `id`      TINYINT         UNSIGNED NOT NULL AUTO_INCREMENT,
    `label`   VARCHAR(25)     NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- -------------- --
-- Table commande --
-- -------------- --
CREATE TABLE `commande` (
    `numero`          MEDIUMINT   UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_statut`       TINYINT     UNSIGNED NOT NULL,
    `id_client`       SMALLINT    UNSIGNED,
    `id_adresse`      SMALLINT    UNSIGNED,
    `id_livreur`      SMALLINT    UNSIGNED,
    `type_paiement`   TINYINT     UNSIGNED,
    `temps_livraison` TINYINT     UNSIGNED,
    PRIMARY KEY (`numero`),
    CONSTRAINT `fk_commande_id_statut`      FOREIGN KEY (`id_statut`)       REFERENCES `commande_statut` (`id`),                            -- suppression/modification interdite si utilisé par une commande
    CONSTRAINT `fk_commande_id_client`      FOREIGN KEY (`id_client`)       REFERENCES `client` (`id`)                  ON DELETE SET NULL, -- en cas de suppression du client on conserve la commande mais on supprime la liaison au client
    CONSTRAINT `fk_commande_id_adresse`     FOREIGN KEY (`id_adresse`)      REFERENCES `adresse_livraison` (`id`)       ON DELETE SET NULL, -- en cas de suppression de l'adresse on conserve la commande mais on supprime la liaison
    CONSTRAINT `fk_commande_id_livreur`     FOREIGN KEY (`id_livreur`)      REFERENCES `livreur` (`id`)                 ON DELETE SET NULL, -- en cas de suppression du livreur on conserve la commande mais on supprime la liaison
    CONSTRAINT `fk_commande_type_paiement`  FOREIGN KEY (`type_paiement`)   REFERENCES `commande_paiement_type` (`id`)                      -- suppression/modification interdite si utilisée par une commande
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- --------------- --
-- Table plat_type --
-- --------------- --
CREATE TABLE `plat_type` (
    `id`      TINYINT     UNSIGNED NOT NULL AUTO_INCREMENT,
    `label`   VARCHAR(7)  NOT NULL,
    PRIMARY KEY (`id`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- ---------- --
-- Table plat --
-- ---------- --
CREATE TABLE `plat` (
    `id`                  TINYINT         UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_type`             TINYINT         UNSIGNED NOT NULL,
    `nom`                 VARCHAR(50)     NOT NULL,
    `description`         TINYTEXT        NOT NULL,
    `image`               VARCHAR(30),
    `dernier_prix_vente`  DECIMAL(4,2),
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_plat_id_type` FOREIGN KEY (`id_type`) REFERENCES `plat_type` (`id`), -- suppression/modification interdite si utilisé par un plat.
    CONSTRAINT UNIQUE INDEX `ind_uni_nom` (`nom`)
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- --------------- --
-- Table plat_jour --
-- --------------- --
CREATE TABLE `plat_jour` (
    `id`          SMALLINT        UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_plat`     TINYINT         UNSIGNED,
    `date`        DATE            NOT NULL,
    `prix`        DECIMAL(4,2)    NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_plat_jour_id_plat` FOREIGN KEY (`id_plat`) REFERENCES `plat` (`id`) ON DELETE SET NULL, -- en cas de suppression du plat on conserve le plat du jour (pour l'historique et les commandes) mais on supprime la liaison
    CONSTRAINT UNIQUE INDEX `ind_uni_id_plat_date` (`id_plat`, `date`) -- un plat ne peut pas être référencé 2 fois à la même date par un plat du jour
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- ------------------- --
-- Table commande_plat --
-- ------------------- --
CREATE TABLE `commande_plat_jour` (
    `num_commande`    MEDIUMINT   UNSIGNED NOT NULL,
    `id_plat_jour`    SMALLINT    UNSIGNED NOT NULL,
    `quantite`        TINYINT     UNSIGNED NOT NULL,
    PRIMARY KEY (`num_commande`, `id_plat_jour`),
    CONSTRAINT `fk_commande_plat_jour_num_commande` FOREIGN KEY (`num_commande`) REFERENCES `commande` (`numero`) ON DELETE CASCADE, -- en cas de suppression d'une commande, on supprime les plats de la commande
    CONSTRAINT `fk_commande_plat_jour_id_plat_jour` FOREIGN KEY (`id_plat_jour`) REFERENCES `plat_jour` (`id`)                       -- un plat du jour ne peut être modifié ou supprimé si il est référencé dans une commande
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;


-- ----------------------- --
-- Table livreur_plat_jour --
-- ----------------------- --

CREATE TABLE `livreur_plat_jour` (
    `id_livreur`    SMALLINT    UNSIGNED NOT NULL,
    `id_plat_jour`  SMALLINT    UNSIGNED NOT NULL,
    `quantite`      TINYINT     UNSIGNED NOT NULL,
    PRIMARY KEY (`id_livreur`, `id_plat_jour`),
    CONSTRAINT `fk_livreur_plat_jour_id_livreur`    FOREIGN KEY (`id_livreur`) REFERENCES livreur (`id`)        ON DELETE CASCADE, -- en cas de suppression d'un livreur, on supprime son stock
    CONSTRAINT `fk_livreur_plat_jour_id_plat_jour`  FOREIGN KEY (`id_plat_jour`) REFERENCES plat_jour (`id`)    -- si un livreur possède des plats du jour, impossible de modifier ou de supprimer le plat du jour
)
    ENGINE=INNODB
    DEFAULT CHARSET=utf8mb4;



-- ------------------------------------------------ --
-- ------------------ Données --------------------- --
-- ------------------------------------------------ --


-- -------- --
-- civilite --
-- -------- --
INSERT INTO `civilite`
    (`abrege`, `complet`)
VALUES
    ('MME', 'MADAME'),
    ('MR', 'MONSIEUR');


-- ---------------- --
-- utilisateur_role --
-- ---------------- --
INSERT INTO `utilisateur_role`
    (`role`)
VALUES
    ('ADMIN'),
    ('CLIENT'),
    ('LIVREUR');


-- -------------- --
-- livreur_statut --
-- -------------- --
INSERT INTO `livreur_statut`
    (`label`)
VALUES
    ('LIBRE'),
    ('EN COURS DE LIVRAISON'),
    ('INDISPONIBLE');


-- ---------------------- --
-- commande_paiement_type --
-- ---------------------- --
INSERT INTO `commande_paiement_type`
    (`label`)
VALUES
    ('CB'),
    ('CHEQUE'),
    ('ESPECES');


-- --------------- --
-- commande_statut --
-- --------------- --
INSERT INTO `commande_statut`
    (`label`)
VALUES
    ('EN CREATION'),
    ('EN ATTENTE INFOS PAIEMENT'),
    ('EN ATTENTE DE LIVRAISON'),
    ('EN COURS DE LIVRAISON'),
    ('LIVREE'),
    ('ANNULEE');


-- --------- --
-- plat_type --
-- --------- --
INSERT INTO `plat_type`
    (`label`)
VALUES
    ('PLAT'),
    ('DESSERT');


-- ----------- --
-- utilisateur --
-- ----------- --
INSERT INTO `utilisateur`
    (`email`, `mot_de_passe`, `id_role`, `id_civilite`, `nom`, `prenom`)
VALUES
    ('admin@express-food.fr', MD5('Admin$std'), 1, 2, 'Dune', 'Frédéric'),
    ('john.crud@express-food.fr', MD5('jCrud5624'), 3, 2, 'Crud', 'John'),
    ('isabelle.genet@express-food.fr', MD5('isaG5630$stw'), 3, 1, 'Genet', 'Isabelle'),
    ('julien.sayard@express-food.fr', MD5('jSayard-2045'), 3, 2, 'Sayard', 'Julien'),
    ('alan.taff243@gmail.com', MD5('alanDTSrr$'), 2, 2, 'Taff', 'Alan'),
    ('jean.gayard@free.fr', MD5('gj$55mqgstz'), 2, 2, 'Gayard', 'Jean'),
    ('juliette.remi254@gmail.com', MD5('julRem2005'), 2, 1, 'Remi', 'Juliette'),
    ('fred.sanpan@outlook.com', MD5('fSanpan25554$'), 2, 2, 'Sanpan', 'Frederic'),
    ('lisa.prost@free.fr', MD5('lisa2545'), 2, 1, 'Prost', 'Lisa');


-- ------- --
-- livreur --
-- ------- --
INSERT INTO `livreur`
    (`id`, `id_statut`, `latitude`, `longitude`, `telephone`)
VALUES
    (2, 1, 48.8629708,2.2740593, '0734342314'),
    (3, 2, 48.8506796,2.2985789, '0657442113'),
    (4, 3, NULL, NULL, '0624243112');


-- ------ --
-- client --
-- ------ --
INSERT INTO `client`
    (`id`, `telephone`)
VALUES
    (5, '0734524444'),
    (6, '0781224336'),
    (7, '0674553223'),
    (8, '0721343423'),
    (9, '0675312244');


-- --------- --
-- client_cb --
-- --------- --
INSERT INTO `client_cb`
    (`id_client`, `numero`, `nom`, `date`, `crypto`, `defaut`)
VALUES
    (7, 5421445536522534, 'REMI JULIETTE', '2022-11-04', '342', TRUE),
    (7, 5432556377289385, 'REMI JULIETTE', '2021-10-08', '241', FALSE),
    (8, 4567542341526354, 'F. SANPAN', '2021-10-24', '117', TRUE);


-- ----------------- --
-- adresse_livraison --
-- ----------------- --
INSERT INTO `adresse_livraison`
    (`id_client`, `adresse`, `code_postal`, `ville`, `info`, `defaut`)
VALUES
    (NULL, '8 Rue Mignard', '75116', 'Paris', '3eme étage', TRUE),
    (6, '26 Rue de l''Assomption', '75016', 'Paris', 'Au fond de la cour, porte jaune sur la droite, Sonner fort!.', TRUE),
    (7, '15 Rue des Quatre-Vents', '75006', 'Paris', '7eme étage', TRUE),
    (7, '30 Rue Chapon', '75003', 'Paris', 'A l''accueil, Demander la societe ATC Caractères', FALSE),
    (8, '5 Avenue du Coq', '75009', 'Paris', '5eme étage', TRUE),
    (9, '8 Rue Jarry', '75010', 'Paris', 'Porte noire 2eme étage', TRUE),
    (9, '31 Rue Fessart', '75019', 'Paris', 'Société RTC Connect', FALSE);


-- ---- --
-- plat --
-- ---- --
INSERT INTO `plat`
    (`id_type`, `nom`, `description`, `image`, `dernier_prix_vente`)
VALUES
    (1, 'Filet mignon', 'hiuhqd qsudhf iqsudhf qsidufhqisudfhqsiduf  qsdifuhqs dfuhq sdfhqsdfhqs.', '/plat/plat_1.jpeg', NULL),
    (1, 'Salade lyonnaise', 'hiuhqd qsudhf iqsudhf  qsdf fhqi sudfhqsiduf.  qsdifuhqs dfuhq sdfhqsdfhqs.', '/plat/plat_2.jpeg', 23.50),
    (1, 'Confit de cannard', ' qsudhf  qsidufhqisudfhqsiduf  qsdifuhqs dfuhq sdfhqsdfhqs.', '/plat/plat_3.jpeg', 32),
    (1, 'Filet de cabillaud', 'hiuhqd qsqsdfqsdfudhf iqsudhf qsidufhqiduf dsf fdfd   dfuhq sdfhqsdfhqs.', '/plat/plat_4.jpeg', 27.50),
    (1, 'Boeuf bourguignon', 'hiuhqd qsudhf iqsudhf qsidufhqisudfhqsiduf  qsdifuhqs dfuhq sdfhqsdfhqs.', '/plat/plat_5.jpeg', 23.50),
    (2, 'Fondant au chocolat', 'hiuhqd qsudhf iqsudhf qsidufhqisudfhqsiduf  qsdifuhqs dfuhq sdfhqsdfhqs.', '/dessert/dessert_6.jpeg', 14.50),
    (2, 'Crumble de mangues', 'hiuhqd qsudhf iqsudhf qsidu  fhqisudfhqsiduf  qsdifuhqs dfuhq  qdfqd dhh dhf qosdfihqhdf.', '/dessert/dessert_7.jpeg', NULL),
    (2, 'Crème brulée', 'hiuhqd  iqsudhf qsidufhqisudfhqsiduf  qsdifuhqs dfuh dd dddq sdfhqsdfhqs.', '/dessert/dessert_8.jpeg', 11),
    (2, 'Salade de fruits', 'hi uhqd qsucccdhf iqsudhf qsidufhqisudfhqsiduf  qsdifuhqs dfuhq sdfhqsdfhqs.', '/dessert/dessert_9.jpeg', 11),
    (2, 'Île flottante', 'hiuhqd qsudhf iqsudhf qsidufhqisudfhq siduf  qsdifuhqs dfuhq sdfhqsdfhqs.', '/dessert/dessert_10.jpeg', 12),
    (2, 'Paris Brest', 'hiuhqd qsudhf iqsqsdc udhf qsidufhqisudfhqsiduf  qsdifuhqs df  fgddfguhq .', '/dessert/dessert_11.jpeg', 14),
    (1, 'Velouté de cêpes', 'hi qdfqsdfqsdf deuhqd qsudhf iqsudhf qsidufhqisudfhqsiduf  qsdifuhqs dfuhq sdfhqsdfhqs.', '/plat/plat_12.jpeg', 28.50);


-- --------- --
-- plat_jour --
-- --------- --
INSERT INTO `plat_jour`
    (`id_plat`, `date`, `prix`)
VALUES
    (2, '2019-10-02', 22.50), (3, '2019-10-02', 31), (9, '2019-10-02', 10), (11, '2019-10-02', 13),
    (2, '2020-10-21', 23.50), (4, '2020-10-21', 27.00), (6, '2020-10-21', 14.50), (10, '2020-10-21', 12),
    (3, '2020-10-22', 32), (5, '2020-10-22', 23.00), (8, '2020-10-22', 11), (11, '2020-10-22', 14),
    (4, '2020-10-23', 27.50), (2, '2020-10-23', 23.50), (8, '2020-10-23', 11), (9, '2020-10-23', 11);


-- -------- --
-- commande --
-- -------- --
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


-- ----------------- --
-- livreur_plat_jour --
-- ----------------- --
INSERT INTO `livreur_plat_jour`
    (`id_livreur`, `id_plat_jour`, `quantite`)
VALUES
    (2, 13, 11), (2, 14, 5), (2, 15, 8), (2, 16, 10),
    (3, 13, 6), (3, 14, 5), (3, 15, 10), (3, 16, 6),
    (4, 13, 9), (4, 14, 13), (4, 15, 12), (4, 16, 11);


-- ------------------ --
-- commande_plat_jour --
-- ------------------ --
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



-- --------------------------------------------------------- --
-- ------------------ PROCEDURES STOCKEES ------------------ --
-- --------------------------------------------------------- --

DELIMITER |

-- ----------------- --
-- LISTE DES LIVREURS --
-- ----------------- --

CREATE PROCEDURE liste_livreurs()

BEGIN
    SELECT
           utilisateur.id,
           civilite.abrege AS civilite,
           utilisateur.nom,
           utilisateur.prenom,
           utilisateur_role.role,
           ls.label AS statut,
           utilisateur.email,
           utilisateur.mot_de_passe,
           livreur.telephone,
           CONCAT_WS('/',livreur.latitude, livreur.longitude) AS position_lat_long,
           (
                SELECT SUM(livreur_plat_jour.quantite)
                FROM livreur_plat_jour
                WHERE livreur_plat_jour.id_livreur = utilisateur.id
           ) AS stock_total_plats
    FROM
         livreur

    INNER JOIN
         utilisateur ON livreur.id = utilisateur.id
    INNER JOIN
         utilisateur_role ON utilisateur.id_role = utilisateur_role.id
    INNER JOIN
         civilite ON utilisateur.id_civilite = civilite.id
    INNER JOIN
         livreur_statut ls ON livreur.id_statut = ls.id

    GROUP BY
        utilisateur.id

    ORDER BY
         utilisateur.nom, utilisateur.prenom;
END |


-- ----------------- --
-- LISTE DES CLIENTS --
-- ----------------- --

CREATE PROCEDURE liste_clients()

BEGIN
    SELECT
           utilisateur.id,
           utilisateur.nom,
           utilisateur.prenom,
           utilisateur_role.role,
           civilite.complet AS civilite,
           utilisateur.email,
           utilisateur.mot_de_passe,
           client.telephone,
           (
                SELECT COUNT(commande.numero)
                FROM commande
                WHERE commande.id_client = utilisateur.id
            ) as nb_commandes,
           (
                SELECT SUM(commande_plat_jour.quantite * plat_jour.prix)
                FROM commande
                INNER JOIN commande_plat_jour ON commande.numero = commande_plat_jour.num_commande
                INNER JOIN plat_jour ON commande_plat_jour.id_plat_jour = plat_jour.id
                WHERE commande.id_client = utilisateur.id
           ) as CA
    FROM
         client

    INNER JOIN
         utilisateur ON client.id = utilisateur.id
    INNER JOIN
         utilisateur_role ON utilisateur.id_role = utilisateur_role.id
    INNER JOIN
         civilite on utilisateur.id_civilite = civilite.id

    GROUP BY
         utilisateur.id

    ORDER BY
         utilisateur.nom, utilisateur.prenom;
END |


-- ---------------------------- --
-- ADRESSES DE LIVRAISON CLIENT --
-- ---------------------------- --

CREATE PROCEDURE adresses_livraison()

BEGIN
    SELECT
           client.id,
           utilisateur.nom,
           utilisateur.prenom,
           adresse_livraison.adresse,
           adresse_livraison.code_postal,
           adresse_livraison.ville,
           adresse_livraison.info,
           adresse_livraison.defaut
    FROM
         client

    INNER JOIN
         utilisateur ON client.id = utilisateur.id
    INNER JOIN
         adresse_livraison ON client.id = adresse_livraison.id_client

    ORDER BY
         utilisateur.nom, utilisateur.prenom;
END |


-- --------------------- --
-- STATISTIQUES DE VENTE --
-- --------------------- --

CREATE PROCEDURE stats_vente()
BEGIN
    SELECT
        MIN(pj.date) AS date,
        COUNT(DISTINCT cpj.num_commande) AS nombre_commandes,
        SUM(pj.prix * cpj.quantite) AS chiffre_affaire,
        ROUND(AVG(c.temps_livraison)) AS temps_livraison_moyen
    FROM
         commande_plat_jour cpj

    INNER JOIN
         plat_jour pj ON cpj.id_plat_jour = pj.id
    INNER JOIN
         commande c ON cpj.num_commande = c.numero

    GROUP BY
        pj.date

    ORDER BY
        pj.date ASC;
END |


-- ----------------------------- --
-- HISTIRIQUE DES PRIX D'UN PLAT --
-- ----------------------------- --

CREATE PROCEDURE historique_prix()
BEGIN
    SELECT
        p.nom,
        DATE_FORMAT(MIN(plat_jour.date), '%M %Y') AS date,
        CONCAT(plat_jour.prix, ' €') AS prix

    FROM
        plat_jour

    INNER JOIN
        plat p ON plat_jour.id_plat = p.id

    GROUP BY
        p.nom, plat_jour.prix;
END |


-- -------------------- --
-- RESUME DES COMMANDES --
-- -------------------- --

CREATE PROCEDURE resume_commandes()

BEGIN
    SELECT
           commande.numero AS num,
           cs.label as statut,
           CONCAT_WS(' ', civilite.abrege, u.nom) AS client,
           SUM(cpj.quantite * pj.prix) AS total,
           GROUP_CONCAT(
               p.nom, '(',
               pj.prix, '€, qte: ',
               cpj.quantite, ')'
               SEPARATOR ', '
           ) AS details

    FROM
         commande

    INNER JOIN
         commande_statut cs ON commande.id_statut = cs.id
    INNER JOIN
         client c ON commande.id_client = c.id
    INNER JOIN
         utilisateur u ON c.id = u.id
    INNER JOIN
         civilite ON u.id_civilite = civilite.id
    LEFT JOIN
         adresse_livraison al ON commande.id_adresse = al.id
    INNER JOIN
         commande_plat_jour cpj ON commande.numero = cpj.num_commande
    INNER JOIN
         plat_jour pj ON cpj.id_plat_jour = pj.id
    INNER JOIN
         plat p ON pj.id_plat = p.id

    GROUP BY
         commande.numero;
END |


-- ---------------------- --
-- DETAILS D'UNE COMMANDE --
-- ---------------------- --

CREATE PROCEDURE detail_commande(IN p_id INT)

BEGIN
    SELECT
           commande.numero,
           DATE_FORMAT(MIN(pj.date), '%d/%m/%Y') AS date,
           cs.label AS statut,
           CONCAT_WS(' ', u.prenom, u.nom) AS client,
           CONCAT_WS(', ', al.adresse, al.code_postal, al.ville) AS adresse,
           cpt.label AS paiement,
           SUM(cpj.quantite * pj.prix) as total,
           GROUP_CONCAT(
               p.nom, ' (',
               cpj.quantite, ')'
               SEPARATOR ', '
           ) AS details,
           liv.prenom AS livreur,
           CONCAT(commande.temps_livraison, ' mn') AS tmp_livraison

    FROM
         commande

    INNER JOIN
         commande_statut cs ON commande.id_statut = cs.id
    INNER JOIN
         client c ON commande.id_client = c.id
    INNER JOIN
         utilisateur u ON c.id = u.id
    LEFT JOIN
         adresse_livraison al ON commande.id_adresse = al.id
    INNER JOIN
         commande_plat_jour cpj ON commande.numero = cpj.num_commande
    INNER JOIN
         plat_jour pj ON cpj.id_plat_jour = pj.id
    INNER JOIN
         plat p ON pj.id_plat = p.id
    LEFT JOIN
         commande_paiement_type cpt ON commande.type_paiement = cpt.id
    LEFT JOIN
         utilisateur liv ON liv.id = commande.id_livreur

    WHERE commande.numero = p_id;
END |


-- -------------- --
-- livreurs_dispo --
-- -------------- --

CREATE PROCEDURE livreurs_stock()

BEGIN
    SELECT
        utilisateur.id,
        CONCAT_WS(' ', utilisateur.nom, utilisateur.prenom) AS nom_livreur,
        MIN(DATE_FORMAT(plat_jour.date, '%d %M %Y')) AS stock_date,
        GROUP_CONCAT(
            plat.nom, ' (',
            livreur_plat_jour.quantite, ')'
            SEPARATOR ', '
        ) AS stock

    FROM
        utilisateur

    INNER JOIN
        livreur_plat_jour ON utilisateur.id = livreur_plat_jour.id_livreur
    INNER JOIN
        plat_jour ON livreur_plat_jour.id_plat_jour = plat_jour.id
    INNER JOIN
        plat ON plat_jour.id_plat = plat.id


    GROUP BY
        utilisateur.id;
END |


DELIMITER ;


