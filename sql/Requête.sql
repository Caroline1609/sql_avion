/* 1 Quels sont les vols au départ de Paris entre 12h et 14h ? */

SELECT *
FROM vol
WHERE HeureDepart BETWEEN 12 AND 14;


/* 2 Quels sont les pilotes dont le nom commence par "S" ? */

SELECT *
FROM pilote
WHERE Nom LIKE 'S%';


/* 3 Pour chaque ville, donner le nombre et les capacités minimum et maximum des avions qui s'y trouvent. */

SELECT 
    Localisation AS Ville,
    COUNT(*) AS NbAvions,
    MIN(Capacite) AS Cap_Min,
    MAX(Capacite) AS Cap_Max
FROM avion
GROUP BY Localisation;

/* 4 Pour chaque ville, donner la capacité moyenne des avions qui s'y trouvent et cela par type d'avion. */

SELECT 
    Localisation AS Ville,
    Marque,
    AVG(Capacite) AS Capacite_moyenne
FROM avion
GROUP BY Localisation, Marque
ORDER BY Localisation, Marque;



/* 5 Quelle est la capacité moyenne des avions pour chaque ville ayant plus de 1 avion ? */

SELECT
    Localisation AS Ville,
    COUNT(*) AS NbAvions,
    AVG(Capacite) AS Capacite_moyenne
FROM AVION
GROUP BY Localisation
HAVING COUNT(*) > 1;

/* 6 Quels sont les noms des pilotes qui habitent dans la ville de localisation d'un Airbus ? */

SELECT
		DISTINCT Nom,
		pilote.Adresse,
		Marque
FROM PILOTE
JOIN AVION ON pilote.Adresse = avion.Localisation
WHERE avion.Marque = 'AIRBUS';


/* 7 Quels sont les noms des pilotes qui conduisent un Airbus et qui habitent dans la ville de localisation d'un Airbus ? */

SELECT DISTINCT
		pilote.Nom,
		pilote.Adresse
FROM pilote

WHERE pilote.Adresse IN ( /* Le pilote habite dans une ville où un Airbus est localisé*/
    SELECT Localisation
    FROM AVION
    WHERE Marque = 'AIRBUS'
)
AND pilote.PIL_ID IN ( /*Liste des pilotes qui conduisent un Airbus*/
    SELECT vol.Pilote_ID
    FROM VOL
    JOIN AVION ON vol.Avion_ID = avion.AV_ID
    WHERE avion.Marque = 'AIRBUS'
);


/* 8 Quels sont les noms des pilotes qui conduisent un Airbus ou qui habitent dans la ville de localisation d'un Airbus ? */

SELECT DISTINCT
    pilote.Nom,
    pilote.Adresse
    
FROM pilote
WHERE pilote.Adresse IN (	-- Le pilote habite dans une ville où un Airbus est localisé

		SELECT Localisation
		FROM AVION
		WHERE Marque = 'AIRBUS'
)
OR pilote.PIL_ID IN ( -- Ou le pilote conduit un Airbus
     SELECT vol.Pilote_ID
     FROM vol
     JOIN avion ON vol.Avion_ID = avion.AV_ID
     WHERE avion.Marque = 'AIRBUS'
);


/* 9 Quels sont les noms des pilotes qui conduisent un Airbus sauf ceux qui habitent dans la ville de localisation d'un Airbus ? */

SELECT DISTINCT
    pilote.Nom,
    pilote.Adresse
    
FROM pilote
WHERE	pilote.PIL_ID IN ( -- Le pilote conduit un Airbus

     SELECT vol.Pilote_ID
     FROM vol
     JOIN avion ON vol.Avion_ID = avion.AV_ID
     WHERE avion.Marque = 'AIRBUS'
)
AND pilote.Adresse NOT IN (	-- et dont le pilote n'habite pas dans une ville où un Airbus est localisé

		SELECT Localisation
		FROM avion
		WHERE Marque = 'AIRBUS'
);

/* 10 Quels sont les vols ayant un trajet identique ( VD, VA ) à ceux assurés par Serge ? */

SELECT *
FROM vol
WHERE (VilleDepart, VilleArrivee) IN (
    SELECT VilleDepart, VilleArrivee
    FROM vol
    WHERE Pilote_ID = (
        SELECT PIL_ID
        FROM pilote
        WHERE Nom = 'SERGE'
    )
);


/* 11 Donner toutes les paires de pilotes habitant la même ville (sans doublon). */

SELECT DISTINCT
    p1.Nom AS Pilote1,
    p2.Nom AS Pilote2,
    p1.Adresse AS Ville
FROM pilote p1
JOIN pilote p2
		ON p1.Adresse = p2.Adresse
		AND p1.PIL_ID < p2.PIL_ID;

   


/* 12 Quels sont les noms des pilotes qui conduisent un avion que conduit aussi le pilote n°1 ? */

SELECT DISTINCT 
	    pilote.Nom,
	    pilote.Adresse
FROM pilote, vol
AND vol.Avion_ID IN (
WHERE pilote.PIL_ID = vol.Pilote_ID
	 
	 SELECT v1.Avion_ID
    FROM VOL v1
    WHERE v1.Pilote_ID = 1
	 
	 )
AND pilote.PIL_ID <> 1;




/* 13 Donner toutes les paires de villes telles qu'un avion localisé
dans la ville de départ soit conduit par un pilote résidant dans la ville d'arrivée. */

SELECT DISTINCT
    avion.Localisation AS "Ville de Depart",
    pilote.Adresse AS "Ville de Residence du Pilote",
    pilote.Nom
FROM avion
INNER JOIN vol ON avion.AV_ID = vol.Avion_ID
INNER JOIN pilote ON vol.Pilote_ID = pilote.PIL_ID
WHERE avion.Localisation = vol.VilleDepart
AND pilote.Adresse = vol.VilleArrivee;



/* 14 Sélectionner les numéros des pilotes qui conduisent tous les Airbus ? */


SELECT Pilote_ID
FROM vol, pilote
WHERE Avion_ID IN ( /*filtrer les avions qui sont un AIRBUS*/
    SELECT AV_ID
    FROM avion
    WHERE Marque = 'AIRBUS'
)
GROUP BY Pilote_ID
HAVING COUNT(DISTINCT Avion_ID) = (
    SELECT COUNT(DISTINCT AV_ID)
    FROM avion
    WHERE Marque = 'AIRBUS'
);

