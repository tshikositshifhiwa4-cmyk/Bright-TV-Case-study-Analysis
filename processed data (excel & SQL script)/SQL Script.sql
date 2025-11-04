SELECT *
FROM CASE_STUDY_2.BRIGHT_TV.USER_PROFILES

SELECT *
FROM CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP
---------------------------------------------------------------------------------------------------
-- Convert UTC → South African Time (UTC+2)
CREATE OR REPLACE TABLE CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP AS
SELECT
    USERID,
    CHANNEL2,
    RECORDDATE2,
    DURATION2,
    CONVERT_TIMEZONE('UTC', 'Africa/Johannesburg', TO_TIMESTAMP(RecordDate2, 'YYYY/MM/DD HH24:MI')) AS VIEW_TIME_SA
FROM CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP;
---------------------------------------------------------------------------------------------------
--General checks
SELECT MIN (AGE),
       MAX (AGE)
FROM CASE_STUDY_2.BRIGHT_TV.USER_PROFILES

SELECT MIN (VIEW_TIME_SA),
       MAX (VIEW_TIME_SA)
FROM CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP;

SELECT COUNT (*)
FROM CASE_STUDY_2.BRIGHT_TV.USER_PROFILES;

SELECT COUNT (DISTINCT USERID)
FROM CASE_STUDY_2.BRIGHT_TV.USER_PROFILES;

SELECT COUNT (*)
FROM CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP;

SELECT COUNT (DISTINCT USERID)
FROM CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP;

SELECT COUNT (USERID)
FROM CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP;

--Checking duplicate rows
SELECT *,
       COUNT (*)
 FROM CASE_STUDY_2.BRIGHT_TV.USER_PROFILES
 GROUP BY ALL
 HAVING COUNT (*) > 1;

 SELECT *,
       COUNT (*)
FROM CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP
 GROUP BY ALL
 HAVING COUNT (*) > 1;

 -- Daily Active Users
SELECT 
    CAST(VIEW_TIME_SA AS DATE) AS VIEW_DATE,
    COUNT(DISTINCT USERID) AS DAILY_ACTIVE_USERS
FROM CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP
GROUP BY VIEW_DATE
ORDER BY VIEW_DATE;

-- Monthly Active Users
SELECT 
    DATE_TRUNC('MONTH', VIEW_TIME_SA) AS MONTH,
    COUNT(DISTINCT USERID) AS MONTHLY_ACTIVE_USERS
FROM CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP
GROUP BY MONTH
ORDER BY MONTH;

-- Top 10 Channels by Number of Viewings
SELECT 
    CHANNEL2,
    COUNT(*) AS TOTAL_VIEWS
FROM CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP
GROUP BY CHANNEL2
ORDER BY TOTAL_VIEWS DESC
LIMIT 10;
-----------------------------------------------------------------------------------------------------
-- Creating a temporary table with no duplicates as viewership_new

SELECT DISTINCT *
FROM CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP;

CREATE OR REPLACE TEMPORARY TABLE CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP_NEW AS (
    SELECT DISTINCT *
    FROM CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP);

SELECT *, 
    COUNT(*)
FROM CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP_NEW
GROUP BY ALL
HAVING COUNT(*) > 1;

SELECT COUNT(*)
FROM CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP_NEW;
-----------------------------------------------------------------------------------------------------
-- Checking for missing values in the tables

SELECT * 
FROM CASE_STUDY_2.BRIGHT_TV.USER_PROFILES
WHERE USERID IS NULL 
OR NAME IS NULL 
OR SURNAME IS NULL 
OR EMAIL IS NULL 
OR GENDER IS NULL 
OR RACE IS NULL 
OR AGE IS NULL 
OR PROVINCE IS NULL 
OR SOCIAL_MEDIA_HANDLE IS NULL;

SELECT * 
FROM CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP_NEW
WHERE USERID IS NULL 
OR CHANNEL2 IS NULL 
OR RECORDDATE2 IS NULL 
OR DURATION2 IS NULL 
OR VIEW_TIME_SA IS NULL 
--------------------------------------------------------------------------------------------------------------------------------------------
-- Join user demographics AND replace null with None
CREATE OR REPLACE TABLE CASE_STUDY_2.BRIGHT_TV.USER_PROFILES AS
SELECT 
    U.USERID,
    U.AGE,
    V.CHANNEL2,
    V.VIEW_TIME_SA,
    V.DURATION2,
