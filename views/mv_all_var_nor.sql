set search_path to mimic3;
drop materialized view if exists mv_all_vars_nor;
drop table if exists normalisation;
Create table normalisation (itemcat INT, avg double precision, var double precision);
do $$ begin
	for i in 1..44 loop
		insert into normalisation (itemcat, avg, var) select c.itemcat, avg(c.valuenum) as avg, |/(variance(c.valuenum)) as var
		from mv_all_vars c where itemcat = i group by itemcat;
		raise notice 'end temp table %', i ;
	End loop;
end $$;

drop materialized view if exists mv_all_vars_nor;
create materialized view mv_all_vars_nor as
	select c.subject_id, c.hadm_id, c.icustay_id, c.itemcat,
	c.itemid, c.charttime, c.cvalue, c.valuenum, c.valueuom, ((c.valuenum - normalisation.avg)/normalisation.var) as nor
	from mv_all_vars c
	join normalisation on c.itemcat = normalisation.itemcat;

CREATE INDEX mv_all_vars_hadm_id_nor_idx
  ON mimic3.mv_all_vars_nor
  USING btree
  (hadm_id);
CREATE INDEX mv_all_vars_itemcat_nor_idx
  ON mimic3.mv_all_vars_nor
  USING btree
  (itemcat);
CREATE INDEX mv_all_vars_itemid_nor_idx
  ON mimic3.mv_all_vars_nor
  USING btree
  (itemid);
CREATE INDEX mv_all_vars_subject_id_icustay_id_itemcat_nor_idx
  ON mimic3.mv_all_vars_nor
  USING btree
  (subject_id, icustay_id, itemcat);
CREATE INDEX mv_all_vars_subject_id_nor_idx
  ON mimic3.mv_all_vars_nor
  USING btree
  (subject_id);
