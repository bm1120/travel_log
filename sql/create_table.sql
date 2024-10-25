CREATE TABLE tn_traveller_master (
    traveler_id VARCHAR(255) PRIMARY KEY,
    residence_sgg_code VARCHAR(50),
    gender VARCHAR(50),
    age_grp VARCHAR(50),
    edu_nm VARCHAR(50),
    edu_fnsh_se VARCHAR(50),
    marr_stts VARCHAR(50),
    family_memb VARCHAR(255),
    job_nm VARCHAR(100),
    job_etc VARCHAR(50),
    income VARCHAR(50),
    house_income VARCHAR(50),
    travel_term VARCHAR(50),
    travel_num INT,
    travel_like_sido_1 VARCHAR(50),
    travel_like_sgg_1 VARCHAR(50),
    travel_like_sido_2 VARCHAR(50),
    travel_like_sgg_2 VARCHAR(50),
    travel_like_sido_3 VARCHAR(50),
    travel_like_sgg_3 VARCHAR(50),
    travel_styl_1 VARCHAR(50),
    travel_styl_2 VARCHAR(50),
    travel_styl_3 VARCHAR(50),
    travel_styl_4 VARCHAR(50),
    travel_styl_5 VARCHAR(50),
    travel_styl_6 VARCHAR(50),
    travel_styl_7 VARCHAR(50),
    travel_status_residence VARCHAR(50),
    travel_status_destination VARCHAR(50),
    travel_status_accompany VARCHAR(50),
    travel_status_ymd VARCHAR(50),
    travel_motive_1 VARCHAR(50),
    travel_motive_2 VARCHAR(50),
    travel_motive_3 VARCHAR(50),
    travel_companions_num INT
);

CREATE TABLE tn_poi_master (
    poi_id VARCHAR(255) PRIMARY KEY,
    poi_nm VARCHAR(255),
    brno VARCHAR(255),
    sgg_cd VARCHAR(255),
    road_nm_addr VARCHAR(255),
    lotno_addr VARCHAR(255),
    asort_lclasdc VARCHAR(255),
    asort_mlsfcdc VARCHAR(255),
    asort_sdasdc VARCHAR(255),
    x_coord VARCHAR(255),
    y_coord VARCHAR(255),
    road_nm_cd VARCHAR(255),
    lotno_cd VARCHAR(255)
);

CREATE TABLE tn_companion_info (
    companion_seq INT PRIMARY KEY,
    travel_id VARCHAR(50),
    rel_cd VARCHAR(150),
    companion_gender VARCHAR(50),
    companion_age_grp VARCHAR(50),
    companion_situation VARCHAR(50)
);

CREATE TABLE tn_travel (
    travel_id VARCHAR(50) PRIMARY KEY,
    travel_nm VARCHAR(255),
    traveler_id VARCHAR(255),
    travel_purpose VARCHAR(150),
    travel_start_ymd DATE,
    travel_end_ymd DATE,
    mvmn_nm VARCHAR(100),
    travel_persona VARCHAR(150),
    travel_mission VARCHAR(150),
    travel_mission_check CHAR(50)
);

CREATE TABLE tn_move_his (
    trip_id VARCHAR(150) PRIMARY KEY,
    travel_id VARCHAR(50),
    start_visit_area_id VARCHAR(100),
    end_visit_area_id VARCHAR(100),
    start_dt_min TIMESTAMP,
    end_dt_min TIMESTAMP,
    mvmn_cd_1 VARCHAR(255),
    mvmn_cd_2 VARCHAR(255)
);

CREATE TABLE tn_gps_coord (
    mobile_num_id VARCHAR(50) PRIMARY KEY,
    x_coord VARCHAR(20),
    y_coord VARCHAR(20),
    dt_min TIMESTAMP,
    travel_id VARCHAR(50)
);

