set search_path to mimic3;
drop table if exists d_sofa_vars;
-- Table: mimic3.d_sofa_vars

-- DROP TABLE mimic3.d_sofa_vars;

CREATE TABLE mimic3.d_sofa_vars
(
  item_idx integer NOT NULL,
  item_cat text NOT NULL,
  median_value double precision,
  mean_value double precision,
  item_unit text NOT NULL  
);

insert into d_sofa_vars values(1,'ABP_mean',77,79.12687232,'mmHg');
insert into d_sofa_vars values(2,'Bilirubin',0.9,6.379532751,'mg/dl');
insert into d_sofa_vars values(3,'CREATININE',1,1.576054889,'mg/dl');
insert into d_sofa_vars values(4,'Dobutamine',4,5.72484777,'mcg/kg/min');
insert into d_sofa_vars values(5,'Dopamine',3.998375349,4.588829993,'mcg/kg/min');
insert into d_sofa_vars values(6,'Epinephrine',0.020014851,0.078062223,'mcg/kg/min');
insert into d_sofa_vars values(7,'Norepinephrine',0.096969701,0.506031792,'mcg/kg/min');
insert into d_sofa_vars values(8,'FiO2',40.0000006,49.55805475,'%');
insert into d_sofa_vars values(9,'GCS',13,12,'points');
insert into d_sofa_vars values(10,'PaO2',110,134.0670289,'mmHg');
insert into d_sofa_vars values(11,'Platelets',207,233.4090379,'counts');
insert into d_sofa_vars values(12,'Urine',80,127.1269676,'ml');
