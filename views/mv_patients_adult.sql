CREATE MATERIALIZED VIEW mimic3.mv_patients_adult AS 
 SELECT p.subject_id, icu.hadm_id, icu.icustay_id,
    date_part('year'::text, icu.intime) - date_part('year'::text, p.dob) AS pt_age
   FROM mimic3.patients p,
	mimic3.icustays icu    
  WHERE p.subject_id = icu.subject_id AND (date_part('year'::text, icu.intime) - date_part('year'::text, p.dob)) >= 16::double precision
  ORDER BY (date_part('year'::text, icu.intime) - date_part('year'::text, p.dob));

CREATE INDEX idx01_mv_patients_adult
  ON mimic3.mv_patients_adult
  USING btree
  (subject_id);
CREATE INDEX idx02_mv_patients_adult
  ON mimic3.mv_patients_adult
  USING btree
  (hadm_id);
CREATE INDEX idx03_mv_patients_adult
  ON mimic3.mv_patients_adult
  USING btree
  (icustay_id);
