set search_path to mimic3;
create materialized view mv_adult_daily_urine_outputs as
	select icustay_id,tw_24hr, sum(valuenum) urine_output_per_24hrs from mv_adult_sofa_vars_tw
	where lower(itemcat)='urine' 
	group by icustay_id, tw_24hr;

CREATE INDEX idx01_mv_adults_daily_urine_outputs
  ON mimic3.mv_adult_daily_urine_outputs
  USING btree
  (icustay_id);
