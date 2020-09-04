-- ----------------- --
-- LISTE DES CLIENTS --
-- ----------------- --

SELECT
       utilisateur.id,
       utilisateur.nom,
       utilisateur.prenom,
       utilisateur_role.role,
       civilite.complet as civilite,
       utilisateur.email,
       utilisateur.mot_de_passe,
       client.telephone
FROM
     client, utilisateur
INNER JOIN
     utilisateur_role ON utilisateur.id_role = utilisateur_role.id
INNER JOIN
     civilite on utilisateur.id_civilite = civilite.id
WHERE
     client.id = utilisateur.id
ORDER BY
     utilisateur.nom, utilisateur.prenom;
