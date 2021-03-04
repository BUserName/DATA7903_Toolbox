set search_path to mimic3;

do $$
declare
	icustay_id bigint ;
	tw_length integer := 1;
	row_cnt integer;
	idx integer :=0;
begin
	for icustay_id in (select distinct icu.icustay_id from icustays_adults icu order by icu.icustay_id) loop
		select count(*) into row_cnt from get_pvt_all_vars(icustay_id, tw_length);		
		insert into sparsity_all_vars(icustay_id, bpd, bpm, bps, albumin, alt , arterial_ph , phosphorous , alkaline_phosphate , bilirubin , bun , calcium , calcium_ionized  , chloride , creatinine, cvp, fio2 , gcs , glucose , hco3 , hct , hemoglobin , hr, inr, magnesium , mean_airway_pressure , o2_flow , paco2 , pao2 , platelets , potassium , pt, ptt , rr , sao2 , sodium , spo2 , tco2 , temp , urine , wbc , weight)
		select icustay_id, sum(tmp.bpd)/ cast(row_cnt as double precision),
			sum(tmp.bpm)/ cast(row_cnt as double precision),
			sum(tmp.bps)/ cast(row_cnt as double precision),
			sum(tmp.albumin)/ cast(row_cnt as double precision),
			sum(tmp.alt )/ cast(row_cnt as double precision),
			sum(tmp.arterial_ph )/ cast(row_cnt as double precision),
			sum(tmp.phosphorous )/ cast(row_cnt as double precision),
			sum(tmp.alkaline_phosphate )/ cast(row_cnt as double precision),
			sum(tmp.bilirubin )/ cast(row_cnt as double precision),
			sum(tmp.bun )/ cast(row_cnt as double precision),
			sum(tmp.calcium )/ cast(row_cnt as double precision),
			sum(tmp.calcium_ionized  )/ cast(row_cnt as double precision),
			sum(tmp.chloride )/ cast(row_cnt as double precision),
			sum(tmp.creatinine )/ cast(row_cnt as double precision),
			sum(tmp.cvp )/ cast(row_cnt as double precision),
			sum(tmp.fio2 )/ cast(row_cnt as double precision),
			sum(tmp.gcs )/ cast(row_cnt as double precision),
			sum(tmp.glucose )/ cast(row_cnt as double precision),
			sum(tmp.hco3 )/ cast(row_cnt as double precision),
			sum(tmp.hct )/ cast(row_cnt as double precision),
			sum(tmp.hemoglobin )/ cast(row_cnt as double precision),
			sum(tmp.hr )/ cast(row_cnt as double precision),
			sum(tmp.inr )/ cast(row_cnt as double precision),
			sum(tmp.magnesium )/ cast(row_cnt as double precision),
			sum(tmp.mean_airway_pressure )/ cast(row_cnt as double precision),
			sum(tmp.o2_flow )/ cast(row_cnt as double precision),
			sum(tmp.paco2 )/ cast(row_cnt as double precision),
			sum(tmp.pao2 )/ cast(row_cnt as double precision),
			sum(tmp.platelets )/ cast(row_cnt as double precision),
			sum(tmp.potassium )/ cast(row_cnt as double precision),
			sum(tmp.pt )/ cast(row_cnt as double precision),
			sum(tmp.ptt )/ cast(row_cnt as double precision),
			sum(tmp.rr )/ cast(row_cnt as double precision),
			sum(tmp.sao2 )/ cast(row_cnt as double precision),
			sum(tmp.sodium )/ cast(row_cnt as double precision),
			sum(tmp.spo2 )/ cast(row_cnt as double precision),
			sum(tmp.tco2 )/ cast(row_cnt as double precision),
			sum(tmp.temp )/ cast(row_cnt as double precision),
			sum(tmp.urine )/ cast(row_cnt as double precision),
			sum(tmp.wbc )/ cast(row_cnt as double precision),
			sum(tmp.weight)/ cast(row_cnt as double precision)
		from get_mask_pvt_all_vars(icustay_id, tw_length) tmp;
		idx=idx+1;
		raise notice '% ICU records have been done!', idx;
	end loop;
end $$;

copy (select * from sparsity_all_vars) to 'd:\sparsity.csv' with csv