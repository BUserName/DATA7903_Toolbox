set search_path to mimic3;

create or replace function pivot_apacheii(icustay_id bigint, time_window integer)
	returns table (
	TW_hour_idx double precision, 
	BUN double precision, 
	CREATININE double precision, 
	GCS double precision,
	GLUCOSE double precision, 
	HCO3 double precision, 
	HCT double precision, 
	HR double precision, 
	POTASSIUM double precision, 
	RR double precision, 
	SODIUM double precision, 
	SYS_BP double precision, 
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
	qtext =format('select %s, itemcat,
	case 
		when itemcat=''URINE'' then sum(valuenum)
		else avg(valuenum)
	end valuenum 
	from mv_adults_apacheii_vars_tw where icustay_id=%s and valuenum>0
	group by icustay_id, %s, itemcat',tw_string,icustay_id, tw_string );
	return query select *
	from crosstab(qtext, 'select distinct item_cat from d_apacheii_vars order by item_cat')
	as pvt(TW_hour_idx double precision, 
	BUN double precision, CREATININE double precision, GCS double precision,
	GLUCOSE double precision, HCO3 double precision, 
	HCT double precision, HR double precision, 
	POTASSIUM double precision, RR double precision, 
	SODIUM double precision, SYS_BP double precision, 
	TEMP double precision, URINE double precision, 
	WBC double precision);		
end;
$$ language plpgsql;	


select * from pivot_apacheii(274671,1)