CREATE TABLE tn_mvmn_consume_his (
    travel_id VARCHAR(50) PRIMARY KEY,
    mvmn_se VARCHAR(150),
    payment_se VARCHAR(150),
    payment_seq INT,
    mvmn_se_nm VARCHAR(255),
    rsvt_yn CHAR(1),
    payment_num INT,
    brno VARCHAR(10),
    store_nm VARCHAR(255),
    payment_dt TIMESTAMP,
    payment_mthd_se VARCHAR(255),
    payment_amt_won INT,
    payment_etc TEXT
);

CREATE TABLE tn_lodge_consume_his (
    travel_id VARCHAR(50) PRIMARY KEY,
    lodging_nm VARCHAR(255),
    lodge_payment_seq INT,
    lodging_type_cd CHAR(10),
    rsvt_yn CHAR(3),
    chk_in_dt_min TIMESTAMP,
    chk_out_dt_min TIMESTAMP,
    payment_num INT,
    brno VARCHAR(10),
    store_nm VARCHAR(255),
    road_nm_addr VARCHAR(255),
    lotno_addr VARCHAR(255),
    road_nm_cd VARCHAR(255),
    lotno_cd VARCHAR(255),
    payment_dt TIMESTAMP,
    payment_mthd_se VARCHAR(255),
    payment_amt_won INT,
    payment_etc TEXT
);

CREATE TABLE tn_activity_his (
    travel_id VARCHAR(50) PRIMARY KEY,
    visit_area_id VARCHAR(150),
    activity_type_cd VARCHAR(150),
    activity_type_seq INT,
    activity_etc VARCHAR(255),
    activity_dtl VARCHAR(400),
    rsvt_yn CHAR(3),
    expnd_se VARCHAR(255),
    admission_se VARCHAR(255)
);

CREATE TABLE tn_adv_consume_his (
    travel_id VARCHAR(50) PRIMARY KEY,
    adv_nm VARCHAR(255),
    adv_seq INT,
    payment_num INT,
    brno VARCHAR(10),
    store_nm VARCHAR(255),
    road_nm_addr VARCHAR(255),
    lotno_addr VARCHAR(255),
    road_nm_cd VARCHAR(255),
    lotno_cd VARCHAR(255),
    payment_dt TIMESTAMP,
    payment_mthd_se VARCHAR(255),
    payment_amt_won INT,
    payment_etc TEXT
);

CREATE TABLE tn_activity_consume_his (
    travel_id VARCHAR(50) PRIMARY KEY,
    visit_area_id VARCHAR(150),
    activity_type_cd VARCHAR(150),
    activity_type_seq INT,
    consume_his_seq INT,
    consume_his_sno INT,
    payment_num INT,
    brno VARCHAR(10),
    store_nm VARCHAR(255),
    road_nm_addr VARCHAR(255),
    lotno_addr VARCHAR(255),
    road_nm_cd VARCHAR(255),
    lotno_cd VARCHAR(255),
    payment_dt TIMESTAMP,
    payment_mthd_se VARCHAR(255),
    payment_amt_won INT,
    payment_etc TEXT
);

CREATE TABLE tn_visit_area_info (
    travel_id VARCHAR(50),
    visit_area_id VARCHAR(150),
    visit_order INT,
    visit_area_nm VARCHAR(255),
    visit_start_ymd DATE,
    visit_end_ymd DATE,
    road_nm_addr VARCHAR(255),
    lotno_addr VARCHAR(255),
    x_coord VARCHAR(255),
    y_coord VARCHAR(255),
    road_nm_cd VARCHAR(255),
    lotno_cd VARCHAR(255),
    poi_id VARCHAR(255),
    poi_nm VARCHAR(255),
    residence_time_min INT,
    visit_area_type_cd VARCHAR(255),
    revisit_yn CHAR(1),
    visit_chc_reason_cd VARCHAR(255),
    lodging_type_cd VARCHAR(255),
    dgstfn VARCHAR(255),
    revisit_intention VARCHAR(255),
    rcmdtn_intention VARCHAR(255),
    sgg_cd VARCHAR(50),
    PRIMARY KEY(travel_id, visit_area_id)
);

