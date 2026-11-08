-- Fichier : 1_creation.sql

-- 1. Création des tables sans clés étrangères (tables indépendantes)

CREATE TABLE Joueurs (
    id_joueur VARCHAR(50) PRIMARY KEY,
    pseudo_joueur VARCHAR(50),
    email_joueur VARCHAR(255),
    mot_de_passe_hash VARCHAR(255),
    elo_blitz SMALLINT,
    elo_rapide SMALLINT,
    elo_bullet SMALLINT,
    date_inscription_joueur DATETIME
);

CREATE TABLE Tournoi (
    id_tournoi VARCHAR(50) PRIMARY KEY,
    nom_tournoi VARCHAR(100),
    date_de_debut VARCHAR(50),
    date_de_fin VARCHAR(50)
);

CREATE TABLE Cadence (
    id_cadence VARCHAR(50) PRIMARY KEY,
    nom_cadence VARCHAR(30),
    temps_initial_sec BIGINT,
    increment_sec SMALLINT
);

CREATE TABLE Statut (
    id_statut VARCHAR(50) PRIMARY KEY,
    libelle_statut VARCHAR(50)
);

-- 2. Création des tables avec clés étrangères (tables dépendantes)

CREATE TABLE Parties (
    id_partie VARCHAR(50) PRIMARY KEY,
    date_heure_debut DATETIME,
    date_heure_fin DATETIME,
    resultat_partie VARCHAR(10),
    pgn_complet TEXT,
    id_cadence VARCHAR(50),
    FOREIGN KEY (id_cadence) REFERENCES Cadence(id_cadence) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE Coup (
    id_partie VARCHAR(50),
    numéro_coup VARCHAR(50),
    notation_pgn_coup VARCHAR(50),
    temps_restant_sec VARCHAR(50),
    PRIMARY KEY (id_partie, numéro_coup),
    FOREIGN KEY (id_partie) REFERENCES Parties(id_partie) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE demande_d_ami (
    id_joueur_demande VARCHAR(50),
    id_joueur_reçoit VARCHAR(50),
    date_de_demande VARCHAR(50),
    PRIMARY KEY (id_joueur_demande, id_joueur_reçoit),
    FOREIGN KEY (id_joueur_demande) REFERENCES Joueurs(id_joueur) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (id_joueur_reçoit) REFERENCES Joueurs(id_joueur) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE joue_partie (
    id_joueur VARCHAR(50),
    id_partie VARCHAR(50),
    couleur_joueur VARCHAR(50),
    variation_elo REAL,
    PRIMARY KEY (id_joueur, id_partie),
    FOREIGN KEY (id_joueur) REFERENCES Joueurs(id_joueur) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (id_partie) REFERENCES Parties(id_partie) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE participe (
    id_joueur VARCHAR(50),
    id_tournoi VARCHAR(50),
    id_statut VARCHAR(50),
    score VARCHAR(50),
    PRIMARY KEY (id_joueur, id_tournoi),
    FOREIGN KEY (id_joueur) REFERENCES Joueurs(id_joueur) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (id_tournoi) REFERENCES Tournoi(id_tournoi) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (id_statut) REFERENCES Statut(id_statut) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);