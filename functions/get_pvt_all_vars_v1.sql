set search_path to mimic3;

create or replace function get_pvt_all_vars(icustay_id bigint, time_window integer)
	returns table (
	TW_hour_idx double precision, 
	ABPd double precision,	ABPm double precision,
	ABPs double precision,	NBPd double precision,
	NBPm double precision,	NBPs double precision,
	PAPd double precision,	PAPm double precision,
	PAPs double precision,	Albumin double precision,
	ALT double precision,	Arterial_pH double precision,
	Phosphorous double precision,	Alkaline_Phosphate double precision,
	Bilirubin double precision,	BUN double precision,
	Calcium double precision,	Calcium_Ionized  double precision,
	Chloride double precision,	Creatinine double precision,
	FiO2 double precision,	GCS double precision,
	Glucose double precision,	HCO3 double precision,
	HCT double precision,	Hemoglobin double precision,
	HR double precision,	Magnesium double precision,
	Mean_Airway_Pressure double precision,	O2_Flow double precision,
	PaCO2 double precision,	PaO2 double precision,
	Platelets double precision,	POTASSIUM double precision,
	PTT double precision,	RR double precision,
	SaO2 double precision,	SODIUM double precision,
	SpO2 double precision,	TCO2 double precision,
	TEMP double precision,	Urine double precision,
	WBC double precision,	Weight double precision
	) 
as $$
declare
	tw_string text;
	qtext text;
	
begin
	tw_string = format('tw_%shr',time_window);
	qtext =format('select %s, itemcat,
		case			
			when itemcat=42 then 
				(select (urine_output_per_24hrs * %s / 24) 
				from mv_adults_daily_urine_outputs mv_urine 
				where mv_urine.icustay_id= %s 
				and tw_24hr = floor(%s * %s / 24) +1)
			else avg(valuenum)	
		end valuenum
	from mv_all_vars_tw where icustay_id=%s and valuenum>0
	group by %s, itemcat
	order by %s',tw_string,time_window,icustay_id,tw_string, time_window, icustay_id, tw_string, tw_string);
	return query select *
	from crosstab(qtext, 'select category from d_all_vars order by category')
	as pvt(
	TW_hour_idx double precision, ABPd double precision,	ABPm double precision,
	ABPs double precision,	NBPd double precision,
	NBPm double precision,	NBPs double precision,
	PAPd double precision,	PAPm double precision,
	PAPs double precision,	Albumin double precision,
	ALT double precision,	Arterial_pH double precision,
	Phosphorous double precision,	Alkaline_Phosphate double precision,
	Bilirubin double precision,	BUN double precision,
	Calcium double precision,	Calcium_Ionized  double precision,
	Chloride double precision,	Creatinine double precision,
	FiO2 double precision,	GCS double precision,
	Glucose double precision,	HCO3 double precision,
	HCT double precision,	Hemoglobin double precision,
	HR double precision,	Magnesium double precision,
	Mean_Airway_Pressure double precision,	O2_Flow double precision,
	PaCO2 double precision,	PaO2 double precision,
	Platelets double precision,	POTASSIUM double precision,
	PTT double precision,	RR double precision,
	SaO2 double precision,	SODIUM double precision,
	SpO2 double precision,	TCO2 double precision,
	TEMP double precision,	Urine double precision,
	WBC double precision,	Weight double precision
	);
end;
$$ language plpgsql;	


-- test code: 
-- select * from get_pvt_all_vars(274671,1)


