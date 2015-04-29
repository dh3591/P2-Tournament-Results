-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

CREATE DATABASE tournament;
\c tournament;

CREATE TABLE players (
	name text,
	id serial primary key
);

CREATE TABLE matches (
	winner integer references players(id),
	loser integer references players(id),
	id serial primary key
);

CREATE VIEW winner_count AS 
	SELECT players.id, count(matches.winner) AS wins
	FROM players LEFT JOIN matches
	ON players.id = matches.winner
	GROUP BY players.id 
	ORDER BY wins DESC;

CREATE VIEW match_count AS 
	SELECT players.id, count(matches) AS matches
	FROM players LEFT JOIN matches
	ON players.id = matches.winner OR players.id = matches.loser
	GROUP BY players.id 
	ORDER BY matches DESC;

CREATE VIEW player_wins AS
	SELECT players.id, players.name, winner_count.wins
	FROM players, winner_count
	WHERE players.id = winner_count.id
	ORDER BY wins DESC;

CREATE VIEW player_standings AS
	SELECT player_wins.id, player_wins.name, player_wins.wins, match_count.matches
	FROM player_wins, match_count
	WHERE player_wins.id = match_count.id
	ORDER BY wins DESC;

CREATE VIEW pairings AS
	SELECT a.id AS id1, a.name AS name1, b.id AS id2, b.name AS name2
	FROM player_standings AS a, player_standings AS b
	WHERE a.wins = b.wins and a.id < b.id;
