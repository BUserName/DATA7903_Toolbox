set search_path to mimic3;

create or replace function get_pvt_apacheii(icustay_id bigint, time_window integer)
	returns table (
	TW_hour_idx double precision, 
	ABP_mean double precision,
	Arterial_pH double precision,	
	CREATININE double precision,
	FiO2 double precision,
	GCS double precision,
	HCO3 double precision,
	HCT double precision,
	HR double precision,
	PaCO2 double precision,
	PaO2 double precision,
	POTASSIUM double precision,
	RR double precision,
	SODIUM double precision,
	TEMP double precision,
	WBC double precision
	) 
as $$
declare
	tw_string text;
	qtext text;
	
begin
	tw_string = format('tw_%shr',time_window);
	qtext =format('select %s, itemcat,avg(valuenum)	
	from mv_adults_apacheii_vars_tw where icustay_id=%s and valuenum>=0
	group by %s, itemcat
	order by %s',tw_string,icustay_id, tw_string, tw_string );
	return query select *
	from crosstab(qtext, 'select distinct item_cat from d_apacheii_vars order by item_cat')
	as pvt(
	TW_hour_idx double precision, ABP_mean double precision,	
	Arterial_pH double precision, CREATININE double precision,
	FiO2 double precision,	GCS double precision,
	HCO3 double precision,	HCT double precision,
	HR double precision,	PaCO2 double precision,
	PaO2 double precision,	POTASSIUM double precision,
	RR double precision,	SODIUM double precision,
	TEMP double precision,	WBC double precision);		
end;
$$ language plpgsql;	


--select * from get_pvt_apacheii(274671,1)