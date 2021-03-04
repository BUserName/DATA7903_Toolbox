set search_path to mimic3;
-- icustay_id is the id of icustays
-- time_window is the length of a time window, including (1, 3, 6, 12, 24) hours
create or replace function get_locf_pvt_all_vars(icustay_id bigint, time_window integer)
	returns table (
		tw_hour_idx double precision, 
	bpd double precision,	bpm double precision,
	bps double precision,	albumin double precision,
	alt double precision,	arterial_ph double precision,
	phosphorous double precision,	alkaline_phosphate double precision,
	bilirubin double precision,	bun double precision,
	calcium double precision,	calcium_ionized  double precision,
	chloride double precision,	creatinine double precision,
	cvp double precision,	fio2 double precision,	gcs double precision,
	glucose double precision,	hco3 double precision,
	hct double precision,	hemoglobin double precision,
	hr double precision,	inr double precision, magnesium double precision,
	mean_airway_pressure double precision,	o2_flow double precision,
	paco2 double precision,	pao2 double precision,
	platelets double precision,	potassium double precision,
	pt double precision,	ptt double precision,	rr double precision,
	sao2 double precision,	sodium double precision,
	spo2 double precision,	tco2 double precision,
	temperature double precision,	urine double precision,
	wbc double precision,	weight double precision
	) 
