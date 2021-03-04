set search_path to mimic3;

create or replace function get_pvt_sofa(icustay_id bigint, time_window integer)
	returns table (
	TW_hour_idx double precision, 
    ABP_mean double precision,
    Bilirubin double precision, 
    CREATININE double precision,
    Dobutamine double precision,
    Dopamine double precision,
    Epinephrine double precision,   
    FiO2 double precision,
    GCS double precision,
    Norepinephrine double precision,
    PaO2 double precision,
    Platelets double precision,
    URINE double precision	
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
				from mimic3.mv_adult_daily_urine_outputs mv_urine 
				where mv_urine.icustay_id= %s 
				and tw_24hr = floor(%s * %s / 24) +1)
			else avg(valuenum)	
		end valuenum
	from mimic3.mv_adult_sofa_vars_tw where icustay_id=%s and valuenum>0
	group by %s, itemcat
	order by %s',tw_string,time_window,icustay_id,tw_string, time_window, icustay_id, tw_string, tw_string);
	return query select *
	from crosstab(qtext, 'select lower(item_cat) from mimic3.d_sofa_vars order by item_cat')
	as pvt(
	TW_hour_idx double precision,     ABP_mean double precision,
    Bilirubin double precision,     CREATININE double precision,
    Dobutamine double precision,    Dopamine double precision,
    Epinephrine double precision,    FiO2 double precision,
    GCS double precision,    Norepinephrine double precision,
    PaO2 double precision,    Platelets double precision,
    URINE double precision	
	);
end;
$$ language plpgsql;	


-- select * from get_pvt_sofa(274671,1)-- test code: 
-- select * from get_locf_pvt_sofa(274671,1)

select * from get_pvt_sofa(274671,1)