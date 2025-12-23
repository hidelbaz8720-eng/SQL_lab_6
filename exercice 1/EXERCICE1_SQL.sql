CREATE DATABASE universite
 CHARACTER SET utf8mb4 
 COLLATE utf8mb4_unicode_ci;
 USE universite;


CREATE TABLE ETUDIANT (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE PROFESSEUR (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    departement VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE COURS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(200) NOT NULL,
    code VARCHAR(20) UNIQUE NOT NULL,
    credits INT DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ENSEIGNEMENT (
    cours_id INT,
    professeur_id INT,
    semestre VARCHAR(20),
    PRIMARY KEY (cours_id, professeur_id, semestre),
    FOREIGN KEY (cours_id) REFERENCES COURS(id),
    FOREIGN KEY (professeur_id) REFERENCES PROFESSEUR(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE INSCRIPTION (
    id INT AUTO_INCREMENT PRIMARY KEY,
    etudiant_id INT,
    enseignement_id_cours INT,
    enseignement_id_prof INT,
    enseignement_semestre VARCHAR(20),
    date_inscription DATE NOT NULL,
    FOREIGN KEY (etudiant_id) REFERENCES ETUDIANT(id),
    FOREIGN KEY (enseignement_id_cours, enseignement_id_prof, enseignement_semestre) 
        REFERENCES ENSEIGNEMENT(cours_id, professeur_id, semestre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE EXAMEN (
    id INT AUTO_INCREMENT PRIMARY KEY,
    inscription_id INT,
    date_examen DATE NOT NULL,
    score DECIMAL(4,2),
    CONSTRAINT chk_score CHECK (score BETWEEN 0 AND 20),
    FOREIGN KEY (inscription_id) REFERENCES INSCRIPTION(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;