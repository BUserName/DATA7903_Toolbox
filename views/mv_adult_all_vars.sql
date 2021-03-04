set search_path to mimic3;
drop materialized view if exists mv_adult_all_vars;
create materialized view mv_adult_all_vars as
	select c.subject_id, c.hadm_id, c.icustay_id,
	case
		when c.itemid in (8368,8555,220051,225310, 8441,220180) then 1 -- ABPd
		when c.itemid in (52,220052,225312, 456,220181) then 2 -- ABPm
		when c.itemid in (51,220050, 455,220179) then 3 -- ABPs
	--	when c.itemid in (8441,220180) then 4 -- NBPd
	--	when c.itemid in (456,220181) then 5 -- NBPm
	--	when c.itemid in (455,220179) then 6 -- NBPs
	--	when c.itemid in (8448,220060) then 7 -- PAPd
	--	when c.itemid in (491,220061) then 8 -- PAPm
	--	when c.itemid in (492,220059) then 9 -- PAPs
		when c.itemid in (772,1521,227456) then 4 -- Albumin
		when c.itemid in (769,220644) then 5 -- ALT
	--	when c.itemid in (3732,227073) then 12 -- AG (Anion Gap)
		when c.itemid in (780,1126,223830) then 6 -- ApH (Arterial pH)
		when c.itemid in (827,1534,225677) then 7 -- P (Phosphorous) 827, 1534 * 3.09597523219814
		when c.itemid in (773,225612) then 8 -- AP (Alkaline Phosphate)
		when c.itemid in (848,1538,225690) then 9 -- Bilirubin
		when c.itemid in (781,1162,225624) then 10 -- BUN
		when c.itemid in (786,1522,225625) then 11 -- Calcium
		when c.itemid in (816,225667) then 12 -- Calcium-Ionized
		when c.itemid in (788,1523,220602,226536) then 13 -- Chloride
		when c.itemid in (791,1525,220615) then 14 -- Creatinine 
		when c.itemid in (113,220074) then 15 -- CVP 
	--	when c.itemid in (189,190,223835) then 16 -- FiO2
	--	when c.itemid in (198,220739,223900,223901) then 17 -- GCS
		when c.itemid in (807,811,1529,225664,220621,226537) then 18 -- Glucose
		when c.itemid in (812,227443) then 19 -- HCO3
		when c.itemid in (813,220545) then 20 -- HCT
	--	when c.itemid in (777,220048) then 26 -- Heart Rhythm 
		when c.itemid in (814,220228) then 21 -- Hemoglobin
		when c.itemid in (211,220045) then 22 -- HR
		when c.itemid in (815,1530,227467) then 23 -- INR
		when c.itemid in (821,1532,220635) then 24 -- Magnesium
		when c.itemid in (444,224697) then 25 -- Mean Airway Pressure
		when c.itemid in (470,471,223834,227287) then 26 -- O2 Flow
		when c.itemid in (778,220235) then 27 -- PaCO2
		when c.itemid in (779,220224) then 28 -- PaO2
		when c.itemid in (828,227457) then 29 -- Platelets
		when c.itemid in (829,1535,227442,227464) then 30 -- Potassium
		when c.itemid in (824,1286,227465) then 31 -- PT
		when c.itemid in (825,1533,227466) then 32 -- PTT
	--	when c.itemid in (833) then 36 -- RBC (Red Blood Cells)
		when c.itemid in (615,618,619,224688,220210,224690,224689) then 33 -- RR (Respiratory Rate)
		when c.itemid in (834,220227) then 34 -- SaO2
		when c.itemid in (837,1536,220645,226534) then 35 -- Sodium
		when c.itemid in (646,220277) then 36 -- SpO2
		when c.itemid in (777,787,225698) then 37 -- TCO2
	--	when c.itemid in (676,677,678,679,223761,223762) then 38 -- Temp
		when c.itemid in (861,1127,1542,220546) then 40 -- WBC (White Blood Cells)
		when c.itemid in (580,581,763,3580,224639) then 41 --  Weight
	end itemcat,
	c.itemid, c.charttime, c.value as cvalue, c.valuenum, c.valueuom
	from chartevents c where itemid in 
	(
		8368,8555,220051,225310, 8441,220180, 
		52,220052,225312, 456,220181, 
		51,220050, 455,220179, 
		772,1521,227456, 
		769,220644, 
		780,1126,223830, 
		827,1534,225677, 
		773,225612, 
		848,1538,225690, 
		781,1162,225624, 
		786,1522,225625, 
		816,225667, 
		788,1523,220602,226536, 
		791,1525,220615, 
		113,220074, 
		807,811,1529,225664,220621,226537, 
		812,227443, 
		813,220545, 
		814,220228, 
		211,220045, 
		815,1530,227467, 
		821,1532,220635, 
		444,224697, 
		470,471,223834,227287, 
		778,220235, 
		779,220224, 
		828,227457, 
		829,1535,227442,227464, 
		824,1286,227465, 
		825,1533,227466, 
		615,618,619,224688,220210,224690,224689, 
		834,220227, 
		837,1536,220645,226534, 
		646,220277, 
		777,787,225698, 
		861,1127,1542,220546, 
		580,581,763,3580,224639 
	)
	and value is not null
	and valuenum is not null
--	and value ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$'
	and valuenum >=0
	and valuenum <=25000
	and c.hadm_id in (select distinct hadm_id from mv_icustays_adult)
	and subject_id in (select distinct subject_id from mimic3.mv_patients_adult)


