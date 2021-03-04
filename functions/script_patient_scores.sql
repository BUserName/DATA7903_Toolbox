set search_path to mimic3;

do $$
declare
	icustay_id bigint;
	tw_length integer := 1;
	cnt integer;
	offset_pos integer := 0;
	limit_num integer :=10000;
begin
	cnt:=0;
	--tw_length:=1;
	for icustay_id in (select distinct icu.icustay_id from icustays_adults icu order by icu.icustay_id limit limit_num offset offset_pos) loop
		insert into pt_scores_1 (icustay_id,tw_length,score_cat,tw_hour_idx,score)
		select icustay_id, tw_length, 'APACHEII', tw_hour_idx, total_apacheii_score from get_score_locf_pvt_apacheii(icustay_id,tw_length);

		insert into pt_scores_1 (icustay_id,tw_length,score_cat,tw_hour_idx,score)
		select icustay_id, tw_length, 'SAPSII', tw_hour_idx, total_sapsii_score from get_score_locf_pvt_sapsii(icustay_id,tw_length);

		insert into pt_scores_1 (icustay_id,tw_length,score_cat,tw_hour_idx,score)
		select icustay_id, tw_length, 'SOFA', tw_hour_idx, total_sofa_score from get_score_locf_pvt_sofa(icustay_id,tw_length);
		cnt=cnt+1;
		raise notice '% ICUSTAYS has been done!', cnt;
	end loop;
end $$;


/*
create table pt_scores_10
(
icustay_id bigint,
tw_length integer,
score_cat text,
tw_hour_idx double precision,
score double precision
);
*/