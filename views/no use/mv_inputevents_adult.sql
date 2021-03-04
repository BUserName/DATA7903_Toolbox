-- create view for inputevents_cv and inputevents_mv respectively
-- cv stands for carevue while mv stands for metavision
set search_path to mimic3;
create or replace view inputevents_cv_adults as
select * from inputevents_cv where subject_id in
(select distinct subject_id from patients_adults);

create or replace view inputevents_mv_adults as
select * from inputevents_mv where subject_id in
(select distinct subject_id from patients_adults);