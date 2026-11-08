-- Q1.1 : Lister les joueurs avec un ELO Blitz > 2600, triés par ELO Blitz décroissant (Projection + Sélection + Tri)
SELECT pseudo_joueur, elo_blitz, elo_rapide
FROM Joueurs
WHERE elo_blitz > 2600
ORDER BY elo_blitz DESC;
-- Q1.2 : Trouver les joueurs inscrits au premier trimestre 2021 (BETWEEN)
SELECT pseudo_joueur, date_inscription_joueur
FROM Joueurs
WHERE date_inscription_joueur BETWEEN '2021-01-01' AND '2021-03-31';
-- Q1.3 : Lister les parties qui se sont terminées par une victoire des Blancs ou un match nul (IN)
SELECT id_partie, date_heure_debut, resultat_partie
FROM Parties
WHERE resultat_partie IN ('1-0', '1/2-1/2');
-- Q1.4 : Trouver les joueurs ayant une adresse email chez un fournisseur spécifique (LIKE)
SELECT pseudo_joueur, email_joueur
FROM Joueurs
WHERE email_joueur LIKE '%@email.com';
-- Q1.5 : Lister les différents formats de cadence disponibles sans doublon (DISTINCT)
SELECT DISTINCT nom_cadence
FROM Cadence;
-- =====================================================================
-- 2. FONCTIONS D'AGRÉGATION, GROUP BY, HAVING
-- =====================================================================
-- Q2.1 : Nombre total de joueurs inscrits
SELECT COUNT(*) AS nombre_total_joueurs FROM Joueurs;
-- Q2.2 : Nombre de parties jouées par cadence, avec un minimum de 5 parties (GROUP BY + HAVING)
SELECT id_cadence, COUNT(*) AS nb_parties
FROM Parties
GROUP BY id_cadence
HAVING COUNT(*) >= 5;
-- Q2.3 : Score moyen des joueurs par tournoi, trié par score moyen décroissant (GROUP BY + Tri)
SELECT id_tournoi, ROUND(AVG(score), 2) AS score_moyen
FROM participe
GROUP BY id_tournoi
ORDER BY score_moyen DESC;
-- Q2.4 : Nombre de coups moyen par partie (GROUP BY)
SELECT id_partie, COUNT(numéro_coup) AS nb_coups
FROM Coup
GROUP BY id_partie;
-- Q2.5 : Les joueurs ayant envoyé plus de 2 demandes d'amis (GROUP BY + HAVING)
SELECT id_joueur_demande, COUNT(*) AS nb_demandes_envoyees
FROM demande_d_ami
GROUP BY id_joueur_demande
HAVING COUNT(*) > 2;
-- =====================================================================
-- 3. JOINTURES (INTERNES, EXTERNES, MULTIPLES)
-- =====================================================================
-- Q3.1 : Afficher le nom des joueurs et leur score pour le tournoi 'Open de Paris' (Jointure interne simple)
SELECT j.pseudo_joueur, p.score
FROM Joueurs j
INNER JOIN participe p ON j.id_joueur = p.id_joueur
INNER JOIN Tournoi t ON p.id_tournoi = t.id_tournoi
WHERE t.nom_tournoi = 'Open de Paris';
-- Q3.2 : Lister tous les joueurs, même ceux qui n'ont jamais envoyé de demande d'ami (Jointure externe gauche)
SELECT j.pseudo_joueur, d.date_de_demande
FROM Joueurs j
LEFT JOIN demande_d_ami d ON j.id_joueur = d.id_joueur_demande;
-- Q3.3 : Afficher les parties avec le nom des joueurs Blancs et Noirs (Jointure multiple + auto-jointure)
SELECT p.id_partie, jb.pseudo_joueur AS joueur_blanc, jn.pseudo_joueur AS joueur_noir, p.resultat_partie
FROM Parties p
JOIN joue_partie jpb ON p.id_partie = jpb.id_partie AND jpb.couleur_joueur = 'Blanc'
JOIN Joueurs jb ON jpb.id_joueur = jb.id_joueur
JOIN joue_partie jpn ON p.id_partie = jpn.id_partie AND jpn.couleur_joueur = 'Noir'
JOIN Joueurs jn ON jpn.id_joueur = jn.id_joueur;
-- Q3.4 : Compter le nombre de participants par tournoi, y compris les tournois vides (Jointure externe)
SELECT t.nom_tournoi, COUNT(p.id_joueur) AS nb_participants
FROM Tournoi t
LEFT JOIN participe p ON t.id_tournoi = p.id_tournoi
GROUP BY t.id_tournoi, t.nom_tournoi;
-- Q3.5 : Afficher les demandes d'amis mutuelles (Auto-jointure)
SELECT j1.pseudo_joueur AS demandeur, j2.pseudo_joueur AS receveur
FROM demande_d_ami d1
JOIN demande_d_ami d2 ON d1.id_joueur_demande = d2.id_joueur_recoit AND d1.id_joueur_recoit = d2.id_joueur_demande
JOIN Joueurs j1 ON d1.id_joueur_demande = j1.id_joueur
JOIN Joueurs j2 ON d1.id_joueur_recoit = j2.id_joueur;
-- =====================================================================
-- 4. REQUÊTES IMBRIQUÉES (IN, EXISTS, ANY, ALL)
-- =====================================================================
-- Q4.1 : Trouver les joueurs dont l'ELO Blitz est supérieur à la moyenne (Sous-requête avec opérateur de comparaison)
SELECT pseudo_joueur, elo_blitz
FROM Joueurs
WHERE elo_blitz > (SELECT AVG(elo_blitz) FROM Joueurs);
-- Q4.2 : Trouver les joueurs qui n'ont jamais participé à un tournoi (NOT EXISTS)
SELECT pseudo_joueur
FROM Joueurs j
WHERE NOT EXISTS (
SELECT 1 FROM participe p WHERE p.id_joueur = j.id_joueur
);
-- Q4.3 : Trouver les parties qui n'ont pas été jouées avec la cadence 'Bullet 1+0' (NOT IN)
SELECT id_partie, date_heure_debut
FROM Parties
WHERE id_cadence NOT IN (
SELECT id_cadence FROM Cadence WHERE nom_cadence = 'Bullet 1+0'
);
-- Q4.4 : Trouver les joueurs qui ont un ELO Blitz supérieur à au moins un joueur ayant participé au tournoi 1 (ANY)
SELECT pseudo_joueur, elo_blitz
FROM Joueurs
WHERE elo_blitz > ANY (
SELECT j.elo_blitz
FROM Joueurs j
JOIN participe p ON j.id_joueur = p.id_joueur
WHERE p.id_tournoi = 1
);
-- Q4.5 : Trouver le joueur ayant le meilleur ELO Blitz parmi ceux qui ont joué une partie (ALL)
SELECT pseudo_joueur, elo_blitz
FROM Joueurs
WHERE elo_blitz >= ALL (
SELECT elo_blitz FROM Joueurs WHERE id_joueur IN (SELECT id_joueur FROM joue_partie)
);