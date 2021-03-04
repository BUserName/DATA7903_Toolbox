set search_path to mimic3;

create materialized view mv_adult_sofa_vars as

	select c.subject_id, c.hadm_id,
	case
		when c.itemid in (185,186,189,190) then
			'FiO2'
		when c.itemid in (490,779) then
			'PaO2'
		when c.itemid in (225690,225651) then
			'Bilirubin'
		when c.itemid in (828,227457) then
			'Platelets'
		when c.itemid in (198,220739,223900,223901) then
			'GCS'
		when c.itemid in (52,456,220052,220181) then
			'MAP'
		when c.itemid in (791,220615) then
			'CREATININE'
		when c.itemid in (580,581,763,224639) then
			'Weight'
	end itemcat,
	c.itemid, c.charttime, c.value, c.valuenum, c.valueuom
	from chartevents c where itemid in
	(185,186,189,190, 490,779,
	 225690,225651, 828,227457,
	 198,220739,223900,223901,
	 52,456,220052,220181, 
	 791,220615, 580,581,763,224639)
	 and subject_id in (select distinct subject_id from mimic3.mv_patients_adult)
	
	union all
	
	select l.subject_id, l.hadm_id,
	case
		when l.itemid in (50883,50884,50885,51464) then
			'Bilirubin'
		when l.itemid in (50912,51082) then
			'CREATININE'
	end itemcat,
	l.itemid, l.charttime, l.value, l.valuenum, l.valueuom
	from labevents l
	where itemid in
	(50883,50884,50885,51464,50912,51082)
	 and subject_id in (select distinct subject_id from mimic3.mv_patients_adult)
	
	union all
	
	select o.subject_id, o.hadm_id,
	case
		when o.itemid in (40055, 40056, 40057, 40061, 40065, 40069, 40085, 40094, 40096, 40288, 
	40405, 40428, 40473, 40651, 40715, 42068, 42510, 43175, 43431, 43522, 43576, 43633, 
	44080, 44253, 45304, 45415, 45927, 46658, 46748, 226566, 226627, 226631, 227489) then
			'URINE'
	end itemcat,
	o.itemid, o.charttime, to_char(o.value,'FM99999'), o.value, o.valueuom
	from outputevents o
	where itemid in (40055, 40056, 40057, 40061, 40065, 40069, 40085, 40094, 40096, 40288, 
	40405, 40428, 40473, 40651, 40715, 42068, 42510, 43175, 43431, 43522, 43576, 43633, 
	44080, 44253, 45304, 45415, 45927, 46658, 46748, 226566, 226627, 226631, 227489)
	 and subject_id in (select distinct subject_id from mimic3.mv_patients_adult)

	union all

	select icv.subject_id, icv.hadm_id,
	case
		when icv.itemid in (30042) then
			'dob'
		when icv.itemid in (30043) then
			'dop'
		when icv.itemid in (30044,30047,30019,300120) then
			'epi'
	end itemcat,
	icv.itemid, icv.charttime, to_char(icv.amount,'FM99999.999999'), icv.amount, icv.amountuom
	from inputevents_cv icv
	where itemid in
	(30042,30043,30044,30047,30119,30120)
	 and subject_id in (select distinct subject_id from mimic3.mv_patients_adult)

	union all 

	select imv.subject_id, imv.hadm_id,
	case
		when imv.itemid in (221653) then
			'dob'
		when imv.itemid in (221662) then
			'dop'
		when imv.itemid in (221289,221906) then
			'epi'
	end itemcat,
	imv.itemid, imv.starttime, to_char(imv.amount,'FM99999.999999'), imv.amount, imv.amountuom
	from inputevents_mv imv
	where itemid in
	(221653,221662,221289,221906)
	 and subject_id in (select distinct subject_id from mimic3.mv_patients_adult);
-- Test code
-- 16360081 records
-- select distinct itemcat, count(*) from adults_sofa_variables_records 
-- group by itemcat

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