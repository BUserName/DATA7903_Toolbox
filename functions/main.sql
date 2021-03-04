set search_path to mimic3;
-- different time windows
-- different imputation methods
-- different scoring systems

/*
create table apacheii_scores_tw_1hr
(
	icustay_id integer,
	tw_num integer,
	scores double precision []
)*/

insert into apacheii_scores_tw_1hr values(
(select icustay_id from icustays_adults where icustay_id=274671),
331,
(array(select get_score_locf_pvt_apacheii(274671,1)))
)

select array_length(scores,1) from apacheii_scores_tw_1hr