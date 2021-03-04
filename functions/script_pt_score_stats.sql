do $$
declare 
icustay_id integer;
tw_hr_length integer := 1;
cnt integer :=0;
begin
	for icustay_id in (select icu.icustay_id from icustays_adults icu order by icustay_id) loop
		insert into pt_score_stats
		select icustay_id, 'APACHEII', tw_hr_length, max(tw_hour_idx), count(*)
		from get_pvt_apacheii(icustay_id,tw_hr_length) pvt;

		insert into pt_score_stats
		select icustay_id, 'SAPSII', tw_hr_length, max(tw_hour_idx), count(*)
		from get_pvt_sapsii(icustay_id,tw_hr_length) pvt;

		insert into pt_score_stats
		select icustay_id, 'SOFA', tw_hr_length, max(tw_hour_idx), count(*)
		from get_pvt_sofa(icustay_id,tw_hr_length) pvt;	

		cnt=cnt+1;
		raise notice '% records has been processed!', cnt;	
	end loop;
end;
$$ language plpgsql;