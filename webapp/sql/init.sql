DELETE FROM tenant WHERE id > 100;
DELETE FROM visit_history WHERE created_at >= '1654041600';
UPDATE id_generator SET id=2678400000 WHERE stub='a';
ALTER TABLE id_generator AUTO_INCREMENT=2678400000;

-- change admin schema (execute once)
-- CREATE INDEX tenant_id_and_competition_id_idx ON visit_history (tenant_id, competition_id);
