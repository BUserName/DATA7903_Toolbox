set search_path to mimic3;
-- icustay_id is the id of icustays
-- time_window is the length of a time window, including (1, 3, 6, 12, 24) hours
create or replace function get_locf_pvt_apacheii(icustay_id bigint, time_window integer)
	returns table (
		tw_hour_idx double precision, 
		abp_mean double precision,
		arterial_ph double precision,	
		creatinine double precision,
		fio2 double precision,
		gcs double precision,
		hco3 double precision,
		hct double precision,
		hr double precision,
		paco2 double precision,
		pao2 double precision,
		potassium double precision,
		rr double precision,
		sodium double precision,
		temperature double precision,
		wbc double precision
	) 
as $$
begin
	return query
	select pvt_apacheii.tw_hour_idx,
	    case -- abp_mean
	        when locf(pvt_apacheii.abp_mean) OVER( ORDER BY pvt_apacheii.tw_hour_idx ) is null 
	            then (select distinct median_value from d_apacheii_vars where lower(item_cat)='abp_mean')
	        else locf(pvt_apacheii.abp_mean) OVER( ORDER BY pvt_apacheii.tw_hour_idx )
	    end abp_mean,

	    case -- arterial_ph
	        when locf(pvt_apacheii.arterial_ph) OVER( ORDER BY pvt_apacheii.tw_hour_idx ) is null 
	            then (select distinct median_value from d_apacheii_vars where lower(item_cat)='arterial_ph')
	        else locf(pvt_apacheii.arterial_ph) OVER( ORDER BY pvt_apacheii.tw_hour_idx )
	    end arterial_ph,

	    case -- creatinine
	    	when locf(pvt_apacheii.creatinine) OVER( ORDER BY pvt_apacheii.tw_hour_idx ) is null 
	    		then (select distinct median_value from d_apacheii_vars where lower(item_cat)='creatinine')
	        else locf(pvt_apacheii.creatinine) OVER( ORDER BY pvt_apacheii.tw_hour_idx )
	    end creatinine,

	    case -- fio2
	        when locf(pvt_apacheii.fio2) OVER( ORDER BY pvt_apacheii.tw_hour_idx ) is null 
	            then (select distinct median_value from d_apacheii_vars where lower(item_cat)='fio2')
	        else locf(pvt_apacheii.fio2) OVER( ORDER BY pvt_apacheii.tw_hour_idx )
	    end fio2,

	    case -- gcs
	    	when locf(pvt_apacheii.gcs) OVER( ORDER BY pvt_apacheii.tw_hour_idx ) is null 
	    		then (select distinct median_value from d_apacheii_vars where lower(item_cat)='gcs')
	        else locf(pvt_apacheii.gcs) OVER( ORDER BY pvt_apacheii.tw_hour_idx )
	    end gcs,

	    case -- hco3
	    	when locf(pvt_apacheii.hco3) OVER( ORDER BY pvt_apacheii.tw_hour_idx ) is null 
	    		then (select distinct median_value from d_apacheii_vars where lower(item_cat)='hco3')
	        else locf(pvt_apacheii.hco3) OVER( ORDER BY pvt_apacheii.tw_hour_idx )
	    end hco3,

	    case -- hct
	    	when locf(pvt_apacheii.hct) OVER( ORDER BY pvt_apacheii.tw_hour_idx ) is null 
	    		then (select distinct median_value from d_apacheii_vars where lower(item_cat)='hct')
	        else locf(pvt_apacheii.hct) OVER( ORDER BY pvt_apacheii.tw_hour_idx )
	    end hct,

	    case -- hr
	    	when locf(pvt_apacheii.hr) OVER( ORDER BY pvt_apacheii.tw_hour_idx ) is null 
	    		then (select distinct median_value from d_apacheii_vars where lower(item_cat)='hr')
	        else locf(pvt_apacheii.hr) OVER( ORDER BY pvt_apacheii.tw_hour_idx )
	    end hr,

	    case -- paco2
	        when locf(pvt_apacheii.paco2) OVER( ORDER BY pvt_apacheii.tw_hour_idx ) is null 
	            then (select distinct median_value from d_apacheii_vars where lower(item_cat)='paco2')
	        else locf(pvt_apacheii.paco2) OVER( ORDER BY pvt_apacheii.tw_hour_idx )
	    end paco2,

	    case -- pao2
	        when locf(pvt_apacheii.pao2) OVER( ORDER BY pvt_apacheii.tw_hour_idx ) is null 
	            then (select distinct median_value from d_apacheii_vars where lower(item_cat)='pao2')
	        else locf(pvt_apacheii.pao2) OVER( ORDER BY pvt_apacheii.tw_hour_idx )
	    end pao2,

	    case -- potassium
	    	when locf(pvt_apacheii.potassium) OVER( ORDER BY pvt_apacheii.tw_hour_idx ) is null 
	    		then (select distinct median_value from d_apacheii_vars where lower(item_cat)='potassium')
	        else locf(pvt_apacheii.potassium) OVER( ORDER BY pvt_apacheii.tw_hour_idx )
	    end potassium,

	    case -- rr
	    	when locf(pvt_apacheii.rr) OVER( ORDER BY pvt_apacheii.tw_hour_idx ) is null 
	    		then (select distinct median_value from d_apacheii_vars where lower(item_cat)='rr')
	        else locf(pvt_apacheii.rr) OVER( ORDER BY pvt_apacheii.tw_hour_idx )
	    end rr,

	    case -- sodium
	    	when locf(pvt_apacheii.sodium) OVER( ORDER BY pvt_apacheii.tw_hour_idx ) is null 
	    		then (select distinct median_value from d_apacheii_vars where lower(item_cat)='sodium')
	        else locf(pvt_apacheii.sodium) OVER( ORDER BY pvt_apacheii.tw_hour_idx )
	    end sodium,

	    case -- temp
	    	when locf(pvt_apacheii.temp) OVER( ORDER BY pvt_apacheii.tw_hour_idx ) is null 
	    		then (select distinct median_value from d_apacheii_vars where lower(item_cat)='temp')
	        else locf(pvt_apacheii.temp) OVER( ORDER BY pvt_apacheii.tw_hour_idx )
	    end temperature,

	    case -- wbc
	    	when locf(pvt_apacheii.wbc) OVER( ORDER BY pvt_apacheii.tw_hour_idx ) is null 
	    		then (select distinct median_value from d_apacheii_vars where lower(item_cat)='wbc')
	        else locf(pvt_apacheii.wbc) OVER( ORDER BY pvt_apacheii.tw_hour_idx )
	    end wbc
	from (select * from get_pvt_apacheii($1,$2)) pvt_apacheii;

end;
$$ language plpgsql;

-- test code: 
-- select * from get_locf_pvt_apacheii(274671,1)