IFNULL(NAME, 'None') AS NAME,
IFNULL(SURNAME, 'None') AS SURNAME,
IFNULL(EMAIL, 'None') AS EMAIL,
IFNULL(GENDER, 'None') AS GENDER,
IFNULL(RACE, 'None') AS RACE,
IFNULL(PROVINCE, 'None') AS PROVINCE,
IFNULL(SOCIAL_MEDIA_HANDLE, 'None') AS SOCIAL_MEDIA_HANDLE,
CASE
    WHEN AGE <18 THEN 'UNDER 18'
    WHEN AGE BETWEEN 18 AND 34 THEN '18–34'
    WHEN AGE BETWEEN 35 AND 54 THEN '35–54'
    ELSE '55+'
END AS AGE_GROUP
FROM CASE_STUDY_2.BRIGHT_TV.USER_PROFILES AS U
INNER JOIN CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP_NEW AS V
ON U.USERID = V.USERID;
--------------------------------------------------------------------------------------------------------------------------------------------
-- Consumption by Gender
SELECT 
    GENDER,
       CASE
        WHEN DURATION2 between '00:00:00' AND '03:00:00' THEN '0 to 3 Hrs'
        WHEN DURATION2 between '03:00:01' AND '06:00:00' THEN '3 to 6 Hrs'
        WHEN DURATION2 between '06:00:01' AND '09:00:00' THEN '6 to 9 Hrs'
        ELSE '9 to 12 Hrs'
    END AS Watch_Duration,
FROM CASE_STUDY_2.BRIGHT_TV.USER_PROFILES
GROUP BY ALL
ORDER BY Watch_Duration DESC;

-- Consumption by Age Group
SELECT 
    CASE 
        WHEN AGE < 18 THEN 'UNDER 18'
        WHEN AGE BETWEEN 18 AND 34 THEN '18–34'
        WHEN AGE BETWEEN 35 AND 54 THEN '35–54'
        ELSE '55+'
    END AS AGE_GROUP,
       CASE
        WHEN DURATION2 between '00:00:00' AND '03:00:00' THEN '0 to 3 Hrs'
        WHEN DURATION2 between '03:00:01' AND '06:00:00' THEN '3 to 6 Hrs'
        WHEN DURATION2 between '06:00:01' AND '09:00:00' THEN '6 to 9 Hrs'
        ELSE '9 to 12 Hrs'
    END AS Watch_Duration,
FROM CASE_STUDY_2.BRIGHT_TV.USER_PROFILES
GROUP BY ALL
ORDER BY Watch_Duration DESC;

-- Consumption by Province
SELECT 
    PROVINCE,
     CASE
        WHEN DURATION2 between '00:00:00' AND '03:00:00' THEN '0 to 3 Hrs'
        WHEN DURATION2 between '03:00:01' AND '06:00:00' THEN '3 to 6 Hrs'
        WHEN DURATION2 between '06:00:01' AND '09:00:00' THEN '6 to 9 Hrs'
        ELSE '9 to 12 Hrs'
    END AS Watch_Duration,
FROM CASE_STUDY_2.BRIGHT_TV.USER_PROFILES
GROUP BY ALL
ORDER BY Watch_Duration DESC;
-------------------------------------------------------------------------------------------------------------------------------------------------

-- Days with lowest total viewing time
SELECT 
    CAST(VIEW_TIME_SA AS DATE) AS DATE,
    CASE
        WHEN DURATION2 between '00:00:00' AND '03:00:00' THEN '0 to 3 Hrs'
        WHEN DURATION2 between '03:00:01' AND '06:00:00' THEN '3 to 6 Hrs'
        WHEN DURATION2 between '06:00:01' AND '09:00:00' THEN '6 to 9 Hrs'
        ELSE '9 to 12 Hrs'
    END AS Watch_Duration,
FROM CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP_NEW
GROUP BY ALL
ORDER BY Watch_Duration ASC
LIMIT 5;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--displaying users who have watched 
SELECT
    u.userid,
    u.Name,
    u.Surname,
    u.Gender,
    u.Race,
    u.Province,
    u.Age_group,
    v.channel2,
    v.duration2,
        CASE
        WHEN v.DURATION2 between '00:00:00' AND '03:00:00' THEN '0 to 3 Hrs'
        WHEN v.DURATION2 between '03:00:01' AND '06:00:00' THEN '3 to 6 Hrs'
        WHEN v.DURATION2 between '06:00:01' AND '09:00:00' THEN '6 to 9 Hrs'
        ELSE '9 to 12 Hrs'
    END AS Watch_Duration,
    DAYNAME(v.VIEW_TIME_SA) AS DAY_OF_WEEK,
    TO_TIME(v.VIEW_TIME_SA) AS TIME, 
    DATE_PART(HOUR, v.VIEW_TIME_SA) AS HOUR_OF_DAY,
    CASE
        WHEN v.duration2 BETWEEN '02:00:00' AND '05:59:59' THEN 'Early Morning'
        WHEN v.duration2 between '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN v.duration2 between '12:00:00' AND '17:59:59' THEN 'Afternoon'
        WHEN v.duration2 between '18:00:00' AND '23:59:59' THEN 'Evening'
        ELSE 'Night'
    END AS Time_Bucket,
    MONTHNAME(v.VIEW_TIME_SA) AS MONTH
