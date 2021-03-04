set search_path to mimic3;
drop materialized view if exists mv_adults_sapsii_vars;
create materialized view mv_adults_sapsii_vars as
	select c.subject_id, c.hadm_id, c.icustay_id,
    case
        when c.itemid in (51,455,220050,220179) then --52,456,220181,220052,225312) then
            'ABP_systolic' -- mmHg        
        when c.itemid in (848,1538,225690) then
            'Bilirubin' -- mg/dL 
        when c.itemid in (781,1162,225624) then
            'BUN' -- mg/dL             
        when c.itemid in (812,227443) then
            'HCO3' -- mEq/liter        
        when c.itemid in (211,220045) then
            'HR' -- BPM                
        when c.itemid in (779,220224) then
            'PaO2'
        when c.itemid in (829,1535,227442,227464) then
            'POTASSIUM' -- mEq/liter        
        when c.itemid in (837,1536,220645,226534) then
            'SODIUM' -- mEq/liter  
        when c.itemid in (861,1127,1542,220546) then
            'WBC' -- per cubic mm         
    end itemcat,
    c.itemid, c.charttime, c.value as cvalue, c.valuenum,c.valueuom
    from chartevents_adults c where itemid in
    (  	51,455,220050,220179,
        848,1538,225690,
        781,1162,225624,
        812,227443,
        211,220045,
        779,220224,        
        829,1535,227442,227464,        
        837,1536,220645,226534,    
        861,1127,1542,220546)
    and valuenum is not null
    and valuenum >=0
    and valuenum <=1000
    and c.hadm_id in (select distinct hadm_id from icustays_adults)

    union all
    
     
    select l.subject_id, l.hadm_id, l.icustay_id,
    case
     	when l.itemid in (50885) then
            'Bilirubin'        
        when l.itemid in (51006) then
            'BUN'
        when l.itemid in (50882) then
            'HCO3'        
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
    (   50885,
        51006,
        50804,
        50821,     
        50971,50822,
        50983,50824,
        51301)
    and l.valuenum is not null
    and l.valuenum >=0
    and l.valuenum <=1000
    and l.hadm_id in (select distinct hadm_id from icustays_adults)

    union all
    ------------------------------------------------ in convert into a unique unit
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
    ------------------------------------------------ GCS
    select subject_id, hadm_id, icustay_id, itemcat, 198::integer as itemid, charttime, cvalue, valuenum, 'points' as valueuom 
    from adults_gcs 
    where valuenum is not null -- add gcs records
    and valuenum>=3

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
    ------------------------------------------------ in output events URINE
    select o.subject_id, o.hadm_id, o.icustay_id,
    'URINE' as itemcat, -- litre
    o.itemid, o.charttime, 
    to_char(o.value/1000,'FM99999.999999') as cvalue, 
    o.value/1000 as value, 
    'l' as valueuom
    from outputevents o
    where itemid in (40055, 40056, 40057, 40061, 40065, 40069, 40085, 40094, 40096, 
            40288, 40405, 40428, 40473, 40715, 43175, 226559, 226627,226631,227489)
    and o.value is not null
    and o.value >=0
    and o.value <=10000
    and o.icustay_id in (select icustay_id from icustays_adults);

CREATE INDEX idx01_mv_adults_sapsii_vars
  ON mimic3.mv_adults_sapsii_vars
  USING btree
  (subject_id, hadm_id, itemcat COLLATE pg_catalog."default", itemid);
CREATE INDEX idx02_mv_adults_sapsii_vars
  ON mimic3.mv_adults_sapsii_vars
  USING btree
  (subject_id);
CREATE INDEX idx03_mv_adults_sapsii_vars
  ON mimic3.mv_adults_sapsii_vars
  USING btree
  (hadm_id);
CREATE INDEX idx04_mv_adults_sapsii_vars
  ON mimic3.mv_adults_sapsii_vars
  USING btree
  (itemid);
CREATE INDEX idx05_mv_adults_sapsii_vars
  ON mimic3.mv_adults_sapsii_vars
  USING btree
  (itemcat);

-- select count(*) from mv_adults_sapsii_vars