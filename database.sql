--------------------------------
-------- Base de donnee --------
--------------------------------
CREATE DATABASE express_food CHARACTER SET 'utf8mb4';

--------------------------------
------------ Tables ------------
--------------------------------

-- Table civilite --
CREATE TABLE IF NOT EXISTS civilite (

)
ENGINE=INNODB;

-- Table utilisateur_role --
CREATE TABLE IF NOT EXISTS utilisateur_role (

)
ENGINE=INNODB;

-- Table utilisateur --
CREATE TABLE IF NOT EXISTS utilisateur (

)
ENGINE=INNODB;

-- Table admin --
CREATE TABLE IF NOT EXISTS administrateur (

)
ENGINE=INNODB;

-- Table livreur_statut --
CREATE TABLE IF NOT EXISTS livreur_statut (

)
ENGINE=INNODB;

-- Table livreur --
CREATE TABLE IF NOT EXISTS livreur (

)
ENGINE=INNODB;

-- Table client --
CREATE TABLE IF NOT EXISTS client (

)
ENGINE=INNODB;

-- Table client_cb --
CREATE TABLE IF NOT EXISTS client_cb (

)
ENGINE=INNODB;

-- Table adresse_livraison --
CREATE TABLE IF NOT EXISTS adresse_livraison (

)
ENGINE=INNODB;

-- Table commande --
CREATE TABLE IF NOT EXISTS commande (

)
ENGINE=INNODB;

-- Table commande_paiement_type --
CREATE TABLE IF NOT EXISTS commande_paiement_type (

)
ENGINE=INNODB;

-- Table commande_statut --
CREATE TABLE IF NOT EXISTS commande_statut (

)
ENGINE=INNODB;

-- Table plat_jour --
CREATE TABLE IF NOT EXISTS plat_jour (

)
ENGINE=INNODB;

-- Table Type --
CREATE TABLE IF NOT EXISTS plat_type (

)
ENGINE=INNODB;

-- Table plat --
CREATE TABLE IF NOT EXISTS plat (

)
ENGINE=INNODB;

-- Table commande_plat --
CREATE TABLE IF NOT EXISTS commande_plat (

)
ENGINE=INNODB;