CREATE TABLE tn_tour_photo (
    travel_id VARCHAR(50),
    visit_area_id VARCHAR(150),
    tour_photo_seq INT,
    photo_file_id VARCHAR(255),
    photo_file_nm VARCHAR(255),
    photo_file_frmat VARCHAR(50),
    photo_file_dt TIMESTAMP,
    photo_file_save_path VARCHAR(150),
    photo_file_resolution VARCHAR(255),
    photo_file_x_coord VARCHAR(255),
    photo_file_y_coord VARCHAR(255),
    visit_area_nm VARCHAR(255),
    PRIMARY KEY(travel_id, visit_area_id, tour_photo_seq)
);

CREATE TABLE tc_sgg (
    sgg_cd CHAR(50) PRIMARY KEY,
    sgg_cd1 CHAR(10),
    sgg_cd2 CHAR(10),
    sgg_cd3 CHAR(10),
    sgg_cd4 CHAR(10),
    sido_nm VARCHAR(100),
    sgg_nm VARCHAR(100),
    dong_nm VARCHAR(100),
    ri_nm VARCHAR(100)
);

CREATE TABLE tc_codea (
    idx INT PRIMARY KEY,
    cd_a VARCHAR(10),
    cd_nm VARCHAR(255),
    cd_memo VARCHAR(255),
    cd_memo2 VARCHAR(255),
    del_flag CHAR(1),
    order_num INT,
    perm_write ENUM('Y', 'N'),
    perm_edit ENUM('Y', 'N'),
    perm_delete ENUM('Y', 'N'),
    ins_dt TIMESTAMP,
    edit_dt TIMESTAMP
);

CREATE TABLE tc_codeb (
    idx INT PRIMARY KEY,
    cd_a VARCHAR(10),
    cd_b VARCHAR(8),
    cd_nm VARCHAR(255),
    cd_memo VARCHAR(255),
    cd_memo2 VARCHAR(255),
    del_flag CHAR(1),
    order_num INT,
    ins_dt TIMESTAMP,
    edit_dt TIMESTAMP
);

COPY tn_traveller_master(traveler_id, residence_sgg_code, gender, age_grp, edu_nm, edu_fnsh_se, marr_stts, family_memb, job_nm, job_etc, income, house_income, travel_term, travel_num, travel_like_sido_1, travel_like_sgg_1, travel_like_sido_2, travel_like_sgg_2, travel_like_sido_3, travel_like_sgg_3, travel_styl_1, travel_styl_2, travel_styl_3, travel_styl_4, travel_styl_5, travel_styl_6, travel_styl_7, travel_status_residence, travel_status_destination, travel_status_accompany, travel_status_ymd, travel_motive_1, travel_motive_2, travel_motive_3, travel_companions_num)
FROM 'csv_data/tn_traveller_master.csv'
DELIMITER ','
CSV HEADER;

COPY tn_poi_master(poi_id, poi_nm, brno, sgg_cd, road_nm_addr, lotno_addr, asort_lclasdc, asort_mlsfcdc, asort_sdasdc, x_coord, y_coord, road_nm_cd, lotno_cd)
FROM 'csv_data/tn_poi_master.csv'
DELIMITER ','
CSV HEADER;

COPY tn_companion_info(companion_seq, travel_id, rel_cd, companion_gender, companion_age_grp, companion_situation)
FROM 'csv_data/tn_companion_info.csv'
DELIMITER ','
CSV HEADER;

COPY tn_travel(travel_id, travel_nm, traveler_id, travel_purpose, travel_start_ymd, travel_end_ymd, mvmn_nm, travel_persona, travel_mission, travel_mission_check)
FROM 'csv_data/tn_travel.csv'
DELIMITER ','
CSV HEADER;

COPY tn_move_his(trip_id, travel_id, start_visit_area_id, end_visit_area_id, start_dt_min, end_dt_min, mvmn_cd_1, mvmn_cd_2)
FROM 'csv_data/tn_move_his.csv'
DELIMITER ','
CSV HEADER;

