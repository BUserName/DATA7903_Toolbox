DROP MATERIALIZED VIEW IF EXISTS mimic3.mv_icustays_adult;
create materialized view mimic3.mv_icustays_adult as
	select *
	from mimic3.icustays	
	where subject_id in (select distinct subject_id from mimic3.mv_patients_adult);

--  53,424 records

CREATE INDEX idx01_mv_icustays_adult
  ON mimic3.mv_icustays_adult
  USING btree
  (subject_id);
CREATE INDEX idx02_mv_icustays_adult
  ON mimic3.mv_icustays_adult
  USING btree
  (hadm_id);
CREATE INDEX idx03_mv_icustays_adult
  ON mimic3.mv_icustays_adult
  USING btree
  (icustay_id);