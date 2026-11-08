




-- Lister les joueurs avec un ELO Blitz > 2600, triés par ELO Blitz décroissant (Projection + Sélection + Tri)
SELECT pseudo_joueur, elo_blitz, elo_rapide
FROM Joueurs
WHERE elo_blitz > 2600
ORDER BY elo_blitz DESC;

-- Trouver les joueurs inscrits au premier trimestre 2021 (BETWEEN)
SELECT pseudo_joueur, date_inscription_joueur
FROM Joueurs
WHERE date_inscription_joueur BETWEEN '2021-01-01' AND '2021-03-31';

--  Lister les parties qui se sont terminées par une victoire des Blancs ou un match nul (IN)
SELECT id_partie, date_heure_debut, resultat_partie
FROM Parties
WHERE resultat_partie IN ('1-0', '1/2-1/2');

-- Trouver les joueurs ayant une adresse email chez un fournisseur spécifique (LIKE)
SELECT pseudo_joueur, email_joueur
FROM Joueurs
WHERE email_joueur LIKE '%@email.com';

-- Lister les différents formats de cadence disponibles sans doublon (DISTINCT)
SELECT DISTINCT nom_cadence
FROM Cadence;

--  Nombre total de joueurs inscrits
SELECT COUNT(*) AS nombre_total_joueurs FROM Joueurs;

--  Nombre de parties jouées par cadence, avec un minimum de 5 parties (GROUP BY + HAVING)
SELECT Parties.id_cadence, cadence.nom_cadence, COUNT(*) AS nb_parties
FROM Parties
JOIN cadence ON Parties.id_cadence = cadence.id_cadence
GROUP BY id_cadence
HAVING COUNT(*) >= 5;

-- Score moyen des joueurs par tournoi, trié par score moyen décroissant (GROUP BY + Tri)
SELECT id_tournoi, ROUND(AVG(score), 2) AS score_moyen
FROM participe
GROUP BY id_tournoi
ORDER BY score_moyen DESC;

-- Nombre de coups moyen par partie (GROUP BY)
SELECT id_partie, COUNT(numéro_coup) AS nb_coups
FROM Coup
GROUP BY id_partie;

-- Les joueurs ayant envoyé plus de 2 demandes d'amis (GROUP BY + HAVING)
SELECT id_joueur_demande, COUNT(*) AS nb_demandes_envoyees
FROM demande_d_ami
GROUP BY id_joueur_demande
HAVING COUNT(*) > 2;

-- Afficher le nom des joueurs et leur score pour le tournoi 'Open de Paris' (Jointure interne simple)
SELECT j.pseudo_joueur, p.score
FROM Joueurs j
INNER JOIN participe p ON j.id_joueur = p.id_joueur
INNER JOIN Tournoi t ON p.id_tournoi = t.id_tournoi
WHERE t.nom_tournoi = 'Open de Paris';

-- Lister tous les joueurs, même ceux qui n'ont jamais envoyé de demande d'ami (Jointure externe gauche)
SELECT j.pseudo_joueur, d.date_de_demande
FROM Joueurs j
LEFT JOIN demande_d_ami d ON j.id_joueur = d.id_joueur_demande;

-- Afficher les parties avec le nom des joueurs Blancs et Noirs (Jointure multiple + auto-jointure)
SELECT p.id_partie, jb.pseudo_joueur AS joueur_blanc, jn.pseudo_joueur AS joueur_noir, p.resultat_partie
FROM Parties p
JOIN joue_partie jpb ON p.id_partie = jpb.id_partie AND jpb.couleur_joueur = 'Blanc'
JOIN Joueurs jb ON jpb.id_joueur = jb.id_joueur
JOIN joue_partie jpn ON p.id_partie = jpn.id_partie AND jpn.couleur_joueur = 'Noir'
JOIN Joueurs jn ON jpn.id_joueur = jn.id_joueur;

-- Compter le nombre de participants par tournoi, y compris les tournois vides (Jointure externe)
SELECT t.nom_tournoi, COUNT(p.id_joueur) AS nb_participants
FROM Tournoi t
LEFT JOIN participe p ON t.id_tournoi = p.id_tournoi
GROUP BY t.id_tournoi, t.nom_tournoi;

-- Afficher les demandes d'amis mutuelles (Auto-jointure)
SELECT j1.pseudo_joueur AS demandeur, j2.pseudo_joueur AS receveur
FROM demande_d_ami d1
JOIN demande_d_ami d2 ON d1.id_joueur_demande = d2.id_joueur_reçoit AND d1.id_joueur_reçoit = d2.id_joueur_demande
JOIN Joueurs j1 ON d1.id_joueur_demande = j1.id_joueur
JOIN Joueurs j2 ON d1.id_joueur_reçoit = j2.id_joueur;

-- affiche les joueurs (pseudo, Elo Blitz > 2600) et leurs tournois, triés par niveau décroissant.
SELECT j.pseudo_joueur, j.elo_blitz, t.nom_tournoi FROM Joueurs j 
JOIN participe p ON j.id_joueur = p.id_joueur 
JOIN Tournoi t ON p.id_tournoi = t.id_tournoi 
WHERE j.elo_blitz > 2600 ORDER BY j.elo_blitz DESC;

-- Trouver les joueurs dont l'ELO Blitz est supérieur à la moyenne (Sous-requête avec opérateur de comparaison)
SELECT pseudo_joueur, elo_blitz
FROM Joueurs
WHERE elo_blitz > (SELECT AVG(elo_blitz) FROM Joueurs);

-- Trouver les joueurs qui n'ont jamais participé à un tournoi (NOT EXISTS)
SELECT pseudo_joueur
FROM Joueurs j
WHERE NOT EXISTS (
SELECT 1 FROM participe p WHERE p.id_joueur = j.id_joueur
);

-- Trouver les parties qui n'ont pas été jouées avec la cadence 'Bullet 1+0' (NOT IN)
SELECT id_partie, date_heure_debut
FROM Parties
WHERE id_cadence NOT IN (
SELECT id_cadence FROM Cadence WHERE nom_cadence = 'Bullet 1+0'
);

--  Trouver les joueurs qui ont un ELO Blitz supérieur à au moins un joueur ayant participé au tournoi 1 (ANY)
SELECT pseudo_joueur, elo_blitz
FROM Joueurs
WHERE elo_blitz > ANY (
SELECT j.elo_blitz
FROM Joueurs j
JOIN participe p ON j.id_joueur = p.id_joueur
WHERE p.id_tournoi = 1
);

-- Trouver le joueur ayant le meilleur ELO Blitz parmi ceux qui ont joué une partie (ALL)
SELECT pseudo_joueur, elo_blitz
FROM Joueurs
WHERE elo_blitz >= ALL (
SELECT elo_blitz FROM Joueurs WHERE id_joueur IN (SELECT id_joueur FROM joue_partie)
);