FROM CASE_STUDY_2.BRIGHT_TV.USER_PROFILES AS u
INNER JOIN CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP_NEW AS v 
ON u.USERID = v.USERID;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Loyal Users (active multiple months)
SELECT 
    USERID,
    COUNT(DISTINCT DATE_TRUNC('MONTH', VIEW_TIME_SA)) AS ACTIVE_MONTHS
FROM CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP_NEW
GROUP BY USERID
HAVING ACTIVE_MONTHS > 1;

-- Inactive Users (no viewing in past 30 days)
SELECT 
    USERID
FROM CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP_NEW
GROUP BY USERID
HAVING MAX(VIEW_TIME_SA) < DATEADD('DAY', -30, CURRENT_DATE());

-- Display the users and viewership per channel

SELECT
    v.channel2 AS Channel,
    COUNT(u.userid) AS user_count
FROM CASE_STUDY_2.BRIGHT_TV.USER_PROFILES AS u
INNER JOIN CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP_NEW AS v
ON u.userid = v.userid
GROUP BY v.channel2
ORDER BY user_count DESC;

-- Display the count of users and viewership by Day

SELECT
    DAYNAME(v.VIEW_TIME_SA) AS DAY,
    COUNT(v.userid) AS user_count
FROM CASE_STUDY_2.BRIGHT_TV.USER_PROFILES AS u
INNER JOIN CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP_NEW AS v 
ON u.userid = v.userid
GROUP BY 1;

-- Display the count of users and viewership per time of day

SELECT
    CASE
        WHEN v.duration2 BETWEEN '02:00:00' AND '05:59:59' THEN 'Early Morning'
        WHEN v.duration2 between '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN v.duration2 between '12:00:00' AND '17:59:59' THEN 'Afternoon'
        WHEN v.duration2 between '18:00:00' AND '23:59:59' THEN 'Evening'
    END AS Time_Bucket,
    COUNT(u.userid) AS user_count
FROM CASE_STUDY_2.BRIGHT_TV.USER_PROFILES AS u
INNER JOIN CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP_NEW AS v 
ON u.userid = v.userid
GROUP BY 1;
-- Display the users and viewership per province

SELECT
    u.province,
    COUNT(u.userid) AS user_count
FROM CASE_STUDY_2.BRIGHT_TV.USER_PROFILES AS u
INNER JOIN CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP_NEW AS v 
ON u.userid = v.userid
GROUP BY 1
ORDER BY user_count DESC;



-- Display the users and viewership per race

SELECT
    u.race,
    COUNT(u.userid) AS user_count
FROM CASE_STUDY_2.BRIGHT_TV.USER_PROFILES AS u
INNER JOIN CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP_NEW AS v 
ON u.userid = v.userid
GROUP BY 1
ORDER BY user_count DESC;

-- Display the count of users and viewership per age group

SELECT
    Age_group,
    COUNT(v.userid) AS user_count
FROM CASE_STUDY_2.BRIGHT_TV.USER_PROFILES AS u
INNER JOIN CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP_NEW AS v 
ON u.userid = v.userid
GROUP BY 1;

-- Display the count of users and viewership per gender

SELECT
    gender,
    COUNT(v.userid) AS user_count
FROM CASE_STUDY_2.BRIGHT_TV.USER_PROFILES AS u
INNER JOIN CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP_NEW AS v 
ON u.userid = v.userid
GROUP BY 1;

-- Display the count of users and viewership per duration

SELECT
   CASE
        WHEN v.DURATION2 between '00:00:00' AND '03:00:00' THEN '0 to 3 Hrs'
        WHEN v.DURATION2 between '03:00:01' AND '06:00:00' THEN '3 to 6 Hrs'
        WHEN v.DURATION2 between '06:00:01' AND '09:00:00' THEN '6 to 9 Hrs'
        ELSE '9 to 12 Hrs'
    END AS Watch_Duration,
    COUNT(u.userid) AS user_count
FROM CASE_STUDY_2.BRIGHT_TV.USER_PROFILES AS u
INNER JOIN CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP_NEW AS v 
ON u.userid = v.userid
GROUP BY 1;


-- Display the count of users and viewership by month

SELECT
    MONTH(v.VIEW_TIME_SA) AS MONTH,
    COUNT(v.userid) AS user_count
FROM CASE_STUDY_2.BRIGHT_TV.USER_PROFILES AS u
INNER JOIN CASE_STUDY_2.BRIGHT_TV.VIEWERSHIP_NEW AS v 
ON u.userid = v.userid
GROUP BY 1;
-----------------------------------------------------------------------------------------------------
