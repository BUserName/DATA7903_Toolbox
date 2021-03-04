set search_path to mimic3;

---------------------------------------------------------------
create or replace function get_subscores() returns void as $$
declare
	icustay_id bigint;
	tw_length integer;
	cnt integer;
begin
	cnt:=0;
	tw_length:=1;
	for icustay_id in (select icu.icustay_id from icustays_adults icu where icu.icustay_id in
						(203143, 207593, 202837, 230435, 283340, 263714, 299410, 267885, 217070, 297822, 296490, 285812, 
					251517, 241173, 250901, 226606, 272069, 294197, 229763, 267000, 228831, 214877, 279533, 227186, 
					234819, 225777, 281933, 279751, 214244, 269612, 231628, 258343, 205721, 275794, 207393, 228140, 
					217315, 220559, 210748, 293738, 260223, 232339, 204194, 272239, 210981, 230529, 242756, 278889, 
					261999, 248284, 273289, 279535, 234725, 204176, 251027, 280112, 246813, 283860, 215908, 226799, 
					286161, 225435, 281894, 225825, 252836, 295669, 238858, 207949, 224515, 231384, 281232, 288701, 
					253638, 229850, 252599, 284719, 213668, 275093, 217082, 235657, 206856, 264919, 290931, 295273, 
					211081, 235554, 256334, 289579, 213339, 295239, 287311, 257336, 246956, 271492, 237812, 256008, 
					246007, 245197, 294193, 220681, 257015, 201559, 204207, 277211, 205413, 289816, 207561, 273137, 
					214189, 218982, 212101, 269805, 201053, 294531, 258962, 253584, 213843, 206497, 296353, 207346, 
					299206, 204841, 254172, 262458, 208161, 244528, 215438, 207606, 299791, 261439, 219047, 270546, 
					226403, 217108, 214485, 273868, 241001, 279678, 247257, 298534, 243390, 256267, 293675, 203573, 
					252668, 201131, 274147, 249403, 274671, 282192, 293299, 231976, 228168, 238126, 206253,
					247980, 233676, 231258, 278741, 246593, 277169, 210815, 274326, 254051, 288468, 245727, 287119, 206842, 217228, 281182, 211975, 227421, 284489, 285710, 288116)
						order by icu.icustay_id) loop
		
		insert into pt_subscores (icustay_id,tw_length,score_cat,tw_hour_idx,
		cardiovascular_scores,
		respiration_score,
		kidney_scores_1,
		nervous_scores,
		liver_scores,
		coagulation_scores,
		kidney_scores_2,
		total_scores)		
		select icustay_id, tw_length, 'SOFA', tw_hour_idx, 
		cardiovascular_points, 
		respiration_points, 
		creatinine_points, 
		gcs_points, 
		bilirubin_points, 
		platelets_points, 
		urine_points,
		total_sofa_score from get_subscores_locf_pvt_sofa(icustay_id,tw_length);
		cnt=cnt+1;
		raise notice '% ICUSTAYS has been done!', cnt;
	end loop;
end;
$$ language plpgsql;

select * from get_subscores()

delete from pt_subscores;


CREATE TABLE mimic3.pt_subscores
(
  icustay_id bigint,
  tw_length integer,
  score_cat text,
  tw_hour_idx double precision,
  cardiovascular_scores double precision,
  respiration_score double precision,
  kidney_scores_1 double precision,
  nervous_scores double precision,
  liver_scores double precision,
  coagulation_scores double precision,
  kidney_scores_2 double precision,
  total_scores double precision
)