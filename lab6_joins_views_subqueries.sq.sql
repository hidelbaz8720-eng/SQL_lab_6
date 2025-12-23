USE bibliotheque;
SELECT e.id, a.nom, e.date_debut
FROM emprunt e
INNER JOIN abonne a 
  ON e.id_abonne = a.id;
 
 SELECT o.titre, MAX(e.date_debut) AS dernier_emprunt
FROM ouvrage o
LEFT JOIN emprunt e 
  ON e.id_ouvrage = o.id
GROUP BY o.id, o.titre;

SELECT a.nom AS abonne, au.nom AS auteur
FROM abonne a
CROSS JOIN auteur au;

SELECT a.id, a.nom, COUNT(e.id) AS total_emprunts
FROM abonne a
LEFT JOIN emprunt e 
  ON e.id_abonne = a.id
GROUP BY a.id, a.nom;

SELECT * 
FROM vue_emprunts_par_abonne
WHERE total_emprunts > 5;

DROP VIEW vue_emprunts_par_abonne;

SELECT 
  titre,
  (SELECT COUNT(*) 
   FROM emprunt e 
   WHERE e.id_ouvrage = o.id
  ) AS nb_emprunts
FROM ouvrage o;

SELECT nom, email
FROM abonne
WHERE id IN (
  SELECT id_abonne
  FROM emprunt
  GROUP BY id_abonne
  HAVING COUNT(*) > 3
);

SELECT a.nom,
  (SELECT o.titre 
   FROM emprunt e2 
   JOIN ouvrage o ON e2.id_ouvrage = o.id
   WHERE e2.id_abonne = a.id
   ORDER BY e2.date_debut
   LIMIT 1
  ) AS premier_titre
FROM abonne a;

CREATE VIEW vue_emprunts_mensuels AS
SELECT 
  YEAR(date_debut) AS annee,
  MONTH(date_debut) AS mois,
  COUNT(*) AS total_emprunts
FROM emprunt
GROUP BY annee, mois;
SELECT v.annee, v.mois, v.total_emprunts
FROM vue_emprunts_mensuels v
WHERE v.total_emprunts = (
  SELECT MAX(total_emprunts)
  FROM vue_emprunts_mensuels
  WHERE annee = v.annee
);