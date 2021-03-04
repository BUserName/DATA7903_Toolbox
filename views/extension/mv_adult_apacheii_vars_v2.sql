set search_path to mimic3;
drop materialized view if exists mv_adults_apacheii_vars;
create materialized view mv_adults_apacheii_vars as
    select c.subject_id, c.hadm_id, c.icustay_id,
    case
        when c.itemid in (52,456,220181,220052,225312) then
            'ABP_mean' -- mmHg
        when c.itemid in (780,1126,223830) then 
            'Arterial_pH'        
        when c.itemid in (791,1525,220615) then
            'CREATININE' -- mg/dL
        when c.itemid in (812,227443) then
            'HCO3' -- mEq/liter
        when c.itemid in (813,220545) then
            'HCT' -- %
        when c.itemid in (211,220045) then
            'HR' -- BPM        
        when c.itemid in (778,220235) then
            'PaCO2'
        when c.itemid in (779,220224) then
            'PaO2'
        when c.itemid in (829,1535,227442,227464) then
            'POTASSIUM' -- mEq/liter
        when c.itemid in (615,618,619,224688,220210,224690,224689) then
            'RR' -- BPM
        when c.itemid in (837,1536,220645,226534) then
            'SODIUM' -- mEq/liter  
        when c.itemid in (861,1127,1542,220546) then
            'WBC' -- per cubic mm         
    end itemcat,
    c.itemid, c.charttime, c.value as cvalue, c.valuenum,c.valueuom
    from chartevents_adults c where itemid in
    (   52,456,220181,220052,225312,
        780,1126,223830,         
        791,1525,220615,
    --    189,190,223835,
        812,227443,
        813,220545,
        211,220045,
        778,220235,
        779,220224,        
        829,1535,227442,227464,
        615,618,619,224688,220210,224690,224689,
        837,1536,220645,226534,
    --    676,677,678,679,223761,223762,
        861,1127,1542,220546)
    and valuenum is not null
    and valuenum >=0
    and valuenum <=1000
    and c.hadm_id in (select distinct hadm_id from icustays_adults)
     
    union all

    -- FiO2 someone uses decimal values while someone use integer percentage
    select c.subject_id, c.hadm_id, c.icustay_id, 'FiO2' as itemcat, c.itemid, c.charttime,
    case
        when (c.valuenum>=20 and c.valuenum<=100) then to_char(c.valuenum, 'FM999.999')
        when (c.valuenum>=0.2 and c.valuenum<=1) then to_char((c.valuenum)*100, 'FM999.999')
    end cvalue,
    case
        when (c.valuenum>=20 and c.valuenum<=100) then c.valuenum
        when (c.valuenum>=0.2 and c.valuenum<=1) then c.valuenum*100
    end valuenum,
    '%' as valueuom
    from chartevents_adults c where itemid in (189,190,223835)
     
    union all
    -- Temperature someone use celcius while someone use Farenheit
    select c.subject_id, c.hadm_id, c.icustay_id, 'TEMP' as itemcat, c.itemid, c.charttime,
    case
        when (c.valuenum>=20 and c.valuenum<=50) then to_char(c.valuenum, 'FM999.999')
        when (c.valuenum>=68 and c.valuenum<=122) then to_char((c.valuenum-32)*5/9, 'FM999.999')
    end cvalue,
    case
        when (c.valuenum>=20 and c.valuenum<=50) then c.valuenum
        when (c.valuenum>=68 and c.valuenum<=122) then (c.valuenum-32)*5/9
    end valuenum,
    'C' as valueuom
    from chartevents_adults c where itemid in (676,677,678,679,223761,223762)

    union all
         
    select l.subject_id, l.hadm_id, l.icustay_id,
    case
        when l.itemid in (50820) then
            'Arterial_pH'        
        when l.itemid in (50912) then
            'CREATININE'
        when l.itemid in (50882) then
            'HCO3'        
        when l.itemid in (50810,51221) then
            'HCT'        
        when l.itemid in (50818) then
            'PaCO2'
        when l.itemid in (50821) then
            'PaO2'
        when l.itemid in (50971,50822) then
            'POTASSIUM'
        when l.itemid in (50983,50824) then
            'SODIUM'
        when l.itemid in (51301) then
            'WBC'
        
    end itemcat,
    l.itemid, l.charttime, l.value, l.valuenum, l.valueuom
    from labevents_adults_icuid l
    where itemid in
    (   50820,        
        50912,
        50804,
        50810,51221,
        50818,
        50821,     
        50971,50822,
        50983,50824,
        51301)
    and l.valuenum is not null
    and l.valuenum >=0
    and l.valuenum <=1000
    and l.hadm_id in (select distinct hadm_id from icustays_adults)

    union all

    select subject_id, hadm_id, icustay_id, itemcat, 198::integer as itemid, charttime, cvalue, valuenum, 'points' as valueuom 
    from adults_gcs 
    where valuenum is not null -- add gcs records
    and valuenum>=3;

CREATE INDEX idx01_mv_adults_apacheii_vars
  ON mimic3.mv_adults_apacheii_vars
  USING btree
  (subject_id, hadm_id, itemcat COLLATE pg_catalog."default", itemid);
CREATE INDEX idx02_mv_adults_apacheii_vars
  ON mimic3.mv_adults_apacheii_vars
  USING btree
  (subject_id);
CREATE INDEX idx03_mv_adults_apacheii_vars
  ON mimic3.mv_adults_apacheii_vars
  USING btree
  (hadm_id);
CREATE INDEX idx04_mv_adults_apacheii_vars
  ON mimic3.mv_adults_apacheii_vars
  USING btree
  (itemid);
CREATE INDEX idx05_mv_adults_apacheii_vars
  ON mimic3.mv_adults_apacheii_vars
  USING btree
  (itemcat);