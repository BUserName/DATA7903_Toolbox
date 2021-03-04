
create materialized view mv_adults_apacheii_vars as
    select c.subject_id, c.hadm_id, c.icustay_id,
    case
        when c.itemid in (211,220045) then
            'HR' -- BPM
        when c.itemid in (51,455,220050,220179) then
            'SYS BP' -- mmHg
        -- 678,679,223761 is in Farenheit and should be converted into celcius
        when c.itemid in (676,677,678,679,223761,223762) then
            'TEMP' -- C
        when c.itemid in (615,618,224688,220210,224690,224689) then
            'RR' -- BPM
        when c.itemid in (781,1162,225624) then
            'BUN' -- mg/dL
        when c.itemid in (791,220615) then
            'CREATININE' -- mg/dL
        when c.itemid in (813,220545) then
            'HCT' -- %
        when c.itemid in (861,1127,1542,220546) then
            'WBC' -- per cubic mm
        when c.itemid in (807,811,1529,225664,220621,226537) then
            'GLUCOSE' -- mg/dL
        when c.itemid in (829,1535,227442,227464) then
            'POTASSIUM' -- mEq/liter
        when c.itemid in (837,1536,220645,226534) then
            'SODIUM' -- mEq/liter
        when c.itemid in (812,227443) then
            'HCO3' -- mEq/liter
    end itemcat,
    c.itemid, c.charttime, 
    case
    -- 678,679,223761 is in Farenheit and should be converted into celcius
        when c.itemid in (678,679,223761) then to_char((c.valuenum-32)*5/9, 'FM999.999999')
        else c.value
    end cvalue,  
    case
    -- 678,679,223761 is in Farenheit and should be converted into celcius
        when c.itemid in (678,679,223761) then (c.valuenum-32)*5/9
        else c.valuenum
    end valuenum, 
    case
    -- 678,679,223761 is in Farenheit and should be converted into celcius
        when c.itemid in (678,679,223761) then 'Deg. C'
        else c.valueuom
    end valueuom
    from chartevents_adults c where itemid in
    (   211,220045, 
        51,455,220050,220179,
        676,677,678,679,223761,223762,
        615,618,224688,220210,224690,224689,
        781,1162,225624,
        791,220615,
        813,220545,
        861,1127,1542,220546,
        807,811,1529,225664,220621,226537,
        829,1535,227442,227464,
        837,1536,220645,226534,
        812,227443)
    and valuenum is not null
    and valuenum >=0
    and c.hadm_id in (select distinct hadm_id from icustays_adults)
     
    union all
     
    select l.subject_id, l.hadm_id, l.icustay_id,
    case
        when l.itemid in (51006) then
            'BUN'
        when l.itemid in (50912) then
            'CREATININE'
        when l.itemid in (50810,51221) then
            'HCT'
        when l.itemid in (51301) then
            'WBC'
        when l.itemid in (50931,50809) then
            'GLUCOSE'
        when l.itemid in (50971,50822) then
            'POTASSIUM'
        when l.itemid in (50983,50824) then
            'SODIUM'
        when l.itemid in (50804) then
            'HCO3'
    end itemcat,
    l.itemid, l.charttime, l.value, l.valuenum, l.valueuom
    from labevents_adults_icuid l
    where itemid in
    (   51006,
        50912,
        50810,51221,
        51301,
        50931,50809,
        50971,50822,
        50983,50824,
        50804)
    and l.valuenum is not null
    and l.valuenum >=0
    and l.hadm_id in (select distinct hadm_id from icustays_adults)

    union all
    
    -- check urine itemids
     
    select o.subject_id, o.hadm_id, o.icustay_id,
    'URINE' as itemcat, -- litre
    o.itemid, o.charttime, 
    to_char(o.value/1000,'FM99999.999999'), 
    o.value/1000, 
    'l' as valueuom
    from outputevents o
    where itemid in (40055, 40056, 40057, 40061, 40065, 40069, 40085, 
        40094, 40096, 40288, 40405, 40428, 40473, 40715, 43175, 226559)
    and o.value is not null
    and o.value >=0
    and o.hadm_id in (select distinct hadm_id from icustays_adults)

    union all

    select subject_id, hadm_id, icustay_id, itemcat, 198::integer as itemid, charttime, cvalue, valuenum, 'points' as valueuom 
    from adults_gcs 
    where valuenum is not null -- add gcs records
    and valuenum>=3;

-- Theoretically, 38,598 adults/49786 adults admissions
-- 38,582 distinct adults vs 38,598 theoretical adults
-- 49,491 admissions vs 49,786 theoretical admissions


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