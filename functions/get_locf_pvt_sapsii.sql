set search_path to mimic3;
-- icustay_id is the id of icustays
-- time_window is the length of a time window, including (1, 3, 6, 12, 24) hours
create or replace function get_locf_pvt_sapsii(icustay_id bigint, time_window integer)
	returns table (
		tw_hour_idx double precision, 
		abp_systolic double precision,
		bilirubin double precision,
		bun double precision,
		fio2 double precision,
		gcs double precision,
		hco3 double precision,
		hr double precision,
		pao2 double precision,
		potassium double precision,
		sodium double precision,
		temp double precision,
		urine double precision,
		wbc double precision
	) 
as $$
begin
	return query
	select pvt_sapsii.tw_hour_idx,
	    case -- abp_systolic
	        when locf(pvt_sapsii.abp_systolic) OVER( ORDER BY pvt_sapsii.tw_hour_idx ) is null 
	            then (select distinct median_value from d_sapsii_vars where lower(item_cat)='abp_systolic')
	        else locf(pvt_sapsii.abp_systolic) OVER( ORDER BY pvt_sapsii.tw_hour_idx )
	    end abp_systolic,

	    case -- bilirubin
	        when locf(pvt_sapsii.bilirubin) OVER( ORDER BY pvt_sapsii.tw_hour_idx ) is null 
	            then (select distinct median_value from d_sapsii_vars where lower(item_cat)='bilirubin')
	        else locf(pvt_sapsii.bilirubin) OVER( ORDER BY pvt_sapsii.tw_hour_idx )
	    end bilirubin,

	    case -- bun
	    	when locf(pvt_sapsii.bun) OVER( ORDER BY pvt_sapsii.tw_hour_idx ) is null 
	    		then (select distinct median_value from d_sapsii_vars where lower(item_cat)='bun')
	        else locf(pvt_sapsii.bun) OVER( ORDER BY pvt_sapsii.tw_hour_idx )
	    end bun,
	   
	    case -- fio2
	        when locf(pvt_sapsii.fio2) OVER( ORDER BY pvt_sapsii.tw_hour_idx ) is null 
	            then (select distinct median_value from d_sapsii_vars where lower(item_cat)='fio2')
	        else locf(pvt_sapsii.fio2) OVER( ORDER BY pvt_sapsii.tw_hour_idx )
	    end fio2,

	    case -- gcs
	    	when locf(pvt_sapsii.gcs) OVER( ORDER BY pvt_sapsii.tw_hour_idx ) is null 
	    		then (select distinct median_value from d_sapsii_vars where lower(item_cat)='gcs')
	        else locf(pvt_sapsii.gcs) OVER( ORDER BY pvt_sapsii.tw_hour_idx )
	    end gcs,

	    case -- hco3
	    	when locf(pvt_sapsii.hco3) OVER( ORDER BY pvt_sapsii.tw_hour_idx ) is null 
	    		then (select distinct median_value from d_sapsii_vars where lower(item_cat)='hco3')
	        else locf(pvt_sapsii.hco3) OVER( ORDER BY pvt_sapsii.tw_hour_idx )
	    end hco3,

	    case -- hr
	    	when locf(pvt_sapsii.hr) OVER( ORDER BY pvt_sapsii.tw_hour_idx ) is null 
	    		then (select distinct median_value from d_sapsii_vars where lower(item_cat)='hr')
	        else locf(pvt_sapsii.hr) OVER( ORDER BY pvt_sapsii.tw_hour_idx )
	    end hr,
	    case -- pao2
	        when locf(pvt_sapsii.pao2) OVER( ORDER BY pvt_sapsii.tw_hour_idx ) is null 
	            then (select distinct median_value from d_sapsii_vars where lower(item_cat)='pao2')
	        else locf(pvt_sapsii.pao2) OVER( ORDER BY pvt_sapsii.tw_hour_idx )
	    end pao2,    

	    case -- potassium
	    	when locf(pvt_sapsii.potassium) OVER( ORDER BY pvt_sapsii.tw_hour_idx ) is null 
	    		then (select distinct median_value from d_sapsii_vars where lower(item_cat)='potassium')
	        else locf(pvt_sapsii.potassium) OVER( ORDER BY pvt_sapsii.tw_hour_idx )
	    end potassium,

	    case -- sodium
	    	when locf(pvt_sapsii.sodium) OVER( ORDER BY pvt_sapsii.tw_hour_idx ) is null 
	    		then (select distinct median_value from d_sapsii_vars where lower(item_cat)='sodium')
	        else locf(pvt_sapsii.sodium) OVER( ORDER BY pvt_sapsii.tw_hour_idx )
	    end sodium,

		case -- temp
	    	when locf(pvt_sapsii.temp) OVER( ORDER BY pvt_sapsii.tw_hour_idx ) is null 
	    		then (select distinct median_value from d_sapsii_vars where lower(item_cat)='temp')
	        else locf(pvt_sapsii.temp) OVER( ORDER BY pvt_sapsii.tw_hour_idx )
	    end temperature,

	    case -- urine
--	    (select (urine_output_per_24hrs * time_window / 24) from mv_adults_daily_urine_outputs mv_urine
--	    	where mv_urine.icustay_id= icustay_id
--	    	and tw_24hr = floor(pvt_sapsii.tw_hour_idx * time_window / 24) +1) urine
	    	when locf(pvt_sapsii.urine) OVER( ORDER BY pvt_sapsii.tw_hour_idx ) is null 
	    		then 0--(select distinct median_value from d_sapsii_vars where lower(item_cat)='urine')
	        else locf(pvt_sapsii.urine) OVER( ORDER BY pvt_sapsii.tw_hour_idx )
	    end urine,

	    case -- wbc
	    	when locf(pvt_sapsii.wbc) OVER( ORDER BY pvt_sapsii.tw_hour_idx ) is null 
	    		then (select distinct median_value from d_sapsii_vars where lower(item_cat)='wbc')
	        else locf(pvt_sapsii.wbc) OVER( ORDER BY pvt_sapsii.tw_hour_idx )
	    end wbc
	from (select * from get_pvt_sapsii($1,$2)) pvt_sapsii;

end;
$$ language plpgsql;

-- test code: 
-- select * from get_locf_pvt_sapsii(274671,1)