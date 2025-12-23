 USE universite;
 SELECT 
    e.nom AS nom_etudiant, 
    c.titre AS titre_cours, 
    ex.date_examen, 
    ex.score
FROM EXAMEN ex
JOIN INSCRIPTION i ON ex.inscription_id = i.id
JOIN ETUDIANT e ON i.etudiant_id = e.id
JOIN ENSEIGNEMENT ens ON i.enseignement_id_cours = ens.cours_id 
    AND i.enseignement_id_prof = ens.professeur_id 
    AND i.enseignement_semestre = ens.semestre
JOIN COURS c ON ens.cours_id = c.id;

SELECT 
    e.nom, 
    COUNT(ex.id) AS total_examens
FROM ETUDIANT e
LEFT JOIN INSCRIPTION i ON e.id = i.etudiant_id
LEFT JOIN EXAMEN ex ON i.id = ex.inscription_id
GROUP BY e.id, e.nom;

SELECT 
    c.titre, 
    COUNT(DISTINCT i.etudiant_id) AS nb_etudiants_inscrits
FROM INSCRIPTION i
RIGHT JOIN COURS c ON i.enseignement_id_cours = c.id
GROUP BY c.id, c.titre;

SELECT 
    e.nom AS etudiant, 
    p.nom AS professeur
FROM ETUDIANT e
CROSS JOIN PROFESSEUR p
LIMIT 20;

CREATE VIEW vue_performances AS
SELECT 
    e.id AS etudiant_id, 
    e.nom, 
    COALESCE(AVG(ex.score), 0) AS moyenne_score
FROM ETUDIANT e
LEFT JOIN INSCRIPTION i ON e.id = i.etudiant_id
LEFT JOIN EXAMEN ex ON i.id = ex.inscription_id
GROUP BY e.id, e.nom;

WITH top_cours AS (
    SELECT 
        c.id AS cours_id,
        c.titre,
        c.credits,
        AVG(ex.score) AS moyenne_score
    FROM COURS c
    JOIN ENSEIGNEMENT ens ON c.id = ens.cours_id
    JOIN INSCRIPTION i ON ens.cours_id = i.enseignement_id_cours 
        AND ens.professeur_id = i.enseignement_id_prof 
        AND ens.semestre = i.enseignement_semestre
    JOIN EXAMEN ex ON i.id = ex.inscription_id
    GROUP BY c.id, c.titre, c.credits
    ORDER BY moyenne_score DESC
    LIMIT 3
)
SELECT titre, credits, moyenne_score
FROM top_cours;