as $$
begin
	return query
	select pvt_vars.tw_hour_idx,
	    case 
			when locf(pvt_vars.bpd	) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 1)
			else locf(pvt_vars.bpd) over (order by pvt_vars.tw_hour_idx)
		end bpd,
		case 
			when locf(pvt_vars.bpm) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 2)
			else locf(pvt_vars.bpm) over (order by pvt_vars.tw_hour_idx)
		end bpm,
		case 
			when locf(pvt_vars.bps) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 3)
			else locf(pvt_vars.bps) over (order by pvt_vars.tw_hour_idx)
		end bps,
		case 
			when locf(pvt_vars.albumin) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 4)
			else locf(pvt_vars.albumin) over (order by pvt_vars.tw_hour_idx)
		end albumin,
		case 
			when locf(pvt_vars.alt) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 5)
			else locf(pvt_vars.alt) over (order by pvt_vars.tw_hour_idx)
		end alt,
		case 
			when locf(pvt_vars.arterial_ph) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 6)
			else locf(pvt_vars.arterial_ph) over (order by pvt_vars.tw_hour_idx)
		end arterial_ph,
		case 
			when locf(pvt_vars.phosphorous) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 7)
			else locf(pvt_vars.phosphorous) over (order by pvt_vars.tw_hour_idx)
		end phosphorous,
		case 
			when locf(pvt_vars.alkaline_phosphate) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 8)
			else locf(pvt_vars.alkaline_phosphate) over (order by pvt_vars.tw_hour_idx)
		end alkaline_phosphate,
		case 
			when locf(pvt_vars.bilirubin) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 9)
			else locf(pvt_vars.bilirubin) over (order by pvt_vars.tw_hour_idx)
		end bilirubin,
		case 
			when locf(pvt_vars.bun) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 10)
			else locf(pvt_vars.bun) over (order by pvt_vars.tw_hour_idx)
		end bun,
		case 
			when locf(pvt_vars.calcium) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 11)
			else locf(pvt_vars.calcium) over (order by pvt_vars.tw_hour_idx)
		end calcium,
		case 
			when locf(pvt_vars.calcium_ionized ) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 12)
			else locf(pvt_vars.calcium_ionized) over (order by pvt_vars.tw_hour_idx)
		end calcium_ionized,
		case 
			when locf(pvt_vars.chloride) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 13)
			else locf(pvt_vars.chloride) over (order by pvt_vars.tw_hour_idx)
		end chloride,
		case 
			when locf(pvt_vars.creatinine) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 14)
			else locf(pvt_vars.creatinine) over (order by pvt_vars.tw_hour_idx)
		end creatinine,
		case 
			when locf(pvt_vars.cvp) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 15)
			else locf(pvt_vars.cvp) over (order by pvt_vars.tw_hour_idx)
		end cvp,
		case 
			when locf(pvt_vars.fio2) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 16)
			else locf(pvt_vars.fio2) over (order by pvt_vars.tw_hour_idx)
		end fio2,
		case 
			when locf(pvt_vars.gcs) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 17)
			else locf(pvt_vars.gcs) over (order by pvt_vars.tw_hour_idx)
		end gcs,
		case 
			when locf(pvt_vars.glucose) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 18)
			else locf(pvt_vars.glucose) over (order by pvt_vars.tw_hour_idx)
		end glucose,
		case 
			when locf(pvt_vars.hco3) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 19)
			else locf(pvt_vars.hco3) over (order by pvt_vars.tw_hour_idx)
		end hco3,
		case 
			when locf(pvt_vars.hct) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 20)
			else locf(pvt_vars.hct) over (order by pvt_vars.tw_hour_idx)
		end hct,
		case 
			when locf(pvt_vars.hemoglobin) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 21)
			else locf(pvt_vars.hemoglobin) over (order by pvt_vars.tw_hour_idx)
		end hemoglobin,
		case 
			when locf(pvt_vars.hr) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 22)
			else locf(pvt_vars.hr) over (order by pvt_vars.tw_hour_idx)
		end hr,
		case 
			when locf(pvt_vars.inr) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 23)
			else locf(pvt_vars.inr) over (order by pvt_vars.tw_hour_idx)
		end inr,
		case 
			when locf(pvt_vars.magnesium) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 24)
			else locf(pvt_vars.magnesium) over (order by pvt_vars.tw_hour_idx)
		end magnesium,
		case 
			when locf(pvt_vars.mean_airway_pressure	) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 25)
			else locf(pvt_vars.mean_airway_pressure) over (order by pvt_vars.tw_hour_idx)
		end mean_airway_pressure,
		case 
			when locf(pvt_vars.o2_flow) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 26)
			else locf(pvt_vars.o2_flow) over (order by pvt_vars.tw_hour_idx)
		end o2_flow,
		case 
			when locf(pvt_vars.paco2) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 27)
			else locf(pvt_vars.paco2) over (order by pvt_vars.tw_hour_idx)
		end paco2,
		case 
			when locf(pvt_vars.pao2) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 28)
			else locf(pvt_vars.pao2) over (order by pvt_vars.tw_hour_idx)
		end pao2,
		case 
			when locf(pvt_vars.platelets) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 29)
			else locf(pvt_vars.platelets) over (order by pvt_vars.tw_hour_idx)
		end platelets,
		case 
			when locf(pvt_vars.potassium) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 30)
			else locf(pvt_vars.potassium) over (order by pvt_vars.tw_hour_idx)
		end potassium,
		case 
			when locf(pvt_vars.pt) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 31)
			else locf(pvt_vars.pt) over (order by pvt_vars.tw_hour_idx)
		end pt,
		case 
			when locf(pvt_vars.ptt) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 32)
			else locf(pvt_vars.ptt) over (order by pvt_vars.tw_hour_idx)
		end ptt,
		case 
			when locf(pvt_vars.rr) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 33)
			else locf(pvt_vars.rr) over (order by pvt_vars.tw_hour_idx)
		end rr,
		case 
			when locf(pvt_vars.sao2) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 34)
			else locf(pvt_vars.sao2) over (order by pvt_vars.tw_hour_idx)
		end sao2,
		case 
			when locf(pvt_vars.sodium) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 35)
			else locf(pvt_vars.sodium) over (order by pvt_vars.tw_hour_idx)
		end sodium,
		case 
			when locf(pvt_vars.spo2) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 36)
			else locf(pvt_vars.spo2) over (order by pvt_vars.tw_hour_idx)
		end spo2,
		case 
			when locf(pvt_vars.tco2) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 37)
			else locf(pvt_vars.tco2) over (order by pvt_vars.tw_hour_idx)
		end tco2,
		case 
			when locf(pvt_vars.temp) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 38)
			else locf(pvt_vars.temp) over (order by pvt_vars.tw_hour_idx)
		end temperature,
		case 
			when locf(pvt_vars.urine) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 39)
			else locf(pvt_vars.urine) over (order by pvt_vars.tw_hour_idx)
		end urine,
		case 
			when locf(pvt_vars.wbc) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 40)
			else locf(pvt_vars.wbc) over (order by pvt_vars.tw_hour_idx)
		end wbc,
		case 
			when locf(pvt_vars.weight) over (order by pvt_vars.tw_hour_idx) is null
				then (select distinct median_value from mimic3.d_all_vars where category= 41)
			else locf(pvt_vars.weight) over (order by pvt_vars.tw_hour_idx)
		end weight
	from (select * from mimic3.get_pvt_all_vars($1,$2)) pvt_vars;
end;
$$ language plpgsql;

-- test code: 
-- select * from mimic3.get_locf_pvt_all_vars(274671,1)