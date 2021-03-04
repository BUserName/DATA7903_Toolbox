set search_path to mimic3;

create or replace function get_pvt_sapsii(icustay_id bigint, time_window integer)
	returns table (
	TW_hour_idx double precision, 
	ABP_systolic double precision,
	Bilirubin double precision,
	BUN double precision,
	FiO2 double precision,
	GCS double precision,
	HCO3 double precision,
	HR double precision,
	PaO2 double precision,
	POTASSIUM double precision,
	SODIUM double precision,
	TEMP double precision,
	URINE double precision,
	WBC double precision	
	) 
as $$
declare
	tw_string text;
	qtext text;
	
begin
	tw_string = format('tw_%shr',time_window);
	qtext =format('select %s, lower(itemcat),
		case			
			when lower(itemcat)=''urine'' then 
				(select (urine_output_per_24hrs * %s / 24) 
				from mv_adults_daily_urine_outputs mv_urine 
				where mv_urine.icustay_id= %s 
				and tw_24hr = floor(%s * %s / 24) +1)
			else avg(valuenum)	
		end valuenum
	from mv_adults_sapsii_vars_tw where icustay_id=%s and valuenum>0
	group by %s, itemcat
	order by %s',tw_string,time_window,icustay_id,tw_string, time_window, icustay_id, tw_string, tw_string);
	return query select *
	from crosstab(qtext, 'select lower(item_cat) from d_sapsii_vars order by item_cat')
	as pvt(
	TW_hour_idx double precision, ABP_systolic double precision,
	Bilirubin double precision, BUN double precision,
	FiO2 double precision, GCS double precision,
	HCO3 double precision, HR double precision,
	PaO2 double precision, POTASSIUM double precision,
	SODIUM double precision, TEMP double precision,
	URINE double precision, WBC double precision
	);
end;
$$ language plpgsql;	


--select * from get_pvt_sapsii(274671,1)-- test code: 
-- select * from get_locf_pvt_sapsii(274671,1)

select * from get_pvt_sapsii(274671,1) 