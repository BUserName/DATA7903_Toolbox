set search_path to mimic3;
CREATE TABLE mimic3.d_all_vars
(
  category smallint not null,
  label text not null,
  variable_unit text NOT NULL,
  normal_range_low double precision,
  normal_range_high double precision,
  median_value double precision,
  mean_value double precision,
  variance_value double precision 
);

insert into d_all_vars values(1,'BPd','mmHg',0,0,0,0,0);
insert into d_all_vars values(2,'BPm','mmHg',0,0,0,0,0);
insert into d_all_vars values(3,'BPs','mmHg',0,0,0,0,0);
insert into d_all_vars values(4,'Albumin','g/dL',0,0,0,0,0);
insert into d_all_vars values(5,'ALT (Alanine Aminotransferase)','IU/L',0,0,0,0,0);
insert into d_all_vars values(6,'Arterial_pH','units',0,0,0,0,0);
insert into d_all_vars values(7,'Phosphorous','mg/dL',0,0,0,0,0);
insert into d_all_vars values(8,'Alkaline Phosphate','IU/L',0,0,0,0,0);
insert into d_all_vars values(9,'Bilirubin','mg/dL',0,0,0,0,0);
insert into d_all_vars values(10,'BUN','mg/dL',0,0,0,0,0);
insert into d_all_vars values(11,'Calcium','mg/dL',0,0,0,0,0);
insert into d_all_vars values(12,'Calcium-Ionized ','mmol/L',0,0,0,0,0);
insert into d_all_vars values(13,'Chloride','mEq/L',0,0,0,0,0);
insert into d_all_vars values(14,'Creatinine','mg/dL',0,0,0,0,0);
insert into d_all_vars values(15,'CVP','mmHg',0,0,0,0,0);
insert into d_all_vars values(16,'FiO2','%',0,0,0,0,0);
insert into d_all_vars values(17,'GCS','units',0,0,0,0,0);
insert into d_all_vars values(18,'Glucose','mg/dL',0,0,0,0,0);
insert into d_all_vars values(19,'HCO3','mEq/L',0,0,0,0,0);
insert into d_all_vars values(20,'HCT','%',0,0,0,0,0);
insert into d_all_vars values(21,'Hemoglobin','g/dL',0,0,0,0,0);
insert into d_all_vars values(22,'HR','bpm',0,0,0,0,0);
insert into d_all_vars values(23,'INR','units',0,0,0,0,0);
insert into d_all_vars values(24,'Magnesium','mg/dL',0,0,0,0,0);
insert into d_all_vars values(25,'Mean Airway Pressure','cmH2O',0,0,0,0,0);
insert into d_all_vars values(26,'O2 Flow','L/min',0,0,0,0,0);
insert into d_all_vars values(27,'PaCO2','mmHg',0,0,0,0,0);
insert into d_all_vars values(28,'PaO2','mmHg',0,0,0,0,0);
insert into d_all_vars values(29,'Platelets','K/uL',0,0,0,0,0);
insert into d_all_vars values(30,'POTASSIUM','mEq/L',0,0,0,0,0);
insert into d_all_vars values(31,'PT','sec',0,0,0,0,0);
insert into d_all_vars values(32,'PTT','sec',0,0,0,0,0);
insert into d_all_vars values(33,'RR','bpm',0,0,0,0,0);
insert into d_all_vars values(34,'SaO2 (Arterial O2 Saturation)','%',0,0,0,0,0);
insert into d_all_vars values(35,'SODIUM','mEq/L',0,0,0,0,0);
insert into d_all_vars values(36,'SpO2 (O2 saturation pulseoxymetry)','%',0,0,0,0,0);
insert into d_all_vars values(37,'TCO2','mEq/L',0,0,0,0,0);
insert into d_all_vars values(38,'TEMP','C',0,0,0,0,0);
insert into d_all_vars values(39,'Urine','L',0,0,0,0,0);
insert into d_all_vars values(40,'WBC','count',0,0,0,0,0);
insert into d_all_vars values(41,'Weight','kg',0,0,0,0,0);
-- insert into d_all_vars values(45,'Age','',0,0,0,0,0);
-- insert into d_all_vars values(46,'Sex','',0,0,0,0,0);

update d_all_vars set median_value = 59 where category = 1;
update d_all_vars set median_value = 77 where category = 2;
update d_all_vars set median_value = 119 where category = 3;
update d_all_vars set median_value = 2.8 where category = 4;
update d_all_vars set median_value = 42 where category = 5;
update d_all_vars set median_value = 7.39 where category = 6;
update d_all_vars set median_value = 3.4 where category = 7;
update d_all_vars set median_value = 100 where category = 8;
update d_all_vars set median_value = 1.1 where category = 9;
update d_all_vars set median_value = 24 where category = 10;
update d_all_vars set median_value = 8.3 where category = 11;
update d_all_vars set median_value = 1.13 where category = 12;
update d_all_vars set median_value = 105 where category = 13;
update d_all_vars set median_value = 1 where category = 14;
update d_all_vars set median_value = 11 where category = 15;
update d_all_vars set median_value = 40.0000006 where category = 16;
update d_all_vars set median_value = 13 where category = 17;
update d_all_vars set median_value = 127 where category = 18;
update d_all_vars set median_value = 25 where category = 19;
update d_all_vars set median_value = 29.5 where category = 20;
update d_all_vars set median_value = 10 where category = 21;
update d_all_vars set median_value = 86 where category = 22;
update d_all_vars set median_value = 1.3 where category = 23;
update d_all_vars set median_value = 2 where category = 24;
update d_all_vars set median_value = 9.699999809 where category = 25;
update d_all_vars set median_value = 4 where category = 26;
update d_all_vars set median_value = 40 where category = 27;
update d_all_vars set median_value = 110 where category = 28;
update d_all_vars set median_value = 190 where category = 29;
update d_all_vars set median_value = 4 where category = 30;
update d_all_vars set median_value = 14.5 where category = 31;
update d_all_vars set median_value = 34.7 where category = 32;
update d_all_vars set median_value = 19 where category = 33;
update d_all_vars set median_value = 97 where category = 34;
update d_all_vars set median_value = 138 where category = 35;
update d_all_vars set median_value = 98 where category = 36;
update d_all_vars set median_value = 25 where category = 37;
update d_all_vars set median_value = 37 where category = 38;
update d_all_vars set median_value = 0.08 where category = 39;
update d_all_vars set median_value = 10.9 where category = 40;
update d_all_vars set median_value = 81.5 where category = 41;
