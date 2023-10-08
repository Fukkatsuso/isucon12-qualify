DELETE FROM tenant WHERE id > 100;
DELETE FROM visit_history WHERE created_at >= '1654041600';
UPDATE id_generator SET id=2678400000 WHERE stub='a';
ALTER TABLE id_generator AUTO_INCREMENT=2678400000;

-- change admin schema (execute once)
-- CREATE INDEX tenant_id_and_competition_id_idx ON visit_history (tenant_id, competition_id);

CREATE INDEX tenant_id_and_competition_id_and_player_id_idx ON visit_history (tenant_id, competition_id, player_id);
DELETE FROM visit_history
WHERE created_at > (
  SELECT MIN(tmp.created_at)
  FROM visit_history tmp
  WHERE tmp.tenant_id = visit_history.tenant_id AND tmp.competition_id = visit_history.competition_id AND tmp.player_id = visit_history.player_id
) AS t;
DROP INDEX tenant_id_and_competition_id_idx ON visit_history;
DROP INDEX tenant_id_idx ON visit_history;
ALTER TABLE visit_history ADD PRIMARY KEY (tenant_id, competition_id, player_id);
