set search_path to mimic3;

create or replace function get_score_locf_pvt_apacheii(icustay_id bigint, time_window integer)
	returns table (
		tw_hour_idx double precision,
		total_apacheii_score double precision
		) 
as $$
declare
pt_age double precision :=0;
age_points double precision :=0;
chronic_disease_points double precision :=0;
begin
	pt_age := (select pa.pt_age from patients_adults pa where pa.icustay_id=$1);
	
	if pt_age<44 then age_points:=0;
	elsif pt_age<=54 then age_points:=2;
	elsif pt_age<=64 then age_points:=3;
	elsif pt_age<=74 then age_points:=5;
	elsif pt_age>74 then age_points:=6;
	end if;

	if ((select count(*) from diagnoses_icd 
		where icd9_code in ('042', '07953', '79571', 'V08', 'V6544','5728', '5712', '5715', '5716', '20280', '20281', '20282', '20283', '20284', '20285', '20286', '20287', '20288',
				'1960', '1961', '1962', '1963', '1965', '1966', '1968', '1969', '1970', '1971', '1972', '1973', '1974', '1975', '1976', '1977', '1978', '1980', '1981', '1982', '1983', '1984', '1985', '1986', '1987', 
				'19881', '20300', '20301', '20302', '20310', '20311', '20312', '20380', '20381', '20382', '27900', '27901', '27902', '27903', '27904', '27905', '27906', '27909', '27910', '27911', '27912', '27913', 
				'27919', '2792', '2793', '27941', '27949', '27950', '27951', '27952', '27953', '2798', '2799', '5851', '5852', '5853', '5854', '5855', '5856', '5859', '51883', '393', '3940', '3941', '3942', '3949', 
				'3950', '3951', '3952', '3959', '3960', '3961', '3962', '3963', '3968', '3969', '3970', '3971', '3979', '3980', '39890', '39891', '39899', '41400', '41401', '41402', '41403', '41404', '41405', '41406', 
				'41407', '41410', '41411', '41412', '41419', '4142', '4143', '4144', '4148', '4149', '4160', '4161', '4162', '4168', '4169', '40201', '40291', '40401', '40403', '40411', '40413', '40491', '40493', '4280',
				'4281', '42822', '42830', '42832', '42840', '42842', '4289')
		and hadm_id = (select icu.hadm_id from icustays icu where icu.icustay_id=$1))>0) 
		then chronic_disease_points :=5;
	end if;
	
	return query 
		select 	scores_sheet.tw_hour_idx, abp_mean_points + age_points + arterial_ph_points + creatinine_points +
			chronic_disease_points + gcs_points + hco3_points + hct_points + hr_points + oxygenation_points +
			potassium_points + rr_points + sodium_points + temp_points + wbc_points
			as total_apacheii_score from
		(
			select locf_pvt_apachii.tw_hour_idx,				
				case -- ABP_mean Points
					when abp_mean<=49 then 4
					when abp_mean<=69 then 2
					when abp_mean<=109 then 0
					when abp_mean<129 then 2
					when abp_mean<=159 then 3
					when abp_mean>159 then 4 -- (equation >=160)
				end abp_mean_points, 

				case -- Arterial_pH Points
					when arterial_ph<7.15 then 4
					when arterial_ph<=7.24 then 3
					when arterial_ph<=7.32 then 2
					when arterial_ph<=7.49 then 0
					when arterial_ph<=7.59 then 1
					when arterial_ph<=7.69 then 3
					when arterial_ph>7.69 then 4 --(equation >=7.7)
				end arterial_ph_points, 
			
				case -- CREATININE Points
					when creatinine<0.6 then 2
					when creatinine<=1.4 then 0
					when creatinine<=1.9 then 2
					when creatinine<=3.4 then 3
					when creatinine>3.4 then 4 --(equation >=3.5)
				end creatinine_points,

				(15-round(gcs)) as gcs_points, -- GCS Points	 

				case -- HCO3 Points
					when hco3<15 then 4
					when hco3<=17.9 then 3
					when hco3<=21.9 then 2
					when hco3<=31.9 then 0
					when hco3<=40.9 then 1
					when hco3<=51.9 then 3
					when hco3>51.9 then 4 --(equation >=52)
				end hco3_points,

				case -- HCT (Hematocrit) Points
					when hct<20 then 4
					when hct<=29.9 then 2
					when hct<=45.9 then 0
					when hct<=49.9 then 1
					when hct<=59.9 then 2
					when hct>59.9 then 4 --(equation >=60)
				end hct_points,

				case -- HR Points
					when hr<=39 then 4
					when hr<=54 then 3
					when hr<=69 then 2
					when hr<=109 then 0
					when hr<=139 then 2
					when hr<=179 then 3 
					when hr>179 then 4 --(equation >=180)
				end hr_points,

				case -- FiO2
					when (fio2/100>=0.5) and (((713*fio2/100) - (paco2/0.8) -pao2)<200) then 0
					when (fio2/100>=0.5) and (((713*fio2/100) - (paco2/0.8) -pao2)<=349) then 2
					when (fio2/100>=0.5) and (((713*fio2/100) - (paco2/0.8) -pao2)<=499) then 3
					when (fio2/100>=0.5) and (((713*fio2/100) - (paco2/0.8) -pao2)>499) then 4
					when (fio2/100<0.5) and pao2<55 then 4
					when (fio2/100<0.5) and pao2<=60 then 3
					when (fio2/100<0.5) and pao2<=70 then 1
					when (fio2/100<0.5) and pao2>70 then 0
				end oxygenation_points,	

				case -- POTASSIUM Points
					when potassium<2.5 then 4
					when potassium<=2.9 then 2
					when potassium<=3.4 then 1
					when potassium<=5.4 then 0
					when potassium<=5.9 then 1
					when potassium<=6.9 then 3
					when potassium>6.9 then 4 --(equation >=7)
				end potassium_points,

				case -- Resp. Rate Points
					when rr<=5 then 4
					when rr<=9 then 2
					when rr<=11 then 1
					when rr<=24 then 0
					when rr<=34 then 1
					when rr<=49 then 3
					when rr>49 then 4 --(equation >=50)
				end rr_points,

				case -- Sodium Points
					when sodium<=110 then 4
					when sodium<=119 then 3
					when sodium<=129 then 2
					when sodium<=149 then 0
					when sodium<=154 then 1
					when sodium<=159 then 2
					when sodium<=179 then 3
					when sodium>179 then 4 --(equation >=180)
				end sodium_points,

				case -- Temp. Points
					when temperature<=29.9 then 4
					when temperature<=31.9 then 3
					when temperature<=33.9 then 2
					when temperature<=35.9 then 1
					when temperature<=38.4 then 0
					when temperature<=38.9 then 1
					when temperature<=40.9 then 3
					when temperature>40.9 then 4 --(equation >=41)
				end temp_points,

				case -- WBC Points
					when wbc<1 then 4
					when wbc<=2.9 then 2 
					when wbc<=14.9 then 0
					when wbc<=19.9 then 1
					when wbc<=39.9 then 2
					when wbc>39.9 then 4 --(equation >=40)
				end wbc_points	
			from (select * from get_locf_pvt_apacheii($1,$2)) locf_pvt_apachii
		) as scores_sheet;

end;
$$ language plpgsql;


-- select * from get_score_locf_pvt_apacheii(200474,1)