union all
---- Variables from labevents	
	select l.subject_id, l.hadm_id, l.icustay_id,
	case
		when l.itemid in (50862) then 4 -- Albumin
		when l.itemid in (50861) then 5 -- ALT
		when l.itemid in (50820) then 6 -- ApH
		when l.itemid in (50970) then 7 -- Phosphorous
		when l.itemid in (50863) then 8 -- Alkaline Phosphate
		when l.itemid in (50885) then 9 -- Bilirubin
		when l.itemid in (51006) then 10 -- BUN
		when l.itemid in (50893) then 11 -- Calcium
		when l.itemid in (50808) then 12 -- Calcium-Ionized
		when l.itemid in (50902,50806) then 13 -- Chloride
		when l.itemid in (50912) then 14 -- Creatinine
		when l.itemid in (50809,50931) then 18 -- Glucose
		when l.itemid in (50882) then 19 -- HCO3
		when l.itemid in (50810,51221) then 20 -- HCT
		when l.itemid in (50811,51222) then 21 -- Hemoglobin
		when l.itemid in (51237) then 23 -- INR
		when l.itemid in (50960) then 24 -- Magnesium
		when l.itemid in (50815) then 26 -- O2 Flow
		when l.itemid in (50818) then 27 -- PaCO2
		when l.itemid in (50821) then 28 -- PaO2
		when l.itemid in (51265) then 29 -- Platelets
		when l.itemid in (50971,50822) then 30 -- Potassium
		when l.itemid in (51274) then 31 -- PT
		when l.itemid in (51275) then 35 -- PTT
		when l.itemid in (50817) then 34 -- SaO2
		when l.itemid in (50983,50824) then 35 -- Sodium
		when l.itemid in (50804) then 37 -- TCO2
		when l.itemid in (51301) then 40 -- WBC
	end itemcat,
	l.itemid, l.charttime, l.value, l.valuenum, l.valueuom
	from mv_labevents_icuid_adult l
	where itemid in
	(
		50862,
		50861,
		50820,
		50970,
		50863,
		50885,
		51006,
		50893,
		50808,
		50902,50806,
		50912,
		50809,50931,
		50882,
		50810,51221,
		50811,51222,
		51237,
		50960,
		50815,
		50818,
		50821,
		51265,
		50971,50822,
		51274,
		51275,
		50817,
		50983,50824,
		50804,
		51301
	)
	and value is not null
	and valuenum is not null
--	and value ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$'
	and valuenum >=0
	and valuenum <=25000
	and l.hadm_id in (select distinct hadm_id from mv_icustays_adult)
	and subject_id in (select distinct subject_id from mimic3.mv_patients_adult)

union all
---- Variables from outputevents	
	select o.subject_id, o.hadm_id, o.icustay_id,
    39::integer as itemcat, -- litre
    o.itemid, o.charttime, 
    to_char(o.value/1000,'FM99999.999999'), 
    o.value/1000, 
    'l' as valueuom
    from outputevents o
    where itemid in (40055, 40056, 40057, 40061, 40065, 40069, 40085, 
        40094, 40096, 40288, 40405, 40428, 40473, 40715, 43175, 226559)
    and o.value is not null
    and o.value >=0
    and o.icustay_id in (select icustay_id from mv_icustays_adult)
    and subject_id in (select distinct subject_id from mimic3.mv_patients_adult)

union all
    ------------------------------------------------ in convert into a unique unit
    -- FiO2 someone uses decimal values while someone use integer percentage
    select c.subject_id, c.hadm_id, c.icustay_id, 16::integer as itemcat, c.itemid, c.charttime,
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
    and c.hadm_id in (select distinct hadm_id from mimic3.mv_icustays_adult)
    and c.subject_id in (select distinct subject_id from mimic3.mv_patients_adult)

union all

    -- Temperature someone uses Celcius while someone uses Farenheit
    select c.subject_id, c.hadm_id, c.icustay_id, 38::integer as itemcat, c.itemid, c.charttime,
    case
        when (c.valuenum>=20 and c.valuenum<=50) then to_char(c.valuenum, 'FM999.999')
        when (c.valuenum>=68 and c.valuenum<=122) then to_char((c.valuenum-32)*5/9, 'FM999.999')
    end cvalue,
    case
        when (c.valuenum>=20 and c.valuenum<=50) then c.valuenum
        when (c.valuenum>=68 and c.valuenum<=122) then (c.valuenum-32)*5/9
    end valuenum,
    'C' as valueuom
    from chartevents c where itemid in (676,677,678,679,223761,223762)
    and c.hadm_id in (select distinct hadm_id from mimic3.mv_icustays_adult)
    and c.subject_id in (select distinct subject_id from mimic3.mv_patients_adult)

union all

---- GCS
    select subject_id, hadm_id, icustay_id, 17::integer, 198::integer as itemid, charttime, cvalue, valuenum, 'points' as valueuom 
    from mv_gcs_adult 
    where valuenum is not null -- add gcs records
    and valuenum>=3
    and hadm_id in (select distinct hadm_id from mv_icustays_adult)
    and subject_id in (select distinct subject_id from mimic3.mv_patients_adult)
    ;


CREATE INDEX mv_all_vars_hadm_id_idx
  ON mimic3.mv_adult_all_vars
  USING btree
  (hadm_id);

CREATE INDEX mv_all_vars_itemcat_idx
  ON mimic3.mv_adult_all_vars
  USING btree
  (itemcat);
CREATE INDEX mv_all_vars_itemid_idx
  ON mimic3.mv_adult_all_vars
  USING btree
  (itemid);
CREATE INDEX mv_all_vars_subject_id_icustay_id_itemcat_idx
  ON mimic3.mv_adult_all_vars
  USING btree
  (subject_id, icustay_id, itemcat);

CREATE INDEX mv_all_vars_subject_id_idx
  ON mimic3.mv_adult_all_vars
  USING btree
  (subject_id);
