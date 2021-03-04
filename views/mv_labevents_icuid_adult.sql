CREATE OR REPLACE VIEW mimic3.mv_labevents_icuid_adult AS 
 SELECT l.subject_id,
    l.hadm_id,
    i.icustay_id,
    l.itemid,
    l.charttime,
    i.intime,
    i.outtime,
    l.value,
    l.valuenum,
    l.valueuom,
    l.flag
   FROM mimic3.labevents l,
    mimic3.icustays i
  WHERE i.hadm_id = l.hadm_id AND (date_part('epoch'::text, l.charttime) - date_part('epoch'::text, i.intime)) >= '-3600'::integer::double precision AND (date_part('epoch'::text, i.outtime) - date_part('epoch'::text, l.charttime)) >= '-3600'::integer::double precision
  and l.subject_id in (select distinct subject_id from mimic3.mv_patients_adult)
  ORDER BY l.charttime;