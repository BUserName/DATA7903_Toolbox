set search_path to mimic3;

create or replace function get_mask_pvt_all_vars(icustay_id bigint, time_window integer)
	returns table (
	TW_hour_idx double precision, 
	BPd integer,	BPm integer,
	BPs integer,	Albumin integer,
	ALT integer,	Arterial_pH integer,
	Phosphorous integer,	Alkaline_Phosphate integer,
	Bilirubin integer,	BUN integer,
	Calcium integer,	Calcium_Ionized  integer,
	Chloride integer,	Creatinine integer,
	CVP integer,	FiO2 integer,	GCS integer,
	Glucose integer,	HCO3 integer,
	HCT integer,	Hemoglobin integer,
	HR integer,	INR integer, Magnesium integer,
	Mean_Airway_Pressure integer,	O2_Flow integer,
	PaCO2 integer,	PaO2 integer,
	Platelets integer,	POTASSIUM integer,
	PT integer,	PTT integer,	RR integer,
	SaO2 integer,	SODIUM integer,
	SpO2 integer,	TCO2 integer,
	TEMP integer,	Urine integer,
	WBC integer,	Weight integer
	) 
as $$
declare
	
begin
	return query select tmp.tw_hour_idx,
		(case when tmp.bpd	 is null then 0 else 1 end) as fv1,
		(case when tmp.bpm is null then 0 else 1 end) as fv2,
		(case when tmp.bps	 is null then 0 else 1 end) as fv3,
		(case when tmp.albumin is null then 0 else 1 end) as fv4,
		(case when tmp.alt	 is null then 0 else 1 end) as fv5,
		(case when tmp.arterial_ph is null then 0 else 1 end) as fv6,
		(case when tmp.phosphorous	 is null then 0 else 1 end) as fv7,
		(case when tmp.alkaline_phosphate is null then 0 else 1 end) as fv8,
		(case when tmp.bilirubin	 is null then 0 else 1 end) as fv9,
		(case when tmp.bun is null then 0 else 1 end) as fv110,
		(case when tmp.calcium	 is null then 0 else 1 end) as fv11,
		(case when tmp.calcium_ionized  is null then 0 else 1 end) as fv12,
		(case when tmp.chloride	 is null then 0 else 1 end) as fv13,
		(case when tmp.creatinine is null then 0 else 1 end) as fv14,
		(case when tmp.cvp is null then 0 else 1 end) as fv15,
		(case when tmp.fio2	 is null then 0 else 1 end) as fv16,
		(case when tmp.gcs is null then 0 else 1 end) as fv17,
		(case when tmp.glucose	 is null then 0 else 1 end) as fv18,
		(case when tmp.hco3 is null then 0 else 1 end) as fv19,
		(case when tmp.hct	 is null then 0 else 1 end) as fv20,
		(case when tmp.hemoglobin is null then 0 else 1 end) as fv21,
		(case when tmp.hr	 is null then 0 else 1 end) as fv22,
		(case when tmp.inr	 is null then 0 else 1 end) as fv23,
		(case when tmp.magnesium is null then 0 else 1 end) as fv24,
		(case when tmp.mean_airway_pressure	 is null then 0 else 1 end) as fv25,
		(case when tmp.o2_flow is null then 0 else 1 end) as fv26,
		(case when tmp.paco2	 is null then 0 else 1 end) as fv27,
		(case when tmp.pao2 is null then 0 else 1 end) as fv28,
		(case when tmp.platelets	 is null then 0 else 1 end) as fv29,
		(case when tmp.potassium is null then 0 else 1 end) as fv30,
		(case when tmp.pt	 is null then 0 else 1 end) as fv31,
		(case when tmp.ptt	 is null then 0 else 1 end) as fv32,
		(case when tmp.rr is null then 0 else 1 end) as fv33,
		(case when tmp.sao2	 is null then 0 else 1 end) as fv34,
		(case when tmp.sodium is null then 0 else 1 end) as fv35,
		(case when tmp.spo2	 is null then 0 else 1 end) as fv36,
		(case when tmp.tco2 is null then 0 else 1 end) as fv37,
		(case when tmp.temp	 is null then 0 else 1 end) as fv38,
		(case when tmp.urine is null then 0 else 1 end) as fv39,
		(case when tmp.wbc	 is null then 0 else 1 end) as fv40,
		(case when tmp.weight is null then 0 else 1 end) as fv41
		from
		(select * from mimic3.get_pvt_all_vars(icustay_id, time_window)) tmp;
end;
$$ language plpgsql;	


-- test code: 
-- select * from get_mask_pvt_all_vars(274671,1)

--select * from get_pvt_all_vars(274671,1)


