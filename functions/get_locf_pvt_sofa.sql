set search_path to mimic3;
-- icustay_id is the id of icustays
-- time_window is the length of a time window, including (1, 3, 6, 12, 24) hours
create or replace function get_locf_pvt_sofa(icustay_id bigint, time_window integer)
	returns table (
		tw_hour_idx double precision, 
		abp_mean double precision,
		bilirubin double precision,	
		creatinine double precision,
		dobutamine double precision, -- not to impute
		dopamine double precision, -- not to impute
		epinephrine double precision,	-- not to impute
		fio2 double precision,
		gcs double precision,
		norepinephrine double precision,  -- not to impute
		pao2 double precision,
		platelets double precision,
		urine double precision
	) 
as $$
begin
	return query
	select pvt_sofa.tw_hour_idx,
	    case -- abp_mean
	        when locf(pvt_sofa.abp_mean) OVER( ORDER BY pvt_sofa.tw_hour_idx ) is null 
	            then (select distinct median_value from mimic3.d_sofa_vars where lower(item_cat)='abp_mean')
	        else locf(pvt_sofa.abp_mean) OVER( ORDER BY pvt_sofa.tw_hour_idx )
	    end abp_mean,

	    case -- bilirubin
	        when locf(pvt_sofa.bilirubin) OVER( ORDER BY pvt_sofa.tw_hour_idx ) is null 
	            then (select distinct median_value from mimic3.d_sofa_vars where lower(item_cat)='bilirubin')
	        else locf(pvt_sofa.bilirubin) OVER( ORDER BY pvt_sofa.tw_hour_idx )
	    end bilirubin,

	    case -- creatinine
	    	when locf(pvt_sofa.creatinine) OVER( ORDER BY pvt_sofa.tw_hour_idx ) is null 
	    		then (select distinct median_value from mimic3.d_sofa_vars where lower(item_cat)='creatinine')
	        else locf(pvt_sofa.creatinine) OVER( ORDER BY pvt_sofa.tw_hour_idx )
	    end creatinine,
	    pvt_sofa.dobutamine,
	    pvt_sofa.dopamine,
	    pvt_sofa.epinephrine,
	    case -- fio2
	        when locf(pvt_sofa.fio2) OVER( ORDER BY pvt_sofa.tw_hour_idx ) is null 
	            then (select distinct median_value from mimic3.d_sofa_vars where lower(item_cat)='fio2')
	        else locf(pvt_sofa.fio2) OVER( ORDER BY pvt_sofa.tw_hour_idx )
	    end fio2,

	    case -- gcs
	    	when locf(pvt_sofa.gcs) OVER( ORDER BY pvt_sofa.tw_hour_idx ) is null 
	    		then (select distinct median_value from mimic3.d_sofa_vars where lower(item_cat)='gcs')
	        else locf(pvt_sofa.gcs) OVER( ORDER BY pvt_sofa.tw_hour_idx )
	    end gcs,
	    pvt_sofa.norepinephrine,
	    case -- pao2
	        when locf(pvt_sofa.pao2) OVER( ORDER BY pvt_sofa.tw_hour_idx ) is null 
	            then (select distinct median_value from mimic3.d_sofa_vars where lower(item_cat)='pao2')
	        else locf(pvt_sofa.pao2) OVER( ORDER BY pvt_sofa.tw_hour_idx )
	    end pao2,    

	    case -- platelets
	    	when locf(pvt_sofa.platelets) OVER( ORDER BY pvt_sofa.tw_hour_idx ) is null 
	    		then (select distinct median_value from mimic3.d_sofa_vars where lower(item_cat)='platelets')
	        else locf(pvt_sofa.platelets) OVER( ORDER BY pvt_sofa.tw_hour_idx )
	    end platelets,

	    case -- urine
--	    (select (urine_output_per_24hrs * time_window / 24) from mv_adults_daily_urine_outputs mv_urine
--	    	where mv_urine.icustay_id= icustay_id
--	    	and tw_24hr = floor(pvt_sofa.tw_hour_idx * time_window / 24) +1) urine
	    	when locf(pvt_sofa.urine) OVER( ORDER BY pvt_sofa.tw_hour_idx ) is null 
	    		then 0 --(select distinct median_value from mimic3.d_sofa_vars where lower(item_cat)='urine')
	        else locf(pvt_sofa.urine) OVER( ORDER BY pvt_sofa.tw_hour_idx )
	    end urine
	from (select * from get_pvt_sofa($1,$2)) pvt_sofa;

end;
$$ language plpgsql;

-- test code: 
-- select * from get_locf_pvt_sofa(274671,1)