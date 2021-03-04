set search_path to mimic3;
drop materialized view if exists mv_adults_apacheii_vars_tw;
create materialized view mv_adults_apacheii_vars_tw as
select asv.subject_id, asv.hadm_id, asv.icustay_id, asv.itemcat, asv.itemid, asv.charttime, icu.intime, icu.outtime, asv.cvalue, asv.valuenum, asv.valueuom, 
  (EXTRACT(EPOCH FROM asv.charttime)- (extract(epoch from icu.intime)-extract(minute from icu.intime)*60-extract(second from icu.intime)))/3600 as Hour_Diff,
  floor(abs(extract(epoch from asv.charttime) - extract(epoch from icu.intime))/3600) +1 as TW_1hr,
  floor(abs(extract(epoch from asv.charttime) - extract(epoch from icu.intime))/(3600*3)) +1 as TW_3hr,
  floor(abs(extract(epoch from asv.charttime) - extract(epoch from icu.intime))/(3600*6)) +1 as TW_6hr,
  floor(abs(extract(epoch from asv.charttime) - extract(epoch from icu.intime))/(3600*12)) +1 as TW_12hr,
  floor(abs(extract(epoch from asv.charttime) - extract(epoch from icu.intime))/(3600*24)) +1 as TW_24hr     
  from mv_adults_apacheii_vars asv,
  icustays_adults icu
  where asv.subject_id=icu.subject_id
  and asv.hadm_id=icu.hadm_id
  -- data records can be half an hour earlier than intime
  and extract(epoch from asv.charttime) - extract(epoch from icu.intime) >= -3600
  -- data records can be half an hour later than outtime
  and extract(epoch from icu.outtime) - extract(epoch from asv.charttime) >= -3600 
  and asv.valuenum >= 0 --exclude abnormal values, e.g. minus values
  order by asv.charttime;



CREATE INDEX idx01_mv_adults_apacheii_vars_tw
  ON mimic3.mv_adults_apacheii_vars_tw
  USING btree
  (subject_id, hadm_id, itemcat COLLATE pg_catalog."default", itemid);
CREATE INDEX idx02_mv_adults_apacheii_vars_tw
  ON mimic3.mv_adults_apacheii_vars_tw
  USING btree
  (subject_id);
CREATE INDEX idx03_mv_adults_apacheii_vars_tw
  ON mimic3.mv_adults_apacheii_vars_tw
  USING btree
  (hadm_id);
  CREATE INDEX idx04_mv_adults_apacheii_vars_tw
  ON mimic3.mv_adults_apacheii_vars_tw
  USING btree
  (itemid);
  CREATE INDEX idx05_mv_adults_apacheii_vars_tw
  ON mimic3.mv_adults_apacheii_vars_tw
  USING btree
  (itemcat);

  -- 63,157,698 records (with time windows) vs 65,630,648 records in mv_adults_apacheii
  -- 49,391 distinct hadm_id vs 49,491
  -- 38,520 distinct subject_id vs 38,582

select count(*) from mv_adults_apacheii_vars_tw