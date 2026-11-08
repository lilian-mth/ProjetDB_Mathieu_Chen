


ALTER TABLE Joueurs
ADD CONSTRAINT chk_email_format CHECK (email_joueur LIKE '%@%'),
ADD CONSTRAINT chk_elo_positif CHECK (
    (elo_blitz IS NULL OR elo_blitz >= 0) AND 
    (elo_rapide IS NULL OR elo_rapide >= 0) AND 
    (elo_bullet IS NULL OR elo_bullet >= 0)
);

ALTER TABLE Cadence
ADD CONSTRAINT chk_temps_positif CHECK (temps_initial_sec >= 0 AND increment_sec >= 0);

ALTER TABLE Parties
ADD CONSTRAINT chk_dates_partie CHECK (date_heure_fin IS NULL OR date_heure_debut <= date_heure_fin),
ADD CONSTRAINT chk_resultat_format CHECK (resultat_partie IN ('1-0', '0-1', '1/2-1/2', '*'));

ALTER TABLE joue_partie
ADD CONSTRAINT chk_couleur_joueur CHECK (couleur_joueur IN ('Blanc', 'Noir'));


ALTER TABLE Tournoi
ADD CONSTRAINT chk_dates_tournoi CHECK (date_de_fin IS NULL OR date_de_debut <= date_de_fin);