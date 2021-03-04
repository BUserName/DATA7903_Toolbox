set search_path to mimic3;
drop materialized view if exists mv_adult_sofa_vars;
create materialized view mv_adult_sofa_vars as
    ------------------------------------------------ in chart events
    select c.subject_id, c.hadm_id, c.icustay_id,
    case
        when c.itemid in (52,456,220181,220052,225312) then
            'ABP_mean' -- mmHg
        when c.itemid in (848,1538,225690) then
            'Bilirubin' -- mg/dL
        when c.itemid in (791,1525,220615) then
            'CREATININE' -- mg/dL
        when c.itemid in (779,220224) then
            'PaO2'
        when c.itemid in (828,227457) then
            'Platelets'        
    end itemcat,
    c.itemid, c.charttime, c.value as cvalue, c.valuenum,c.valueuom
    from chartevents c where itemid in
    (   52,456,220181,220052,225312,
        791,1525,220615,
        779,220224

        )
    and valuenum is not null
    and valuenum >=0
    and valuenum <=3000
    and c.hadm_id in (select distinct hadm_id from mv_icustays_adult)
    and subject_id in (select distinct subject_id from mimic3.mv_patients_adult)
     
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
    from chartevents c where itemid in (189,190,223835)
    and subject_id in (select distinct subject_id from mimic3.mv_patients_adult)
     
    union all
    ------------------------------------------------ in lab events     
    select l.subject_id, l.hadm_id, l.icustay_id,
    case
        when l.itemid in (50885) then
            'Bilirubin'        
        when l.itemid in (50912) then
            'CREATININE'
        when l.itemid in (50821) then
            'PaO2'
        when l.itemid in (51265) then
            'Platelets'
    end itemcat,
    l.itemid, l.charttime, l.value, l.valuenum, l.valueuom
    from mv_labevents_icuid_adult l
    where itemid in
    (   50885, 
        50912,
        50821,
        51265       
        )
    and l.valuenum is not null
    and l.valuenum >=0
    and l.valuenum <=3000
    and l.hadm_id in (select distinct hadm_id from mv_icustays_adult)
    and subject_id in (select distinct subject_id from mimic3.mv_patients_adult)

    union all
    ------------------------------------------------ GCS
    select subject_id, hadm_id, icustay_id, itemcat, 198::integer as itemid, charttime, cvalue, valuenum, 'points' as valueuom 
    from mv_gcs_adult 
    where valuenum is not null -- add gcs records
    and valuenum>=3
    and subject_id in (select distinct subject_id from mimic3.mv_patients_adult)

    union all
    ------------------------------------------------ dop, dob, epi, nor in inputevents_cv 
    select subject_id, hadm_id, icustay_id, 
    case
        when itemid in (30043) and rate >=0 then
            'Dopamine'
        when itemid in (30042,30306) then
            'Dobutamine'
        when itemid in (30044,30119) then
            'Epinephrine'
        when itemid in (30047,30120) then
            'Norepinephrine'
    end itemcat,
    itemid, charttime, to_char(rate,'FM9999.999999'), rate as value, rateuom as valueuom
    from inputevents_cv
    where itemid in (30043,30042,30306,30044,30119,30047,30120)
    and subject_id in (select distinct subject_id from mimic3.mv_patients_adult)
    and rate is not null
    and rate >=0
    

    union all
    ------------------------------------------------ dop, dob, epi, nor in inputevents_mv 
    select subject_id, hadm_id, icustay_id,
    case
        when itemid in (221662) and rate >=0 then
            'Dopamine'
        when itemid in (221653) then
            'Dobutamine'
        when itemid in (221289) then
            'Epinephrine'
        when itemid in (221906) then
            'Norepinephrine'
    end itemcat,
    itemid, starttime, to_char(rate,'FM9999.999999') as cvalue, rate as value, rateuom as valueuom
    from inputevents_mv
    where itemid in (221662,221653,221289,221906)
    and subject_id in (select distinct subject_id from mimic3.mv_patients_adult)
    and rate is not null
    and rate >=0

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
    and o.icustay_id in (select icustay_id from mv_icustays_adult)
    and subject_id in (select distinct subject_id from mimic3.mv_patients_adult);



CREATE INDEX idx01_mv_adult_sofa_vars
  ON mimic3.mv_adult_sofa_vars
  USING btree
  (subject_id, hadm_id, itemcat COLLATE pg_catalog."default", itemid);
CREATE INDEX idx02_mv_adult_sofa_vars
  ON mimic3.mv_adult_sofa_vars
  USING btree
  (subject_id);
CREATE INDEX idx03_mv_adult_sofa_vars
  ON mimic3.mv_adult_sofa_vars
  USING btree
  (hadm_id);
CREATE INDEX idx04_mv_adult_sofa_vars
  ON mimic3.mv_adult_sofa_vars
  USING btree
  (itemid);
CREATE INDEX idx05_mv_adult_sofa_vars
  ON mimic3.mv_adult_sofa_vars
  USING btree
  (itemcat);

-- Test code
-- 14666185 records
-- select distinct itemcat, count(*) from mimic3.mv_adult_sofa_vars group by itemcat