COPY tn_gps_coord(mobile_num_id, x_coord, y_coord, dt_min, travel_id)
FROM 'csv_data/tn_gps_coord.csv'
DELIMITER ','
CSV HEADER;

COPY tn_mvmn_consume_his(travel_id, mvmn_se, payment_se, payment_seq, mvmn_se_nm, rsvt_yn, payment_num, brno, store_nm, payment_dt, payment_mthd_se, payment_amt_won, payment_etc)
FROM 'csv_data/tn_mvmn_consume_his.csv'
DELIMITER ','
CSV HEADER;

COPY tn_lodge_consume_his(travel_id, lodging_nm, lodge_payment_seq, lodging_type_cd, rsvt_yn, chk_in_dt_min, chk_out_dt_min, payment_num, brno, store_nm, road_nm_addr, lotno_addr, road_nm_cd, lotno_cd, payment_dt, payment_mthd_se, payment_amt_won, payment_etc)
FROM 'csv_data/tn_lodge_consume_his.csv'
DELIMITER ','
CSV HEADER;

COPY tn_activity_his(travel_id, visit_area_id, activity_type_cd, activity_type_seq, activity_etc, activity_dtl, rsvt_yn, expnd_se, admission_se)
FROM 'csv_data/tn_activity_his.csv'
DELIMITER ','
CSV HEADER;

COPY tn_adv_consume_his(travel_id, adv_nm, adv_seq, payment_num, brno, store_nm, road_nm_addr, lotno_addr, road_nm_cd, lotno_cd, payment_dt, payment_mthd_se, payment_amt_won, payment_etc)
FROM 'csv_data/tn_adv_consume_his.csv'
DELIMITER ','
CSV HEADER;

COPY tn_activity_consume_his(travel_id, visit_area_id, activity_type_cd, activity_type_seq, consume_his_seq, consume_his_sno, payment_num, brno, store_nm, road_nm_addr, lotno_addr, road_nm_cd, lotno_cd, payment_dt, payment_mthd_se, payment_amt_won, payment_etc)
FROM 'csv_data/tn_activity_consume_his.csv'
DELIMITER ','
CSV HEADER;

COPY tn_visit_area_info(travel_id, visit_area_id, visit_order, visit_area_nm, visit_start_ymd, visit_end_ymd, road_nm_addr, lotno_addr, x_coord, y_coord, road_nm_cd, lotno_cd, poi_id, poi_nm, residence_time_min, visit_area_type_cd, revisit_yn, visit_chc_reason_cd, lodging_type_cd, dgstfn, revisit_intention, rcmdtn_intention, sgg_cd)
FROM 'csv_data/tn_visit_area_info.csv'
DELIMITER ','
CSV HEADER;

COPY tn_tour_photo(travel_id, visit_area_id, tour_photo_seq, photo_file_id, photo_file_nm, photo_file_frmat, photo_file_dt, photo_file_save_path, photo_file_resolution, photo_file_x_coord, photo_file_y_coord, visit_area_nm)
FROM 'csv_data/tn_tour_photo.csv'
DELIMITER ','
CSV HEADER;

COPY tc_sgg(sgg_cd, sgg_cd1, sgg_cd2, sgg_cd3, sgg_cd4, sido_nm, sgg_nm, dong_nm, ri_nm)
FROM 'csv_data/tc_sgg.csv'
DELIMITER ','
CSV HEADER;

COPY tc_codea(idx, cd_a, cd_nm, cd_memo, cd_memo2, del_flag, order_num, perm_write, perm_edit, perm_delete, ins_dt, edit_dt)
FROM 'csv_data/tc_codea.csv'
DELIMITER ','
CSV HEADER;

COPY tc_codeb(idx, cd_a, cd_b, cd_nm, cd_memo, cd_memo2, del_flag, order_num, ins_dt, edit_dt)
FROM 'csv_data/tc_codeb.csv'
DELIMITER ','
CSV HEADER;

