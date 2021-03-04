
set search_path to mimic3;

drop function if exists get_score_locf_pvt_sapsii(icustay_id bigint, time_window integer);

create function get_score_locf_pvt_sapsii(icustay_id bigint, time_window integer)
	returns table (
		tw_hour_idx double precision,
		total_sapsii_score double precision
		)
as $$
declare
pt_age double precision;
age_points double precision;
chronic_disease_points double precision;
begin
	pt_age := (select pa.pt_age from patients_adults pa where pa.icustay_id=$1);
	
	if pt_age<40 then age_points:=0;
	elsif pt_age<=59 then age_points:=7;
	elsif pt_age<=69 then age_points:=12;
	elsif pt_age<=74 then age_points:=15;
	elsif pt_age<80 then age_points:=16;
	elsif pt_age>=80 then age_points:=18;
	end if;

	if (select count(*) 
		from diagnoses_icd 
		where icd9_code in ('042','07953','79571','V08','V6544')	-- HIV or AIDS
		and hadm_id = (select icu.hadm_id from icustays icu where icu.icustay_id=$1))>0 then chronic_disease_points :=17;
	elsif (select count(*) 
			from diagnoses_icd 
			where icd9_code in ('20076', '20200', '20201', '20202', '20203', '20204', '20205', '20206','20207', 
					'20208', '20270', '20271', '20272', '20273', '20274', '20275', '20276', '20277', 
					'20278', '20280', '20281', '20282', '20283', '20284', '20285', '20286', '20287', 
					'20288', '20020', '20021', '20022', '20023', '20024', '20025', '20026', '20027', 
					'20028', '20030', '20031', '20032', '20033', '20034', '20035', '20036', '20037', 
					'20038', '20040', '20041', '20042', '20043', '20044', '20045', '20046', '20047', 
					'20048', '20050', '20051', '20052', '20053', '20054', '20055', '20056', '20057', 
					'20058', '20060', '20061', '20062', '20063', '20064', '20065', '20066', '20067', 
					'20068', '20070', '20071', '20072', '20073', '20074', '20075', '20077', '20078', 
					'20800', '20801', '20802', '20820', '20821', '20822', '20300', '20301', '20302')
			and hadm_id = (select icu.hadm_id from icustays icu where icu.icustay_id=$1))>0 then chronic_disease_points :=10; -- hemat. malig.
	elseif (select count(*) 
			from diagnoses_icd 
			where icd9_code in ('1960', '1961', '1962', '1963', '1965', '1966', '1968', '1969', '1970', 
								'1971', '1972', '1973', '1974', '1975', '1976', '1977', '1978', '1980', 
								'1981', '1982', '1983', '1984', '1985', '1986', '1987', '19881')
			and hadm_id = (select icu.hadm_id from icustays icu where icu.icustay_id=$1))>0 then chronic_disease_points :=9; -- Metastatic Cancer

	else chronic_disease_points:=0;
	end if;
	
	-- raise notice 'patient age: %, age points: %, chronic_disease_points: %', pt_age, age_points, chronic_disease_points;				
	return query 
		select 	scores_sheet.tw_hour_idx, abp_systolic_points + admission_type_points + age_points + 
				bilirubin_points + bun_points + chronic_disease_points + gcs_points + hco3_points + hr_points + 
				respiration_points + potassium_points + sodium_points + temp_points + urine_points + wbc_points
			as total_sapsii_score from
		(
			select locf_pvt_sapsii.tw_hour_idx, locf_pvt_sapsii.temp,
				case -- ABP_Systolic Points
					when abp_systolic < 70 then 13
					when abp_systolic <= 99 then 5
					when abp_systolic < 200 then 0					
					when abp_systolic >= 200 then 2  -- (>=200)					
				end abp_systolic_points, 

				case -- Admission Type Points
					when ((select ad.admission_type from admissions ad where ad.hadm_id in (select icu.hadm_id from icustays_adults icu where icu.icustay_id=$1))='ELECTIVE')
						or ((select ad.admission_type from admissions ad where ad.hadm_id in (select icu.hadm_id from icustays_adults icu where icu.icustay_id=$1))='EMERGENCY')
						then 8
					else 0
				end admission_type_points,

				case -- Bilirubin Points
					when bilirubin<4 then 0					
					when bilirubin<6.0 then 4
					when bilirubin>=6.0 then 9 -- (>=6)					
				end bilirubin_points,					

				case -- BUN Points
					when bun<28 then 0
					when bun<84 then 6
					when bun>=84 then 10 -- (>84)					
				end bun_points,

				case -- GCS Points
					when round(gcs)<6 then 26
					when round(gcs)<=8 then 13
					when round(gcs)<=10 then 7
					when round(gcs)<=13 then 5
					else 0
				end gcs_points,				

				case -- HCO3 Points
					when hco3<15 then 6
					when hco3<20 then 3
					when hco3>=20 then 0 -- (>=20)
				end hco3_points,

				case -- HR Points
					when hr<40 then 11
					when hr<=69 then 2
					when hr<=119 then 0
					when hr<160 then 4
					when hr>=160 then 7 -- (>=160)
				end hr_points,	

				case -- Potassium Points
					when potassium<3 then 3
					when potassium<5.0 then 0
					when potassium>=5.0 then 3 -- (>=5)
				end potassium_points,

				case -- Respiration Points
					when pao2/(fio2/100) <100 then 11
					when pao2/(fio2/100) <200 then 9
					when pao2/(fio2/100) >=200 then 6					
				end respiration_points, 

				case -- Sodium Points
					when sodium<125 then 5
					when sodium<145 then 0
					when sodium>=145 then 1 -- (>=145)
				end sodium_points,				

				case -- Temp. Points
					when locf_pvt_sapsii.temp<39 then 0
					when locf_pvt_sapsii.temp>=39 then 3
				end temp_points,

				case -- Urine Points					
					when urine<(($2*0.5)/24) then 11 -- <500(11)
					when urine<(($2*1)/24) then 4  -- >500 (4)
					when urine>=(($2*1)/24) then 0 -- >1000 (0)
				end urine_points,

				case -- WBC Points
					when wbc<1.0 then 12
					when wbc<20 then 0 
					when wbc>=20 then 3 -- (>=20)
				end wbc_points	
			from (select * from get_locf_pvt_sapsii($1,$2)) locf_pvt_sapsii
		) as scores_sheet;

end;
$$ language plpgsql;

select * from get_score_locf_pvt_sapsii(200474,1)
