# 🎬 BrightTV Case Study — Viewership Analytics

## 📖 Project Overview

The BrightTV Case Study focuses on analyzing user and viewership data from BrightTV, a South African entertainment platform. The goal is to uncover trends, patterns, and factors influencing content consumption to help the company expand its subscription base and improve user engagement.
This project uses data analytics and SQL (Snowflake) to transform raw viewership data into actionable business insights, guiding strategic decisions on content programming, marketing, and audience retention.

## 🎯 Objectives

Analyze user and usage trends across demographics and regions.

Identify factors influencing content consumption and engagement.

Determine periods and days of low viewership activity.

Evaluate the most popular channels and content types.

Recommend strategies to increase user growth and content reach.

# 🧩 Dataset Description

## 1️⃣ User Profiles

Contains demographic and social details of BrightTV users.

Column -	Description

UserID -	Unique user identifier

Name, Surname, Email - Basic user info

Gender	- Male, Female, or Not Specified

Race	- Racial classification of the user

Age	- User’s age

Province	- Location within South Africa

Social Media Handle	- User’s social tag

## 2️⃣ Viewership

Captures each viewing session or activity.

Column	- Description

UserID	- Linked to User Profiles

Channel2	- Channel or program watched

RecordDate2	- UTC timestamp of the viewing session

Duration 2	- Length of the session (hh:mm:ss)

## ⚙️ Tools & Technologies

SQL Platform: Snowflake

Data Visualization: Power BI / Excel

Programming Language (optional): Python for data upload automation

File Type: Excel (csv)

Timezone Conversion: UTC → Africa/Johannesburg

## 🧮 Key Analysis Performed

Conversion of UTC timestamps to South African time using CONVERT_TIMEZONE.

Duration transformation from text to minutes using TRY_TO_TIME and DATE_PART.

Calculation of Daily Active Users (DAU) and Monthly Active Users (MAU).

Identification of top-performing channels and genres.

Segmentation of users by age, gender, province, and race.

Detection of low-consumption days and hours.

Insights on viewing behaviour patterns and content preferences.

## 📊 Key Findings

Male viewers (80%) dominate overall engagement.

Black users (51%) represent the largest audience segment.

Highest viewership in Gauteng, Western Cape, and Eastern Cape.

Evening hours (18:00–21:00) and Fridays/weekends record peak activity.

Sports, entertainment, and music channels are the most popular.

Average viewing session is 4–6 minutes, suggesting short-form content preference.

## 💡 Recommendations

Introduce female-oriented and family-friendly content to balance demographics.

Promote regional and local-language shows to appeal to broader audiences.

Focus marketing efforts in urban provinces with digital expansion in lower-performing areas.

Strengthen evening programming and weekend content to capture peak viewership.

Implement personalized recommendations to improve engagement and retention.

## 📈 Business Impact

The findings provide BrightTV with clear, data-backed insights into user preferences and behaviour.

By aligning content strategy with viewer demographics and activity trends, BrightTV can:

Increase average watch time

Boost subscription renewals

Enhance audience satisfaction

Achieve sustainable user growth

# 👩‍💻 Author

 Tshifhiwa Tshikosi

 Data Analyst | Business Intelligence | SQL Developer

 📧 Email: tshikositshifhiwa4@gmail.com

 📍 Location: South Africa, Pretoria
