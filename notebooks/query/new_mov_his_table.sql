WITH MOV_HIS_RAW AS (
SELECT 
    TRIP_ID                  -- 여행 고유 ID
    ,TRAVEL_ID               -- 여행자 고유 ID
    ,START_VISIT_AREA_ID     -- 출발 지역 ID
    ,END_VISIT_AREA_ID       -- 도착 지역 ID
    ,START_DT_MIN           -- 출발 시간
    ,END_DT_MIN             -- 도착 시간
    ,MVMN_CD_1              -- 첫 번째 이동 수단 코드
    ,MVMN_CD_2              -- 두 번째 이동 수단 코드
    ,LEFT(TRIP_ID, 6) AS TRIP_DATE    -- 여행 날짜
    ,RIGHT(TRIP_ID, 4) AS TRIP_SEQ    -- 여행 순서
FROM TN_MOVE_HIS
)

/* MVMN_CD: 이동 수단 코드-이름 매핑 테이블 */
,MVMN_CD AS (
SELECT CD_B, CD_NM
FROM TC_CODEB
WHERE CD_A='MOV'
)

/* MVMN_HIS: 이동 이력 상세 정보 */
,MVMN_HIS AS(
SELECT 
    TRIP_ID
    ,TRAVEL_ID
    ,START_VISIT_AREA_ID_LAG AS START_VISIT_AREA_ID
    ,END_VISIT_AREA_ID
    ,DT_MIN_LAG AS START_DT_MIN
    ,END_DT_MIN
    ,MVMN_CD_1
    ,MVMN_CD_2
    ,CASE WHEN MVMN_CD_1 IS NOT NULL THEN 1 ELSE 0 END + CASE WHEN MVMN_CD_2 IS NOT NULL THEN 1 ELSE 0 END AS MVMN_CNT
    ,TRIP_DATE
    ,CAST(TRIP_SEQ AS INT)-1 AS VISIT_SEQ 
    
FROM (
SELECT
    TRIP_ID
    ,TRAVEL_ID
    ,START_VISIT_AREA_ID
    ,END_VISIT_AREA_ID
    ,START_DT_MIN
    ,END_DT_MIN
    ,MVMN_CD_1
    ,MVMN_CD_2
    ,TRIP_DATE
    ,TRIP_SEQ
    ,COALESCE(LAG(START_VISIT_AREA_ID, 1) OVER(PARTITION BY TRAVEL_ID ORDER BY TRAVEL_ID, TRIP_ID), LAG(END_VISIT_AREA_ID, 1) OVER(PARTITION BY TRAVEL_ID, TRIP_DATE ORDER BY TRAVEL_ID, TRIP_ID)) AS START_VISIT_AREA_ID_LAG
    ,COALESCE(LAG(START_DT_MIN, 1) OVER(PARTITION BY TRAVEL_ID ORDER BY TRAVEL_ID, TRIP_ID), LAG(END_DT_MIN, 1) OVER(PARTITION BY TRAVEL_ID, TRIP_DATE ORDER BY TRAVEL_ID, TRIP_ID)) AS DT_MIN_LAG
FROM MOV_HIS_RAW
) LAG_TAB
WHERE START_VISIT_AREA_ID_LAG IS NOT NULL
)

/* TRP_CONSUME: 교통비 지출 정보 */
,TRP_CONSUME AS (
SELECT 
    *
FROM 
    TN_MVMN_CONSUME_HIS
WHERE
    PAYMENT_SE='교통비'
)

/* 최종 결과: 이동 이력과 교통비 정보 결합 */
SELECT 
    A.*                      -- 이동 이력 기본 정보
    ,D1.CD_NM AS MVMN_SE_NM_1    -- 첫 번째 이동 수단명
    ,D2.CD_NM AS MVMN_SE_NM_2    -- 두 번째 이동 수단명
    ,B.PAYMENT_AMT_WON           -- 지불 금액(원)
FROM MVMN_HIS A
    LEFT JOIN TRP_CONSUME B
        ON A.TRAVEL_ID = B.TRAVEL_ID
        AND A.MVMN_CD_1 = B.MVMN_SE
    LEFT JOIN TRP_CONSUME C
        ON A.TRAVEL_ID = C.TRAVEL_ID
        AND A.MVMN_CD_2 = C.MVMN_SE
    LEFT JOIN MVMN_CD D1
        ON A.MVMN_CD_1 = D1.CD_B
    LEFT JOIN MVMN_CD D2
        ON A.MVMN_CD_2 = D2.CD_B