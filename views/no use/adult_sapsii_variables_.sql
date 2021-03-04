set search_path to mimic3;

select c.subject_id, c.hadm_id,
	case
		when c.itemid in (211,220045) then
			'HR'
		when c.itemid in (51,455,220050,220179) then
			'SYS BP'
		when c.itemid in (676,677,678,679,223761,223762) then
			'TEMP'
		when c.itemid in (615,618,220210,224690,224689) then
			'RR'
		when c.itemid in (781,1162,225624) then
			'BUN'
		when c.itemid in (791,220615) then
			'CREATININE'
		when c.itemid in (813,220545) then
			'HCT'
		when c.itemid in (861,1127,1542,220546) then
			'WBC'
		when c.itemid in (807,811,1529,225664,220621,226537) then
			'GLUCOSE'
		when c.itemid in (829,1535,227442,227464) then
			'POTASSIUM'
		when c.itemid in (837,1536,220645,226534) then
			'SODIUM'
		when c.itemid in (812,227443) then
			'HCO3'
	end itemcat,
	c.itemid, c.charttime, 
	case 
		when c.itemid in (678,679,223761) then to_char((c.valuenum-32)*5/9, 'FM999.999999')
		when c.itemid not in (678,679,223761) then c.value
	end cvalue, 
	case 
		when c.itemid in (678,679,223761) then (c.valuenum-32)*5/9
		when c.itemid not in (678,679,223761) then c.valuenum
	end valuenum, 
	case 
		when c.itemid in (678,679,223761) then 'Deg. C'
		when c.itemid not in (678,679,223761) then c.valueuom
	end valueuom
	from chartevents_adults c where itemid in
	(678) and valuenum is not null
	limit 100