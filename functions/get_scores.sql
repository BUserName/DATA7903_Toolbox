set search_path to mimic3;

-- delete from scores;
---------------------------------------------------------------
create or replace function get_scores(tw integer, offset_pos integer, limit_num integer) returns void as $$
declare
	icustay_id bigint;
	tw_length int;
	cnt integer;
begin
	cnt:=0;
	tw_length=$1;
	for icustay_id in (select distinct icu.icustay_id from icustays_adults icu order by icu.icustay_id offset $2 limit $3 ) loop
		insert into pt_scores (icustay_id,tw_length,score_cat,tw_hour_idx,score)
		select icustay_id, tw_length, 'APACHEII', tw_hour_idx, total_apacheii_score from get_score_locf_pvt_apacheii(icustay_id,tw_length);

		insert into pt_scores (icustay_id,tw_length,score_cat,tw_hour_idx,score)
		select icustay_id, tw_length, 'SAPSII', tw_hour_idx, total_sapsii_score from get_score_locf_pvt_sapsii(icustay_id,tw_length);

		insert into pt_scores (icustay_id,tw_length,score_cat,tw_hour_idx,score)
		select icustay_id, tw_length, 'SOFA', tw_hour_idx, total_sofa_score from get_score_locf_pvt_sofa(icustay_id,tw_length);
		cnt=cnt+1;
		raise notice '% ICUSTAYS has been done!', cnt;
	end loop;
end;
$$ language plpgsql;

-- select get_scores(0,5000);
---------------------------------------------------------------


/*
select * from get_score_locf_pvt_apacheii(200474,1);
select * from get_score_locf_pvt_sofa(200474,1);
select * from get_score_locf_pvt_sapsii(200474,1);


drop table scores;
create table scores
(
icustay_id bigint,
tw_length integer,
score_cat text,
tw_hour_idx double precision,
score double precision
);

do $$
begin
$icustay_id:=200474;
$score_cat:='APACHEII';
insert into scores ($icustay_id, $score_cat, tw_hour_idx,total_apacheii_score)
select tw_hour_idx, total_apacheii_score from get_score_locf_pvt_apacheii(200474,1);
end $$

delete from scores;
insert into scores (icustay_id,tw_length,score_cat,tw_hour_idx,score)
select 200474, 1, 'APACHEII',tw_hour_idx, total_apacheii_score from get_score_locf_pvt_apacheii(200474,1);

select * from scores;
*/