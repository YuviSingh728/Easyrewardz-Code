
###########################KPI Regional wise##################


WITH 
New_Enrol AS (
    SELECT 
        b.region AS KPI,
        COUNT(DISTINCT a.mobile) AS `New Enrolment`
    FROM member_report a
    LEFT JOIN store_master b ON a.enrolledstorecode = b.storecode
    WHERE a.modifiedenrolledon BETWEEN '2025-10-01' AND '2025-10-31'
    GROUP BY b.region
),
Sku AS (
    SELECT 
        b.region AS KPI,
        COUNT(DISTINCT txnmappedmobile) AS `Total Transacting Customers`,
        SUM(itemnetamount) / COUNT(DISTINCT uniquebillno) AS ABV,
        COUNT(DISTINCT CASE WHEN frequencycount > 1 THEN txnmappedmobile END) AS Repeaters,
        COUNT(DISTINCT CASE WHEN dayssincelastvisit <= 365 THEN txnmappedmobile END) AS `Transactors active for one year`,
        COUNT(DISTINCT CASE WHEN dayssincelastvisit > 366 AND dayssincelastvisit <= 545 THEN txnmappedmobile END) AS `Transactors from Dormant base`,  COUNT(DISTINCT CASE WHEN dayssincelastvisit > 730 THEN txnmappedmobile END) AS `Win Back Customers`,
        COUNT(DISTINCT uniquebillno) AS `Total Transaction`
    FROM sku_report_loyalty a
    LEFT JOIN store_master b ON a.modifiedstorecode = b.storecode
    WHERE a.modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31'
    GROUP BY b.region
),
New_Txn AS (
    SELECT 
        b.region AS KPI,
        COUNT(DISTINCT a.txnmappedmobile) AS `Newly Enrolled and Transacted`
    FROM sku_report_loyalty a
    LEFT JOIN store_master b ON a.modifiedstorecode = b.storecode
    LEFT JOIN member_report c ON a.txnmappedmobile = c.mobile
    WHERE a.modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31'
      AND c.modifiedenrolledon BETWEEN '2025-10-01' AND '2025-10-31'
    GROUP BY b.region
),
All_Regions AS (
    SELECT DISTINCT KPI FROM New_Enrol
    UNION
    SELECT DISTINCT KPI FROM Sku
    UNION
    SELECT DISTINCT KPI FROM New_Txn
)
 
SELECT 
    r.KPI,
    COALESCE(ne.`New Enrolment`, 0) AS `New Enrolment`,
    COALESCE(s.`Total Transacting Customers`, 0) AS `Total Transacting Customers`,
    COALESCE(s.ABV, 0) AS ABV,
    COALESCE(nt.`Newly Enrolled and Transacted`, 0) AS `Newly Enrolled and Transacted`,
    COALESCE(s.Repeaters, 0) AS Repeaters,
    COALESCE(s.`Transactors active for one year`, 0) AS `Transactors active for one year`,
    COALESCE(s.`Transactors from Dormant base`, 0) AS `Transactors from Dormant base`,
    COALESCE(s.`Win Back Customers`, 0) AS `Win Back Customers`,
    COALESCE(s.`Total Transaction`, 0) AS `Total Transaction`
FROM All_Regions r
LEFT JOIN New_Enrol ne ON COALESCE(r.KPI, 'ZZZ_NULL') = COALESCE(ne.KPI, 'ZZZ_NULL')
LEFT JOIN Sku s ON COALESCE(r.KPI, 'ZZZ_NULL') = COALESCE(s.KPI, 'ZZZ_NULL')
LEFT JOIN New_Txn nt ON COALESCE(r.KPI, 'ZZZ_NULL') = COALESCE(nt.KPI, 'ZZZ_NULL')
ORDER BY r.KPI;


###########################KPI Regional wise Pev Yr##################


WITH 
New_Enrol AS (
    SELECT 
        b.region AS KPI,
        COUNT(DISTINCT a.mobile) AS `New Enrolment`
    FROM member_report a
    LEFT JOIN store_master b ON a.enrolledstorecode = b.storecode
    WHERE a.modifiedenrolledon BETWEEN '2024-10-01' AND '2024-10-31'
    GROUP BY b.region
),
Sku AS (
    SELECT 
        b.region AS KPI,
        COUNT(DISTINCT txnmappedmobile) AS `Total Transacting Customers`,
        SUM(itemnetamount) / COUNT(DISTINCT uniquebillno) AS ABV,
        COUNT(DISTINCT CASE WHEN frequencycount > 1 THEN txnmappedmobile END) AS Repeaters,
        COUNT(DISTINCT CASE WHEN dayssincelastvisit <= 365 THEN txnmappedmobile END) AS `Transactors active for one year`,
        COUNT(DISTINCT CASE WHEN dayssincelastvisit > 366 AND dayssincelastvisit <= 545 THEN txnmappedmobile END) AS `Transactors from Dormant base`,  COUNT(DISTINCT CASE WHEN dayssincelastvisit > 730 THEN txnmappedmobile END) AS `Win Back Customers`,
        COUNT(DISTINCT uniquebillno) AS `Total Transaction`
    FROM sku_report_loyalty a
    LEFT JOIN store_master b ON a.modifiedstorecode = b.storecode
    WHERE a.modifiedtxndate BETWEEN '2024-10-01' AND '2024-10-31'
    GROUP BY b.region
),
New_Txn AS (
    SELECT 
        b.region AS KPI,
        COUNT(DISTINCT a.txnmappedmobile) AS `Newly Enrolled and Transacted`
    FROM sku_report_loyalty a
    LEFT JOIN store_master b ON a.modifiedstorecode = b.storecode
    LEFT JOIN member_report c ON a.txnmappedmobile = c.mobile
    WHERE a.modifiedtxndate BETWEEN '2024-10-01' AND '2024-10-31'
      AND c.modifiedenrolledon BETWEEN '2024-10-01' AND '2024-10-31'
    GROUP BY b.region
),
All_Regions AS (
    SELECT DISTINCT KPI FROM New_Enrol
    UNION
    SELECT DISTINCT KPI FROM Sku
    UNION
    SELECT DISTINCT KPI FROM New_Txn
)
 
SELECT 
    r.KPI,
    COALESCE(ne.`New Enrolment`, 0) AS `New Enrolment`,
    COALESCE(s.`Total Transacting Customers`, 0) AS `Total Transacting Customers`,
    COALESCE(s.ABV, 0) AS ABV,
    COALESCE(nt.`Newly Enrolled and Transacted`, 0) AS `Newly Enrolled and Transacted`,
    COALESCE(s.Repeaters, 0) AS Repeaters,
    COALESCE(s.`Transactors active for one year`, 0) AS `Transactors active for one year`,
    COALESCE(s.`Transactors from Dormant base`, 0) AS `Transactors from Dormant base`,
    COALESCE(s.`Win Back Customers`, 0) AS `Win Back Customers`,
    COALESCE(s.`Total Transaction`, 0) AS `Total Transaction`
FROM All_Regions r
LEFT JOIN New_Enrol ne ON COALESCE(r.KPI, 'ZZZ_NULL') = COALESCE(ne.KPI, 'ZZZ_NULL')
LEFT JOIN Sku s ON COALESCE(r.KPI, 'ZZZ_NULL') = COALESCE(s.KPI, 'ZZZ_NULL')
LEFT JOIN New_Txn nt ON COALESCE(r.KPI, 'ZZZ_NULL') = COALESCE(nt.KPI, 'ZZZ_NULL')
ORDER BY r.KPI;

#################################Region MoM Data #########################

SELECT 
CONCAT(MONTH(a.modifiedtxndate), '/', RIGHT(YEAR(a.modifiedtxndate), 2)) AS MONTH,
c.region AS Region,
COUNT(DISTINCT a.txnmappedmobile) AS cust
FROM sku_report_loyalty a
JOIN Member_report b
       ON a.txnmappedmobile = b.mobile
JOIN store_master c
     ON a.modifiedstorecode = c.storecode
WHERE YEAR(a.modifiedtxndate) =YEAR(modifiedenrolledon) AND 
MONTH(a.modifiedtxndate) =MONTH(modifiedenrolledon)
  AND modifiedenrolledon BETWEEN '2024-11-01' AND '2025-10-31'
GROUP BY MONTH, c.region
ORDER BY MIN(a.modifiedtxndate);

##################################Winback Trend####################

SELECT CONCAT(MONTH(modifiedtxndate),"-",RIGHT(YEAR(modifiedtxndate),2))AS MONTH,
COUNT(DISTINCT txnmappedmobile) AS customers,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS repeaters,
COUNT(DISTINCT CASE WHEN dayssincelastvisit>730 THEN txnmappedmobile END) AS winback_customers
FROM sku_report_loyalty a
WHERE modifiedtxndate BETWEEN '2024-11-01' AND '2025-10-31'
GROUP BY 1
ORDER BY modifiedtxndate;

############################Winback Recency Rate#########################
 
SELECT 
    CASE 
        WHEN dayssincelastvisit > 730 AND dayssincelastvisit <= 820 THEN '730-820'
        WHEN dayssincelastvisit > 820 AND dayssincelastvisit <= 910 THEN '820-910'
        WHEN dayssincelastvisit > 910 AND dayssincelastvisit <= 1000 THEN '910-1000'
        WHEN dayssincelastvisit > 1000 AND dayssincelastvisit <= 1200 THEN '1000-1200'
        WHEN dayssincelastvisit > 1200 AND dayssincelastvisit <= 1500 THEN '1200-1500'
        WHEN dayssincelastvisit > 1500 AND dayssincelastvisit <= 2000 THEN '1500-2000'
        WHEN dayssincelastvisit > 2000 THEN '2000+'
    END AS recency,
    COUNT(DISTINCT CASE WHEN modifiedtxndate <= '2025-10-31' THEN txnmappedmobile END) AS base,
    COUNT(DISTINCT CASE WHEN modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31' THEN txnmappedmobile END) AS transactors
FROM `killersignatureclub`.sku_report_loyalty
GROUP BY 1
ORDER BY dayssincelastvisit;

##############################Winback Recency####################

SELECT CONCAT(MONTH(modifiedtxndate),"-",RIGHT(YEAR(modifiedtxndate),2))AS MONTH,
CASE 
WHEN dayssincelastvisit>730 AND dayssincelastvisit<=820 THEN '730-820'
WHEN dayssincelastvisit>820 AND dayssincelastvisit<=910 THEN '820-910'
WHEN dayssincelastvisit>910 AND dayssincelastvisit<=1000 THEN '910-1000'
WHEN dayssincelastvisit>1000 AND dayssincelastvisit<=1200 THEN '1000-1200'
WHEN dayssincelastvisit>1200 AND dayssincelastvisit<=1500 THEN '1200-1500'
WHEN dayssincelastvisit>1500 AND dayssincelastvisit<=2000 THEN '1500-2000'
WHEN dayssincelastvisit>2000 THEN '>2000' END AS 'recency',
COUNT(DISTINCT txnmappedmobile) AS customers
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-11-01' AND '2025-10-31'
GROUP BY 1,2;

###############################Repeat Cohort#####################

CREATE TABLE dummy.Umesh_Cohort_Oct_25_
SELECT txnmappedmobile,MIN(modifiedtxndate)FirstDate
FROM sku_report_loyalty a
WHERE modifiedtxndate<='2025-10-31' 
GROUP BY 1 ;#1271335
 

INSERT INTO dummy.Umesh_Cohort__24_25
SELECT * FROM dummy.Umesh_Cohort_Oct_25_ 
WHERE FirstDate BETWEEN '2024-11-01' AND '2025-10-31';#354467
 
ALTER TABLE dummy.Umesh_Cohort__24_25 ADD INDEX txnmappedmobile(txnmappedmobile);
 
 
SELECT YEAR(a.firstdate)first_year,MONTH(a.FirstDate)`first_month`,YEAR(b.modifiedtxndate)second_year,
MONTH(b.modifiedtxndate)second_month,COUNT(DISTINCT a.txnmappedmobile)customers
FROM dummy.Umesh_Cohort__24_25 a JOIN sku_report_loyalty  b
ON a.txnmappedmobile=b.txnmappedmobile
WHERE b.modifiedtxndate<='2025-10-31'
GROUP BY 1,2,3,4;

###########################Product Landscape#####################

SELECT categoryname sub_category,SUM(itemnetamount) AS sales,SUM(itemqty) AS qty,
COUNT(DISTINCT txnmappedmobile) AS customers
FROM sku_report_loyalty a
JOIN item_master b
ON a.uniqueitemcode=b.uniqueitemcode
WHERE modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31'
GROUP BY 1; 

###############################Customer Overview##################

WITH Sku AS (
    SELECT 
        txnmappedmobile,
        DATEDIFF('2025-10-31', MAX(modifiedtxndate)) AS recency,
        SUM(itemnetamount) AS sales,
        COUNT(DISTINCT uniquebillno) AS bils
    FROM sku_report_loyalty
    WHERE modifiedtxndate <= '2025-10-31'
    GROUP BY txnmappedmobile
),

Txn AS (
    SELECT 
        mobile,
        SUM(pointscollected) AS points_accrual,
        SUM(CASE WHEN pointsspent > 0 THEN pointsspent END) AS points_redeemed,
        SUM(CASE WHEN pointsspent > 0 THEN amount END) AS redemption_sales
    FROM txn_report_accrual_redemption
    WHERE txndate <= '2025-10-31'
    GROUP BY mobile
)

SELECT 
    CASE
        WHEN a.recency <= 365 THEN 'active'
        WHEN a.recency >= 366 AND a.recency <= 730 THEN 'dormant'
        WHEN a.recency > 730 THEN 'lapsed'
    END AS tag,
    
    COUNT(DISTINCT a.txnmappedmobile) AS customers,
    SUM(a.sales) AS sales,
    SUM(a.bils) AS bils,
    SUM(b.points_accrual) AS point_accrual,
    SUM(b.points_redeemed) AS points_redeemed,
    SUM(b.redemption_sales) AS redemption_sales,
    SUM(a.sales) / SUM(a.bils) AS abv,
    AVG(a.recency) AS avg_recency

FROM Sku a
LEFT JOIN Txn b ON a.txnmappedmobile = b.mobile
GROUP BY tag;

#############################lc_migration#########################

 WITH Old_Recency AS(
 SELECT txnmappedmobile,DATEDIFF('2024-10-31',MAX(modifiedtxndate)) AS Old_Recency
 FROM sku_report_loyalty
 WHERE modifiedtxndate<='2024-10-31'
 GROUP BY 1
 ),
 
 New_Recency AS(
 SELECT txnmappedmobile,DATEDIFF('2025-10-31',MAX(modifiedtxndate)) AS New_Recency
 FROM sku_report_loyalty
 WHERE modifiedtxndate<='2025-10-31'
 GROUP BY 1
 )
 
 SELECT 
	CASE 
		WHEN Old_Recency<=365 THEN 'Active'
		WHEN Old_Recency>=366 AND Old_Recency<=730 THEN 'Dormant'
		WHEN Old_Recency>730 THEN 'Lapsed'
		END AS 'old_recency',
	CASE 
		WHEN new_recency<=365 THEN 'Active'
		WHEN new_recency>=366 AND new_recency<=730 THEN 'Dormant'
		WHEN new_recency>730 THEN 'Lapsed'
		END AS 'new_recency',
COUNT(DISTINCT txnmappedmobile) AS customers
FROM old_recency a
JOIN new_recency b
USING(txnmappedmobile)
GROUP BY 1,2;

############################Bill Banding##########################

SELECT 
	CASE 
		WHEN `Mapped Sales`>0 AND `Mapped Sales`<=2500 THEN '0-2500'
		WHEN `Mapped Sales`>2501 AND `Mapped Sales`<=5000 THEN '2501-5000'
		WHEN `Mapped Sales`>5001 AND `Mapped Sales`<=7500 THEN '5001-7500'
		WHEN `Mapped Sales`>7501 AND `Mapped Sales`<=10000 THEN '7501-10000'
		WHEN `Mapped Sales`>10001 AND `Mapped Sales`<=12500 THEN '10001-12500'
		WHEN `Mapped Sales`>12500 THEN '12500+' END AS Overall,
SUM(Customers) AS Customers,SUM(`Mapped Sales`) AS `Mapped Sales`,
SUM(`Repeat Sales`)AS `Repeat Sales`,
SUM(`Mapped Transactions`) AS `Mapped Transactions`,SUM(`Mapped bills`) AS `Mapped bills`,
SUM(`Repeat transactions`) AS `Repeat transactions`
FROM
(SELECT txnmappedmobile,Frequencycount,COUNT(DISTINCT txnmappedmobile) AS Customers,SUM(itemnetamount) AS `Mapped Sales`,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END)AS `Repeat Sales`,
COUNT(DISTINCT uniquebillno) AS `Mapped Transactions`,COUNT(DISTINCT uniquebillno) AS `Mapped bills`,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END) AS `Repeat transactions`
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-11-01' AND '2025-10-31' #and itemnetamount>0
GROUP BY 1)a
GROUP BY 1;

###################################ro_Overall###############################

WITH points AS(
SELECT 'overall'kpis,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END) AS Redeemers,
SUM(CASE WHEN a.pointscollected>0 THEN a.pointscollected END) AS `Points Issued`,
SUM(CASE WHEN a.pointsspent>0 THEN a.pointsspent END) AS `Points Redeemed`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN uniquebillno END) AS `Redemption Bills`,
SUM(CASE WHEN a.pointsspent>0 THEN amount END) AS `Redemption Sales`,
SUM(CASE WHEN a.pointsspent>0 THEN amount END)/
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN uniquebillno END) AS `Redemption ABV`,
SUM(CASE WHEN a.pointscollected>0 THEN a.pointscollected END)/
SUM(CASE WHEN a.pointsspent>0 THEN a.pointsspent END) AS `Earn Burn Ratio`,
SUM(CASE WHEN a.pointsspent>0 THEN a.amount END )/
SUM(CASE WHEN a.pointsspent>0 THEN a.pointsspent END ) AS `Extra Sales per Point Redeemed`
FROM txn_report_accrual_redemption a 
WHERE a.txndate BETWEEN '2025-10-01' AND '2025-10-31'
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%test%'AND modifiedbillno NOT LIKE '%roll%'),

lapse AS(
SELECT 'overall'kpis,
SUM(pointslapsed) AS `Points Expired`
FROM lapse_report
WHERE lapsingdate BETWEEN '2025-10-01' AND '2025-10-31')

SELECT kpis,
Redeemers,`Points Issued`,`Points Redeemed`,`Points Expired`,`Redemption Bills`,`Redemption Sales`,
`Redemption ABV`,`Earn Burn Ratio`,`Extra Sales per Point Redeemed`
FROM points a
JOIN lapse b USING(kpis);


###########################Ro YOY ##########################

 SELECT 
   CONCAT(LEFT(MONTHNAME(Txndate),3))yoy,
    SUM(CASE WHEN YEAR(txndate) = 2025 THEN pointscollected END)'points_issued_ty',
    SUM(CASE WHEN YEAR(txndate) = 2024 THEN pointscollected END)'points_issued_ly',
    
    SUM(CASE WHEN YEAR(txndate) = 2025 THEN pointsspent END)'points_redeemed_ty',
    SUM(CASE WHEN YEAR(txndate) = 2024 THEN pointsspent END)'points_redeemed_ly'
    FROM  txn_report_accrual_redemption
    WHERE ((txndate BETWEEN '2024-01-01' AND '2024-12-31')OR (txndate BETWEEN '2025-01-01' AND '2025-12-31'))
    AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%test%'AND modifiedbillno NOT LIKE '%roll%'
    GROUP BY 1 
    ORDER BY txndate;


########################KPI snapshot store type######################

WITH Oevrall AS(
SELECT 'Overall' KPIs,
COUNT(DISTINCT modifiedstorecode) AS Stores,COUNT(DISTINCT txnmappedmobile) AS `Total Transacting Customers`,
SUM(itemnetamount) AS `Loyalty Sales`,COUNT(DISTINCT uniquebillno) AS `Loyalty Bills`,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS `Repeat Customers`,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS `Existing Repeaters`,
COUNT(DISTINCT CASE WHEN dayssincelastvisit<=365 THEN txnmappedmobile END) AS `Active Repeaters`,
COUNT(DISTINCT CASE WHEN dayssincelastvisit>366 AND dayssincelastvisit<=730 THEN txnmappedmobile END) AS `Transactors from Dormant Segment - Churn Prevention`,COUNT(DISTINCT CASE WHEN dayssincelastvisit>730 THEN txnmappedmobile END) AS `WinBack Customers`,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS `Repeaters`,
SUM(CASE WHEN dayssincelastvisit>730 THEN itemnetamount END) AS `WinBack Customers Sales`,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS `Repeat Customers Sales`,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS `Existing Repeaters Sales`,
SUM(CASE WHEN dayssincelastvisit<=365 THEN itemnetamount END) AS `Active Repeaters Sales`,
SUM(CASE WHEN dayssincelastvisit>366 AND dayssincelastvisit<=730 THEN itemnetamount END) AS `Transactors from Dormant Segment - Churn Prevention Sales`,SUM(itemqty) AS Quantity
FROM sku_report_loyalty
WHERE modifiedtxndate<='2025-10-31'
GROUP BY 1
),

Enroll AS(
SELECT 'Overall' KPIs,COUNT(DISTINCT mobile) AS Enrollments FROM member_report
WHERE modifiedenrolledon<='2025-10-31'
),

New_Txn AS(
SELECT 'Overall' KPIs,COUNT(DISTINCT txnmappedmobile) AS `Newly Enrolled and Transacted`,
SUM(itemnetamount) AS `Newly Enrolled and Transacted Sales` FROM sku_report_loyalty a
 JOIN store_master b ON a.modifiedstorecode=b.storecode
 WHERE modifiedtxndate<='2025-10-31' AND txnmappedmobile IN
 (SELECT DISTINCT mobile FROM member_report
 WHERE modifiedtxndate<='2025-10-31')
 ),

New_Repeat AS(
SELECT 'Overall' KPIs,COUNT(DISTINCT CASE WHEN min_f=1 AND max_f>1 THEN txnmappedmobile END) AS `New to Repeat`,
SUM(CASE WHEN min_f=1 AND max_f>1 THEN itemnetamount END) AS `New to Repeat Sales`
FROM
(SELECT txnmappedmobile,itemnetamount,MIN(frequencycount)Min_f,MAX(frequencycount)Max_f
FROM sku_report_loyalty
WHERE modifiedtxndate<='2025-10-31'
GROUP BY 1)a
GROUP BY 1
),

Points AS(
SELECT 'Overall' KPIs,
SUM(pointscollected) AS `Total Points Issued`,
SUM(CASE WHEN pointsspent>0 THEN pointsspent END) AS `Points Redeemed`,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) AS `Redeemer`,
SUM(CASE WHEN pointsspent>0 THEN amount END) AS `Redeemers sales`,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END) AS `Redemers bills`
FROM txn_report_accrual_redemption
WHERE txndate<='2025-10-31'
),

NonLoyalty AS(
SELECT 
'Overall' KPIs,SUM(itemnetamount) AS nonloyalty
FROM sku_report_nonloyalty
WHERE modifiedtxndate<='2025-10-31'
),
overall_finale AS (
SELECT KPIs,Stores,`Total Transacting Customers`,`Loyalty Sales`,`Loyalty Bills`,Enrollments,`Newly Enrolled and Transacted`,
`Repeat Customers`,`New to Repeat`,`Existing Repeaters`,`Active Repeaters`,`Transactors from Dormant Segment - Churn Prevention`,
`WinBack Customers`,`Repeaters`,`WinBack Customers Sales`,`Newly Enrolled and Transacted Sales`,`Repeat Customers Sales`,
`New to Repeat Sales`,`Existing Repeaters Sales`,`Active Repeaters Sales`,`Transactors from Dormant Segment - Churn Prevention Sales`,
`Total Points Issued`,`Points Redeemed`,`Redeemer`,`Redeemers sales`,`Redemers bills`,Quantity,(`Loyalty Sales`+nonloyalty) AS `Total Sales`
FROM Oevrall a
JOIN Enroll b USING(KPIs)
JOIN New_Txn c USING(KPIs)
JOIN New_Repeat d USING(KPIs)
JOIN Points e USING(KPIs)
JOIN Nonloyalty f USING(KPIs)),





Months_wise AS(
SELECT 
	CASE 
		WHEN modifiedtxndate>='2024-10-01' AND modifiedtxndate<='2024-10-31' THEN 'curr_mn_prev_yr'
		WHEN modifiedtxndate>='2025-09-01' AND modifiedtxndate<='2025-09-30' THEN 'prev_mn_curr_yr'
		WHEN modifiedtxndate>='2025-10-01' AND modifiedtxndate<='2025-10-31' THEN 'curr_mn_curr_yr'
		END AS 'KPIs',
COUNT(DISTINCT modifiedstorecode) AS Stores,COUNT(DISTINCT txnmappedmobile) AS `Total Transacting Customers`,
SUM(itemnetamount) AS `Loyalty Sales`,COUNT(DISTINCT uniquebillno) AS `Loyalty Bills`,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS `Repeat Customers`,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS `Existing Repeaters`,
COUNT(DISTINCT CASE WHEN dayssincelastvisit<=365 THEN txnmappedmobile END) AS `Active Repeaters`,
COUNT(DISTINCT CASE WHEN dayssincelastvisit>366 AND dayssincelastvisit<=730 THEN txnmappedmobile END) AS `Transactors from Dormant Segment - Churn Prevention`,COUNT(DISTINCT CASE WHEN dayssincelastvisit>730 THEN txnmappedmobile END) AS `WinBack Customers`,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS `Repeaters`,
SUM(CASE WHEN dayssincelastvisit>730 THEN itemnetamount END) AS `WinBack Customers Sales`,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS `Repeat Customers Sales`,
SUM(CASE WHEN dayssincelastvisit<=365 THEN itemnetamount END) AS `Active Repeaters Sales`,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS `Existing Repeaters Sales`,
SUM(CASE WHEN dayssincelastvisit>366 AND dayssincelastvisit<=730 THEN itemnetamount END) AS `Transactors from Dormant Segment - Churn Prevention Sales`,SUM(itemqty) AS Quantity
FROM sku_report_loyalty
WHERE ((modifiedtxndate>='2024-10-01' AND modifiedtxndate<='2024-10-31')OR
(modifiedtxndate>='2025-09-01' AND modifiedtxndate<='2025-09-30')OR
(modifiedtxndate>='2025-10-01' AND modifiedtxndate<='2025-10-31'))
GROUP BY 1
),

Enroll_data AS(
SELECT 	
	CASE 
		WHEN modifiedenrolledon>='2024-10-01' AND modifiedenrolledon<='2024-10-31' THEN 'curr_mn_prev_yr'
		WHEN modifiedenrolledon>='2025-09-01' AND modifiedenrolledon<='2025-09-30' THEN 'prev_mn_curr_yr'
		WHEN modifiedenrolledon>='2025-10-01' AND modifiedenrolledon<='2025-10-31' THEN 'curr_mn_curr_yr'
		END AS 'KPIs',COUNT(DISTINCT mobile) AS Enrollments 
FROM member_report
WHERE ((modifiedenrolledon>='2024-10-01' AND modifiedenrolledon<='2024-10-31')OR
(modifiedenrolledon>='2025-09-01' AND modifiedenrolledon<='2025-09-30')OR
(modifiedenrolledon>='2025-10-01' AND modifiedenrolledon<='2025-10-31'))
GROUP BY 1
),

New_Txn_data AS(
SELECT 
	CASE 
		WHEN modifiedtxndate>='2024-10-01' AND modifiedtxndate<='2024-10-31' THEN 'curr_mn_prev_yr'
 		WHEN modifiedtxndate>='2025-09-01' AND modifiedtxndate<='2025-09-30' THEN 'prev_mn_curr_yr'
 		WHEN modifiedtxndate>='2025-10-01' AND modifiedtxndate<='2025-10-31' THEN 'curr_mn_curr_yr'
 		END AS 'KPIs',
COUNT(DISTINCT txnmappedmobile) AS `Newly Enrolled and Transacted`,
SUM(itemnetamount) AS `Newly Enrolled and Transacted Sales` FROM sku_report_loyalty a JOIN member_Report b
ON a.txnmappedmobile = b.mobile
WHERE 
(
    (a.modifiedtxndate BETWEEN '2024-10-01' AND '2024-10-31'
     AND b.modifiedenrolledon BETWEEN '2024-10-01' AND '2024-10-31')
 OR
    (a.modifiedtxndate BETWEEN '2025-09-01' AND '2025-09-30'
     AND b.modifiedenrolledon BETWEEN '2025-09-01' AND '2025-09-30')
 OR
    (a.modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31'
     AND b.modifiedenrolledon BETWEEN '2025-10-01' AND '2025-10-31')
)
GROUP BY 1
 ),

New_Repeat_data AS(
SELECT 
KPIs,COUNT(DISTINCT CASE WHEN min_f=1 AND max_f>1 THEN txnmappedmobile END) AS `New to Repeat`,
SUM(CASE WHEN min_f=1 AND max_f>1 THEN itemnetamount END) AS `New to Repeat Sales`
FROM
(SELECT 
	CASE 
		WHEN modifiedtxndate>='2024-10-01' AND modifiedtxndate<='2024-10-31' THEN 'curr_mn_prev_yr'
		WHEN modifiedtxndate>='2025-09-01' AND modifiedtxndate<='2025-09-30' THEN 'prev_mn_curr_yr'
		WHEN modifiedtxndate>='2025-10-01' AND modifiedtxndate<='2025-10-31' THEN 'curr_mn_curr_yr'
		END AS 'KPIs',txnmappedmobile,itemnetamount,MIN(frequencycount)Min_f,MAX(frequencycount)Max_f
FROM sku_report_loyalty
WHERE ((modifiedtxndate>='2024-10-01' AND modifiedtxndate<='2024-10-31')OR
(modifiedtxndate>='2025-09-01' AND modifiedtxndate<='2025-09-30')OR
(modifiedtxndate>='2025-10-01' AND modifiedtxndate<='2025-10-31'))
GROUP BY 1,2)a
GROUP BY 1
),

Points_data AS(
SELECT 
	CASE 
		WHEN txndate>='2024-10-01' AND txndate<='2024-10-31' THEN 'curr_mn_prev_yr'
		WHEN txndate>='2025-09-01' AND txndate<='2025-09-30' THEN 'prev_mn_curr_yr'
		WHEN txndate>='2025-10-01' AND txndate<='2025-10-31' THEN 'curr_mn_curr_yr'
		END AS 'KPIs',
SUM(pointscollected) AS `Total Points Issued`,
SUM(CASE WHEN pointsspent>0 THEN pointsspent END) AS `Points Redeemed`,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) AS `Redeemer`,
SUM(CASE WHEN pointsspent>0 THEN amount END) AS `Redeemers sales`,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END) AS `Redemers bills`
FROM txn_report_accrual_redemption
WHERE ((txndate>='2024-10-01' AND txndate<='2024-10-31')OR
(txndate>='2025-09-01' AND txndate<='2025-09-30')OR
(txndate>='2025-10-01' AND txndate<='2025-10-31'))
GROUP BY 1
),

NonLoyalty_data AS(
SELECT 
	CASE 
		WHEN modifiedtxndate>='2024-10-01' AND modifiedtxndate<='2024-10-31' THEN 'curr_mn_prev_yr'
		WHEN modifiedtxndate>='2025-09-01' AND modifiedtxndate<='2025-09-30' THEN 'prev_mn_curr_yr'
		WHEN modifiedtxndate>='2025-10-01' AND modifiedtxndate<='2025-10-31' THEN 'curr_mn_curr_yr'
		END AS 'KPIs',SUM(itemnetamount) AS nonloyalty
FROM sku_report_nonloyalty
WHERE ((modifiedtxndate>='2024-10-01' AND modifiedtxndate<='2024-10-31')OR
(modifiedtxndate>='2025-09-01' AND modifiedtxndate<='2025-09-30')OR
(modifiedtxndate>='2025-10-01' AND modifiedtxndate<='2025-10-31'))
GROUP BY 1
),
month_wiseKPis AS (
SELECT KPIs,Stores,`Total Transacting Customers`,`Loyalty Sales`,`Loyalty Bills`,Enrollments,`Newly Enrolled and Transacted`,
`Repeat Customers`,`New to Repeat`,`Existing Repeaters`,`Active Repeaters`,`Transactors from Dormant Segment - Churn Prevention`,
`WinBack Customers`,`Repeaters`,`WinBack Customers Sales`,`Newly Enrolled and Transacted Sales`,`Repeat Customers Sales`,
`New to Repeat Sales`,`Existing Repeaters Sales`,`Active Repeaters Sales`,`Transactors from Dormant Segment - Churn Prevention Sales`,
`Total Points Issued`,`Points Redeemed`,`Redeemer`,`Redeemers sales`,`Redemers bills`,Quantity,(`Loyalty Sales`+nonloyalty) AS `Total Sales`
FROM Months_wise a
JOIN Enroll_data b USING(KPIs)
JOIN New_Txn_data c USING(KPIs)
JOIN New_Repeat_data d USING(KPIs)
JOIN Points_data e USING(KPIs)
JOIN NonLoyalty_data f USING(KPIs))


SELECT * FROM overall_finale
UNION ALL 
SELECT * FROM month_wiseKPis
ORDER BY 
  CASE 
    WHEN KPIs = 'curr_mn_prev_yr' THEN 1
    WHEN KPIs = 'prev_mn_curr_yr' THEN 2
    WHEN KPIs = 'curr_mn_curr_yr' THEN 3
    WHEN KPIs = 'Overall' THEN 0   
    ELSE 99
  END;

###################################kpi_snapshot_per_store##############################

WITH Oevrall AS (
  SELECT 'Overall' KPIs,
    COUNT(DISTINCT modifiedstorecode) AS Stores,
    COUNT(DISTINCT txnmappedmobile) AS `Total Transacting Customers`,
    SUM(itemnetamount) AS `Loyalty Sales`,
    COUNT(DISTINCT uniquebillno) AS `Loyalty Bills`,
    COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS `Repeat Customers`,
    COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS `Existing Repeaters`,
    COUNT(DISTINCT CASE WHEN dayssincelastvisit<=365 THEN txnmappedmobile END) AS `Active Repeaters`,
    COUNT(DISTINCT CASE WHEN dayssincelastvisit>366 AND dayssincelastvisit<=730 THEN txnmappedmobile END) AS `Transactors from Dormant Segment - Churn Prevention`,
    COUNT(DISTINCT CASE WHEN dayssincelastvisit>730 THEN txnmappedmobile END) AS `WinBack Customers`,
    COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS `Repeaters`,
    SUM(CASE WHEN dayssincelastvisit>730 THEN itemnetamount END) AS `WinBack Customers Sales`,
    SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS `Repeat Customers Sales`,
    SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS `Existing Repeaters Sales`,
    SUM(CASE WHEN dayssincelastvisit<=365 THEN itemnetamount END) AS `Active Repeaters Sales`,
    SUM(CASE WHEN dayssincelastvisit>366 AND dayssincelastvisit<=730 THEN itemnetamount END) AS `Transactors from Dormant Segment - Churn Prevention Sales`,
    SUM(itemqty) AS Quantity
  FROM sku_report_loyalty
  WHERE modifiedtxndate <= '2025-10-31'
  GROUP BY 1
),
 
Enroll AS (
  SELECT 'Overall' KPIs,
    COUNT(DISTINCT mobile) AS Enrollments
  FROM member_report
  WHERE modifiedenrolledon <= '2025-10-31'
),
 
New_Txn AS (
  SELECT 'Overall' KPIs,
    COUNT(DISTINCT txnmappedmobile) AS `Newly Enrolled and Transacted`,
    SUM(itemnetamount) AS `Newly Enrolled and Transacted Sales`
  FROM sku_report_loyalty a
  JOIN store_master b ON a.modifiedstorecode = b.storecode
  WHERE a.modifiedtxndate <= '2025-10-31'
    AND txnmappedmobile IN (
      SELECT DISTINCT mobile
      FROM member_report
      WHERE modifiedtxndate <= '2025-10-31'
    )
),
 
New_Repeat AS (
  SELECT 'Overall' KPIs,
    COUNT(DISTINCT CASE WHEN min_f=1 AND max_f>1 THEN txnmappedmobile END) AS `New to Repeat`,
    SUM(CASE WHEN min_f=1 AND max_f>1 THEN itemnetamount END) AS `New to Repeat Sales`
  FROM (
    SELECT txnmappedmobile, itemnetamount, MIN(frequencycount) min_f, MAX(frequencycount) max_f
    FROM sku_report_loyalty
    WHERE modifiedtxndate <= '2025-10-31'
    GROUP BY txnmappedmobile
  ) a
),
 
Points AS (
  SELECT 'Overall' KPIs,
    SUM(pointscollected) AS `Total Points Issued`,
    SUM(CASE WHEN pointsspent>0 THEN pointsspent END) AS `Points Redeemed`,
    COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) AS `Redeemer`,
    SUM(CASE WHEN pointsspent>0 THEN amount END) AS `Redeemers sales`,
    COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END) AS `Redemers bills`
  FROM txn_report_accrual_redemption
    WHERE txndate <= '2025-10-31'
    AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%test%'AND modifiedbillno NOT LIKE '%roll%'
),
 
NonLoyalty AS (
  SELECT 'Overall' KPIs,
    SUM(itemnetamount) AS nonloyalty
  FROM sku_report_nonloyalty
  WHERE modifiedtxndate <= '2025-10-31'
),
 
overall_finale AS (
  SELECT
    a.KPIs, Stores,
    ROUND(`Total Transacting Customers` / a.Stores, 2) AS `Transacting Customer`, 
    ROUND(`Loyalty Sales` / a.Stores, 2) AS `Loyalty Sales `,
    ROUND(`Loyalty Bills` / a.Stores, 2) AS `Loyalty Bills `,
    ROUND(Enrollments / a.Stores, 2) AS `Enrollments`,
    ROUND(`Newly Enrolled and Transacted` / a.Stores, 2) AS `Newly Enrolled and Transacted `,
    ROUND(`Repeat Customers` / a.Stores, 2) AS `Repeat Customers`,
    ABS(`New to Repeat` / a.Stores) AS `New to Repeat `,
    ROUND(`Existing Repeaters` / a.Stores, 2) AS `Existing Repeaters`,
    ROUND(`Active Repeaters` / a.Stores, 2) AS `Active Repeaters`,
    ROUND(`Transactors from Dormant Segment - Churn Prevention` / a.Stores, 2) AS `Churn Prevention`,
    ROUND(`WinBack Customers` / a.Stores, 2) AS `WinBack Customers `,
    ROUND(`Repeaters` / a.Stores, 2) AS `Repeaters `,
    ROUND(`WinBack Customers Sales` / a.Stores, 2) AS `WinBack Customers Sales`,
    ROUND(`Newly Enrolled and Transacted Sales` / a.Stores, 2) AS `Newly Enrolled and Transacted Sales`,
    ROUND(`Repeat Customers Sales` / a.Stores, 2) AS `Repeat Customers Sales`,
    ROUND(`New to Repeat Sales` / a.Stores, 2) AS `New to Repeat Sales`,
    ROUND(`Existing Repeaters Sales` / a.Stores, 2) AS `Existing Repeaters Sales`,
    ROUND(`Active Repeaters Sales` / a.Stores, 2) AS `Active Repeaters Sales `,
    ROUND(`Transactors from Dormant Segment - Churn Prevention Sales` / a.Stores, 2) AS `Churn Prevention Sales `,
    ROUND(NULLIF(`Total Points Issued` / a.Stores,0), 2) AS `Points Issued `,
    ROUND(NULLIF(`Points Redeemed` / a.Stores,0), 2) AS `Points Redeemed `,
    ROUND(NULLIF(`Redeemer` / a.Stores,0), 2) AS `Redeemer`,
    ROUND(NULLIF(`Redeemers sales` / a.Stores,0), 2) AS `Redeemers sales `,
    ROUND(NULLIF(`Redemers bills` / a.Stores,0), 2) AS `Redemers bills`,
    ROUND(Quantity / a.Stores, 2) AS `Quantity`,
    ROUND(NULLIF((`Loyalty Sales` + nonloyalty) / a.Stores,0), 2) AS `Total Sales`
  FROM Oevrall a
    JOIN Enroll b USING(KPIs)
    JOIN New_Txn c USING(KPIs)
    JOIN New_Repeat d USING(KPIs)
    JOIN Points e USING(KPIs)
    JOIN NonLoyalty f USING(KPIs)
),

Months_wise AS (
  SELECT
    CASE
      WHEN modifiedtxndate >= '2024-10-01' AND modifiedtxndate <= '2024-10-31' THEN 'curr_mn_prev_yr'
      WHEN modifiedtxndate >= '2025-09-01' AND modifiedtxndate <= '2025-09-30' THEN 'prev_mn_curr_yr'
      WHEN modifiedtxndate >= '2025-10-01' AND modifiedtxndate <= '2025-10-31' THEN 'curr_mn_curr_yr'
    END AS KPIs,
    COUNT(DISTINCT modifiedstorecode) AS Stores,
    COUNT(DISTINCT txnmappedmobile) AS `Total Transacting Customers`,
    SUM(itemnetamount) AS `Loyalty Sales`, COUNT(DISTINCT uniquebillno) AS `Loyalty Bills`,
    COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS `Repeat Customers`,
    COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS `Existing Repeaters`,
    COUNT(DISTINCT CASE WHEN dayssincelastvisit<=365 THEN txnmappedmobile END) AS `Active Repeaters`,
    COUNT(DISTINCT CASE WHEN dayssincelastvisit>366 AND dayssincelastvisit<=730 THEN txnmappedmobile END) AS `Transactors from Dormant Segment - Churn Prevention`,
    COUNT(DISTINCT CASE WHEN dayssincelastvisit>730 THEN txnmappedmobile END) AS `WinBack Customers`,
    COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS `Repeaters`,
    SUM(CASE WHEN dayssincelastvisit>730 THEN itemnetamount END) AS `WinBack Customers Sales`,
    SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS `Repeat Customers Sales`,
    SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS `Existing Repeaters Sales`,
    SUM(CASE WHEN dayssincelastvisit<=365 THEN itemnetamount END) AS `Active Repeaters Sales`,
    SUM(CASE WHEN dayssincelastvisit>366 AND dayssincelastvisit<=730 THEN itemnetamount END) AS `Transactors from Dormant Segment - Churn Prevention Sales`,
    SUM(itemqty) AS Quantity
  FROM sku_report_loyalty
  WHERE (modifiedtxndate BETWEEN '2024-10-01' AND '2024-10-31'
         OR modifiedtxndate BETWEEN '2025-09-01' AND '2025-09-30'
         OR modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31')
  GROUP BY KPIs
),
 
Enroll_data AS (
  SELECT
    CASE
      WHEN modifiedenrolledon >= '2024-10-01' AND modifiedenrolledon <= '2024-10-31' THEN 'curr_mn_prev_yr'
      WHEN modifiedenrolledon >= '2025-09-01' AND modifiedenrolledon <= '2025-09-30' THEN 'prev_mn_curr_yr'
      WHEN modifiedenrolledon >= '2025-10-01' AND modifiedenrolledon <= '2025-10-31' THEN 'curr_mn_curr_yr'
    END AS KPIs,
    COUNT(DISTINCT mobile) AS Enrollments
  FROM member_report
  WHERE (modifiedenrolledon BETWEEN '2024-10-01' AND '2024-10-31'
         OR modifiedenrolledon BETWEEN '2025-09-01' AND '2025-09-30'
         OR modifiedenrolledon BETWEEN '2025-10-01' AND '2025-10-31')
  GROUP BY KPIs
),
 
New_Txn_data AS (
  SELECT
    CASE
      WHEN a.modifiedtxndate BETWEEN '2024-10-01' AND '2024-10-31' THEN 'curr_mn_prev_yr'
      WHEN a.modifiedtxndate BETWEEN '2025-09-01' AND '2025-09-30' THEN 'prev_mn_curr_yr'
      WHEN a.modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31' THEN 'curr_mn_curr_yr'
    END AS KPIs,
    COUNT(DISTINCT a.txnmappedmobile) AS `Newly Enrolled and Transacted`,
    SUM(a.itemnetamount) AS `Newly Enrolled and Transacted Sales`
  FROM sku_report_loyalty a
  JOIN member_report b ON a.txnmappedmobile = b.mobile
  WHERE (
    (a.modifiedtxndate BETWEEN '2024-10-01' AND '2024-10-31' AND b.modifiedenrolledon BETWEEN '2024-10-01' AND '2024-10-31')
    OR (a.modifiedtxndate BETWEEN '2025-09-01' AND '2025-09-30' AND b.modifiedenrolledon BETWEEN '2025-09-01' AND '2025-09-30')
    OR (a.modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31' AND b.modifiedenrolledon BETWEEN '2025-10-01' AND '2025-10-31')
  )
  GROUP BY KPIs
),
 
New_Repeat_data AS (
  SELECT
    KPIs,
    COUNT(DISTINCT CASE WHEN min_f=1 AND max_f>1 THEN txnmappedmobile END) AS `New to Repeat`,
    SUM(CASE WHEN min_f=1 AND max_f>1 THEN itemnetamount END) AS `New to Repeat Sales`
  FROM (
    SELECT
      CASE
        WHEN modifiedtxndate BETWEEN '2024-10-01' AND '2024-10-31' THEN 'curr_mn_prev_yr'
        WHEN modifiedtxndate BETWEEN '2025-09-01' AND '2025-09-30' THEN 'prev_mn_curr_yr'
        WHEN modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31' THEN 'curr_mn_curr_yr'
      END AS KPIs,
      txnmappedmobile, itemnetamount, MIN(frequencycount) min_f, MAX(frequencycount) max_f
    FROM sku_report_loyalty
    WHERE (modifiedtxndate BETWEEN '2024-10-01' AND '2024-10-31'
           OR modifiedtxndate BETWEEN '2025-09-01' AND '2025-09-30'
           OR modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31')
    GROUP BY KPIs, txnmappedmobile
  ) a
  GROUP BY KPIs
),
 
Points_data AS (
  SELECT
    CASE
      WHEN txndate BETWEEN '2024-10-01' AND '2024-10-31' THEN 'curr_mn_prev_yr'
      WHEN txndate BETWEEN '2025-09-01' AND '2025-09-30' THEN 'prev_mn_curr_yr'
      WHEN txndate BETWEEN '2025-10-01' AND '2025-10-31' THEN 'curr_mn_curr_yr'
    END AS KPIs,
    SUM(pointscollected) AS `Total Points Issued`,
    SUM(CASE WHEN pointsspent>0 THEN pointsspent END) AS `Points Redeemed`,
    COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) AS `Redeemer`,
    SUM(CASE WHEN pointsspent>0 THEN amount END) AS `Redeemers sales`,
    COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END) AS `Redemers bills`
  FROM txn_report_accrual_redemption
  WHERE (txndate BETWEEN '2024-10-01' AND '2024-10-31'
         OR txndate BETWEEN '2025-09-01' AND '2025-09-30'
         OR txndate BETWEEN '2025-10-01' AND '2025-10-31')
         AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%test%'AND modifiedbillno NOT LIKE '%roll%'
  GROUP BY KPIs
),
 
NonLoyalty_data AS (
  SELECT
    CASE
      WHEN modifiedtxndate BETWEEN '2024-10-01' AND '2024-10-31' THEN 'curr_mn_prev_yr'
      WHEN modifiedtxndate BETWEEN '2025-09-01' AND '2025-09-30' THEN 'prev_mn_curr_yr'
      WHEN modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31' THEN 'curr_mn_curr_yr'
    END AS KPIs,
    SUM(itemnetamount) AS nonloyalty
  FROM sku_report_nonloyalty
  WHERE (modifiedtxndate BETWEEN '2024-10-01' AND '2024-10-31'
         OR modifiedtxndate BETWEEN '2025-09-01' AND '2025-09-30'
         OR modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31')
  GROUP BY KPIs
),
 
month_wiseKPis AS (
  SELECT
    a.KPIs, a.Stores,
    ROUND(`Total Transacting Customers` / a.Stores, 2) AS `Transacting Customer`, 
    ROUND(`Loyalty Sales` / a.Stores, 2) AS `Loyalty Sales `,
    ROUND(`Loyalty Bills` / a.Stores, 2) AS `Loyalty Bills `,
    ROUND(Enrollments / a.Stores, 2) AS `Enrollments`,
    ROUND(`Newly Enrolled and Transacted` / a.Stores, 2) AS `Newly Enrolled and Transacted `,
    ROUND(`Repeat Customers` / a.Stores, 2) AS `Repeat Customers`,
    ABS(`New to Repeat` / a.Stores) AS `New to Repeat `,
    ROUND(`Existing Repeaters` / a.Stores, 2) AS `Existing Repeaters`,
    ROUND(`Active Repeaters` / a.Stores, 2) AS `Active Repeaters`,
    ROUND(`Transactors from Dormant Segment - Churn Prevention` / a.Stores, 2) AS `Churn Prevention`,
    ROUND(`WinBack Customers` / a.Stores, 2) AS `WinBack Customers `,
    ROUND(`Repeaters` / a.Stores, 2) AS `Repeaters `,
    ROUND(`WinBack Customers Sales` / a.Stores, 2) AS `WinBack Customers Sales`,
    ROUND(`Newly Enrolled and Transacted Sales` / a.Stores, 2) AS `Newly Enrolled and Transacted Sales`,
    ROUND(`Repeat Customers Sales` / a.Stores, 2) AS `Repeat Customers Sales`,
    ROUND(`New to Repeat Sales` / a.Stores, 2) AS `New to Repeat Sales`,
    ROUND(`Existing Repeaters Sales` / a.Stores, 2) AS `Existing Repeaters Sales`,
    ROUND(`Active Repeaters Sales` / a.Stores, 2) AS `Active Repeaters Sales `,
    ROUND(`Transactors from Dormant Segment - Churn Prevention Sales` / a.Stores, 2) AS `Churn Prevention Sales `,
    ROUND(NULLIF(`Total Points Issued` / a.Stores,0), 2) AS `Points Issued `,
    ROUND(NULLIF(`Points Redeemed` / a.Stores,0), 2) AS `Points Redeemed `,
    ROUND(NULLIF(`Redeemer` / a.Stores,0), 2) AS `Redeemer`,
    ROUND(NULLIF(`Redeemers sales` / a.Stores,0), 2) AS `Redeemers sales `,
    ROUND(NULLIF(`Redemers bills` / a.Stores,0), 2) AS `Redemers bills`,
    ROUND(Quantity / a.Stores, 2) AS `Quantity`,
    ROUND(NULLIF((`Loyalty Sales` + nonloyalty) / a.Stores,0), 2) AS `Total Sales`
  FROM Months_wise a
    JOIN Enroll_data b USING(KPIs)
    JOIN New_Txn_data c USING(KPIs)
    JOIN New_Repeat_data d USING(KPIs)
    JOIN Points_data e USING(KPIs)
    JOIN NonLoyalty_data f USING(KPIs)
)
 
SELECT * FROM (
  SELECT * FROM overall_finale
  UNION ALL
  SELECT * FROM month_wiseKPis
) AS per_store_kpis
ORDER BY
  CASE
    WHEN KPIs = 'curr_mn_prev_yr' THEN 1
    WHEN KPIs = 'prev_mn_curr_yr' THEN 2
    WHEN KPIs = 'curr_mn_curr_yr' THEN 3
    WHEN KPIs = 'Overall' THEN 0
    ELSE 99
  END;

		
######################################loyalty redeemers data#########################

WITH points AS(
SELECT 
CASE 
WHEN txndate>='2024-09-01' AND txndate<='2024-09-30' THEN 'prev_yr_prev_month'
WHEN txndate>='2025-08-01' AND txndate<='2025-08-31' THEN 'prev_2_month'
WHEN txndate>='2025-09-01' AND txndate<='2025-09-30' THEN 'prev_month'
END AS `Months`,
SUM(pointscollected) AS `Points Earned`,
SUM(pointsspent) AS `Points Redeemed`,
SUM(CASE WHEN pointsspent>0 THEN amount END) AS `Point redemption sales`,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END) AS `Point redemption bills`
FROM txn_report_accrual_redemption
WHERE ((txndate>='2024-09-01' AND txndate<='2024-09-30')OR
(txndate>='2025-08-01' AND txndate<='2025-08-31')OR
(txndate>='2025-09-01' AND txndate<='2025-09-30'))
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%test%'AND modifiedbillno NOT LIKE '%roll%'
GROUP BY 1),

Flat AS(
SELECT 
CASE 
WHEN txndate>='2024-09-01' AND txndate<='2024-09-30' THEN 'prev_yr_prev_month'
WHEN txndate>='2025-08-01' AND txndate<='2025-08-31' THEN 'prev_2_month'
WHEN txndate>='2025-09-01' AND txndate<='2025-09-30' THEN 'prev_month'
END AS `Months`,
SUM(pointscollected) AS `Flat Accrual`
FROM txn_Report_flat_accrual
WHERE ((txndate>='2024-09-01' AND txndate<='2024-09-30')OR
(txndate>='2025-08-01' AND txndate<='2025-08-31')OR
(txndate>='2025-09-01' AND txndate<='2025-09-30'))
GROUP BY 1),

Coupon1 AS(
SELECT CASE 
WHEN issueddate>='2024-09-01' AND issueddate<='2024-09-30' THEN 'prev_yr_prev_month'
WHEN issueddate>='2025-08-01' AND issueddate<='2025-08-31' THEN 'prev_2_month'
WHEN issueddate>='2025-09-01' AND issueddate<='2025-09-30' THEN 'prev_month'
END AS `Months`,
COUNT(*) AS `Coupons Issued`
FROM coupon_offer_report
WHERE ((issueddate>='2024-09-01' AND issueddate<='2024-09-30')OR
(issueddate>='2025-08-01' AND issueddate<='2025-08-31')OR
(issueddate>='2025-09-01' AND issueddate<='2025-09-30'))
GROUP BY 1
),

Coupon2 AS(
SELECT CASE 
WHEN useddate>='2024-09-01' AND useddate<='2024-09-30' THEN 'prev_yr_prev_month'
WHEN useddate>='2025-08-01' AND useddate<='2025-08-31' THEN 'prev_2_month'
WHEN useddate>='2025-09-01' AND useddate<='2025-09-30' THEN 'prev_month'
END AS `Months`,
COUNT(DISTINCT CASE WHEN couponstatus='used' THEN couponoffercode END) AS `Coupons Redeemed`,
SUM(CASE WHEN couponstatus='used' THEN amount END) AS `Coupons Redemption Sales`,
COUNT(DISTINCT CASE WHEN couponstatus='used' THEN billno END) AS `Coupons Redemption Bills`
FROM coupon_offer_report
WHERE ((useddate>='2024-09-01' AND useddate<='2024-09-30')OR
(useddate>='2025-08-01' AND useddate<='2025-08-31')OR
(useddate>='2025-09-01' AND useddate<='2025-09-30'))
GROUP BY 1
)

SELECT `Months`,`Points Earned`,`Points Redeemed`,`Flat Accrual`,`Coupons Issued`,`Coupons Redeemed`,`Coupons Redemption Sales`,`Point redemption sales`,`Coupons Redemption Bills`,`Point redemption bills`
FROM points a
LEFT JOIN flat b USING(Months)
LEFT JOIN Coupon1 c USING(Months)
LEFT JOIN Coupon2 d USING(Months)
GROUP BY 1;

###############################Top 10 Store######################

WITH sku_data AS (
SELECT 
    modifiedstorecode AS StoreCode,
    modifiedstore AS Store,
    COUNT(DISTINCT txnmappedmobile) AS `Transacted Customers`,
    COUNT(DISTINCT CASE WHEN frequencycount > 1 THEN txnmappedmobile END) AS `Repeaters`,
    SUM(itemnetamount) AS `Total Sales`,
    SUM(CASE WHEN frequencycount > 1 THEN itemnetamount END) AS `Repeaters Sales`,
    COUNT(DISTINCT uniquebillno) AS `Total Bills`,
    -- Previous Month Sales (Sep 2025)
    (
     SELECT SUM(itemnetamount)
        FROM sku_report_loyalty s2
        WHERE s2.modifiedstorecode = s1.modifiedstorecode
        AND s2.modifiedtxndate BETWEEN '2025-09-01' AND '2025-09-30'
    ) AS previous_month_sales

FROM sku_report_loyalty s1
WHERE modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31'
GROUP BY modifiedstorecode
),

txndata AS (
SELECT storecode,COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END)Redeemers 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-10-01' AND '2025-10-31'
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%test%'AND modifiedbillno NOT LIKE '%roll%'
GROUP BY 1)

SELECT storecode,Store,`Transacted Customers`,`Repeaters`,Redeemers AS Redeemers,`Total Sales`,
previous_month_sales AS `Previous Month Sale`,`Repeaters Sales`,`Total Bills` FROM sku_data a LEFT JOIN txndata b USING(storecode)
ORDER BY `Total Sales` DESC
LIMIT 10;

###################################Bottom 10 Store#################################


WITH sku_data AS (
SELECT 
    modifiedstorecode AS `Store Code`,
    modifiedstore AS Store,
    COUNT(DISTINCT txnmappedmobile) AS `Transacted Customers`,
    COUNT(DISTINCT CASE WHEN frequencycount > 1 THEN txnmappedmobile END) AS `Repeaters`,
    SUM(itemnetamount) AS `Total Sales`,
    SUM(CASE WHEN frequencycount > 1 THEN itemnetamount END) AS `Repeaters Sales`,
    COUNT(DISTINCT uniquebillno) AS `Total Bills`
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31'
GROUP BY modifiedstorecode
),

txndata AS (
SELECT storecode `Store code`,COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END)Redeemers 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-10-01' AND '2025-10-31'
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%test%'AND modifiedbillno NOT LIKE '%roll%'
GROUP BY 1)

SELECT `Store Code`,Store,`Transacted Customers`,`Repeaters`,Redeemers AS Redeemers,`Total Sales`,
`Repeaters Sales`,`Total Bills` FROM sku_data a LEFT JOIN txndata b USING(`Store Code`)
ORDER BY `Total Sales`
LIMIT 10;


############################Tier Level Till Last Month#######################

WITH Loyalty AS(
SELECT Tier,COUNT(DISTINCT txnmappedmobile) AS `Total Customers`,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS `Repeaters`,
COUNT(DISTINCT txnmappedmobile,modifiedtxndate) AS Visits,
COUNT(DISTINCT txnmappedmobile,modifiedtxndate)/COUNT(DISTINCT txnmappedmobile) AS `Average Customer Visit`,
SUM(itemnetamount) AS `Customer sales`,SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS `Repeat Sales`,
COUNT(DISTINCT uniquebillno) AS `Loyalty bills`
FROM sku_report_loyalty a
JOIN member_report b
ON a.txnmappedmobile=b.mobile
WHERE modifiedtxndate<='2025-10-31'
GROUP BY 1
),

Txn AS(
SELECT Tier,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END) AS `Redeemers`,
SUM(a.pointscollected) AS `Points collected`,
SUM(CASE WHEN a.pointsspent>0 THEN a.pointsspent END) AS `Point Redeemed`
FROM txn_report_accrual_redemption a
JOIN member_report b USING(mobile)
WHERE txndate<='2025-10-31'
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%test%'AND modifiedbillno NOT LIKE '%roll%'
GROUP BY 1
)

SELECT Tier,`Total Customers`,`Repeaters`,Visits,`Average Customer Visit`,`Redeemers`,`Customer sales`,`Repeat Sales`,`Loyalty bills`,
`Points collected`,`Point Redeemed`
FROM Loyalty a
JOIN txn b USING(tier);

############################Tier Level Last Month#######################

WITH Loyalty AS(
SELECT Tier,COUNT(DISTINCT txnmappedmobile) AS `Total Customers`,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS `Repeaters`,
COUNT(DISTINCT txnmappedmobile,modifiedtxndate) AS Visits,
COUNT(DISTINCT txnmappedmobile,modifiedtxndate)/COUNT(DISTINCT txnmappedmobile) AS `Average Customer Visit`,
SUM(itemnetamount) AS `Customer sales`,SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS `Repeat Sales`,
COUNT(DISTINCT uniquebillno) AS `Loyalty bills`
FROM sku_report_loyalty a
JOIN member_report b
ON a.txnmappedmobile=b.mobile
WHERE modifiedtxndate BETWEEN '2025-10-01' AND'2025-10-31'
GROUP BY 1
),

Txn AS(
SELECT Tier,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END) AS `Redeemers`,
SUM(a.pointscollected) AS `Points collected`,
SUM(CASE WHEN a.pointsspent>0 THEN a.pointsspent END) AS `Point Redeemed`
FROM txn_report_accrual_redemption a
JOIN member_report b USING(mobile)
WHERE txndate BETWEEN '2025-10-01' AND'2025-10-31'
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%test%'AND modifiedbillno NOT LIKE '%roll%'
GROUP BY 1
)

SELECT Tier,`Total Customers`,`Repeaters`,Visits,`Average Customer Visit`,`Redeemers`,`Customer sales`,`Repeat Sales`,`Loyalty bills`,
`Points collected`,`Point Redeemed`
FROM Loyalty a
JOIN txn b USING(tier);

###################################tier_wise_kpis_graph_repres#####################

SELECT Tier,COUNT(DISTINCT txnmappedmobile) AS `Total Customers`,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS `Repeaters`,
SUM(itemnetamount) AS Sales,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS `Repeat Sales`
FROM sku_report_loyalty a
JOIN member_report b
ON a.txnmappedmobile=b.mobile 
WHERE modifiedtxndate BETWEEN '2025-10-01' AND'2025-10-31'
GROUP BY 1;

###############################tier_wise_kpis_graph_repres_1############

WITH Tier1 AS(
SELECT Tier,
SUM(itemnetamount) AS Sales,COUNT(DISTINCT uniquebillno) AS bills
FROM sku_report_loyalty a
JOIN member_report b
ON a.txnmappedmobile=b.mobile 
WHERE modifiedtxndate BETWEEN '2025-10-01' AND'2025-10-31'
GROUP BY 1),

Tier2 AS(
SELECT Tier,SUM(a.pointscollected) AS `Points_collected`,
SUM(CASE WHEN a.pointsspent>0 THEN a.pointsspent END) AS `Point_Redeemed`
FROM txn_report_accrual_redemption a
JOIN member_report b USING(mobile)
WHERE txndate BETWEEN '2025-10-01' AND'2025-10-31' 
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%test%'AND modifiedbillno NOT LIKE '%roll%'
GROUP BY 1
)

SELECT Tier,sales,bills,point_redeemed,points_collected
FROM tier1 a
JOIN tier2 b USING(tier);

#########################Tier Level MoM#################

SELECT CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),"-",RIGHT(YEAR(modifiedtxndate),2)) AS MONTH,tier,
SUM(itemnetamount) AS sales,COUNT(DISTINCT uniquebillno) AS bills
FROM sku_report_loyalty a
JOIN member_report b
ON a.txnmappedmobile=b.mobile
WHERE modifiedtxndate BETWEEN '2024-11-01' AND'2025-10-31'
GROUP BY 1,2; 

############################ tier_Wise_new_loyalty_sales##################

WITH new_sale AS(
SELECT txnmappedmobile,MIN(frequencycount)Min_F,MAX(frequencycount)Max_F,COUNT(DISTINCT Uniquebillno)bills,SUM(Itemnetamount)sales
FROM sku_report_loyalty a
WHERE modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31'
GROUP BY 1
)

SELECT Tier,COUNT(DISTINCT CASE WHEN min_F=1 AND max_f>1 THEN txnmappedmobile END) AS `New Customers`,
SUM(CASE WHEN min_f=1 AND max_f>1 THEN bills END) AS `New Loyalty Bills`,
SUM(CASE WHEN min_f=1 AND max_f>1 THEN sales END) AS `New Sale`
FROM new_sale a JOIN member_report b ON a.txnmappedmobile=b.mobile
GROUP BY 1;
 
#######################tier_wise_frequency###########################

WITH Frq AS (
SELECT Txnmappedmobile,COUNT(DISTINCT txnmappedmobile,modifiedtxndate) AS Visit
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31'
GROUP BY 1
)

SELECT Tier,COUNT(DISTINCT Txnmappedmobile) AS Customers,CASE WHEN visit<=5 THEN visit ELSE '>5'
END AS 'visits'
FROM Frq a
JOIN member_report b
ON a.Txnmappedmobile=b.mobile
GROUP BY 1,3;

#######################tier_wise_spend###########################

WITH Spend AS (
SELECT Txnmappedmobile,SUM(itemnetamount) AS sales
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31'
GROUP BY 1
)

SELECT Tier,COUNT(DISTINCT Txnmappedmobile) AS Customers,
CASE 
	WHEN sales>0 AND sales<=1000 THEN '0-1000'
	WHEN sales>1000 AND sales<=2500 THEN '1001-2500'
	WHEN sales>2500 AND sales<=4000 THEN '2501-4000'
	WHEN sales>4000 AND sales<=6000 THEN '4001-6000'
	WHEN sales>6000 AND sales<=10000 THEN '6001-10000'
	WHEN sales>10000 THEN '>10000'	
END AS 'visits'
FROM Spend a
JOIN member_report b
ON a.Txnmappedmobile=b.mobile
GROUP BY 1,3;


#########################tier_movement##############################

##############  MIGRATION  ###################
## PREVIOUS Year Oct_24
 
CREATE TABLE dummy.Umesh_tiermovement_Oct_24_Report
SELECT mobile, MAX(TierStartDate)AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2024-10-31' AND 1=0 GROUP BY 1;

INSERT INTO dummy.Umesh_tiermovement_Oct_24_Report
SELECT mobile, MAX(TierStartDate)AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2024-10-31' GROUP BY 1;#1259912

ALTER TABLE dummy.Umesh_tiermovement_Oct_24_Report ADD COLUMN tier_Oct24 VARCHAR(20);
ALTER TABLE dummy.Umesh_tiermovement_Oct_24_Report ADD INDEX mobile(mobile), ADD INDEX TierStartDate(TierStartDate);

UPDATE dummy.Umesh_tiermovement_Oct_24_Report a JOIN (SELECT mobile,TierStartDate,currentTier 
FROM tier_report_log  
WHERE  DATE(TierStartDate)<='2024-10-31')b ON a.mobile=b.mobile AND a.tierstartdate=b.tierstartdate 
SET a.tier_Oct24=b.currenttier;#1259912

SELECT tier_Oct24,COUNT(*) FROM dummy.Umesh_tiermovement_Oct_24_Report
GROUP BY 1;

######## Current Yewr Oct_25

CREATE TABLE dummy.Umesh_tiermovement_Oct_25_Report
SELECT mobile, MAX(TierStartDate)AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2025-10-31' AND 1=0 GROUP BY 1;

INSERT INTO dummy.Umesh_tiermovement_Oct_25_Report
SELECT mobile, MAX(TierStartDate)AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2025-10-31' GROUP BY 1;#1668716

ALTER TABLE dummy.Umesh_tiermovement_Oct_25_Report ADD COLUMN tier_Oct25 VARCHAR(20);
ALTER TABLE dummy.Umesh_tiermovement_Oct_25_Report ADD INDEX mobile(mobile), ADD INDEX TierStartDate(TierStartDate);

UPDATE dummy.Umesh_tiermovement_Oct_25_Report a JOIN (SELECT mobile,TierStartDate,currentTier 
FROM tier_report_log  
WHERE  DATE(TierStartDate)<='2025-10-31')b ON a.mobile=b.mobile AND a.tierstartdate=b.tierstartdate 
SET a.tier_Oct25=b.currenttier;#1668716

SELECT tier_Oct25,COUNT(*) FROM dummy.Umesh_tiermovement_Oct_25_Report
GROUP BY 1;

SELECT tier_Oct24 AS tier_beginning,b.tier_Oct25 AS tier_ending, COUNT(DISTINCT b.mobile)count_of_customer
FROM dummy.Umesh_tiermovement_Oct_24_Report a LEFT JOIN dummy.Umesh_tiermovement_Oct_25_Report b ON a.mobile=b.mobile 
GROUP BY 1,2;

##################################loyalty_non_yoyalty _comparison##########################

WITH Loyalty AS(
SELECT CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),"-",RIGHT(YEAR(modifiedtxndate),2)) AS MONTH,
SUM(itemnetamount) AS `Loyalty Sales`,COUNT(DISTINCT uniquebillno) AS `Loyalty Bills`
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-10-01' AND '2025-10-31'
GROUP BY 1
ORDER BY modifiedtxndate
),

NonLoyalty AS(
SELECT CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),"-",RIGHT(YEAR(modifiedtxndate),2)) AS MONTH,
SUM(itemnetamount) AS `NonLoyalty Sales`,COUNT(DISTINCT uniquebillno) AS `NonLoyalty Bills`
FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2024-10-01' AND '2025-10-31'
GROUP BY 1
ORDER BY modifiedtxndate
)

SELECT MONTH,(`Loyalty Sales`+`NonLoyalty Sales`) AS `Total Sales`,(`Loyalty Bills`+`NonLoyalty Bills`) AS `TotalBills`,
`Loyalty Sales`,`NonLoyalty Sales`,`Loyalty Bills`,`NonLoyalty Bills`
FROM loyalty a
JOIN nonloyalty b USING(MONTH)
GROUP BY 1;

####################loyality_kpis########################

WITH Cust AS(
SELECT 
CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),"-",RIGHT(YEAR(modifiedtxndate),2)) AS months,
CASE 
	WHEN dayssincelastvisit<=365 AND frequencycount=1 THEN 'Active Onetimer'
	WHEN dayssincelastvisit<=365 AND frequencycount>1 THEN 'Active Repeater'
	WHEN dayssincelastvisit >=366 AND dayssincelastvisit<=730 AND frequencycount=1 THEN 'Dormant Onetimer'
	WHEN dayssincelastvisit >=366 AND dayssincelastvisit<=730 AND frequencycount>1 THEN 'Dormant Repeater'
	WHEN dayssincelastvisit >730 AND frequencycount=1 THEN 'Lapsed Onetimer'
	WHEN dayssincelastvisit>730 AND frequencycount>1 THEN 'Lapsed Repeater' ELSE NULL
	END AS 'tag',
	txnmappedmobile mobile
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-10-01' AND '2025-10-31'
GROUP BY 1,2,3
ORDER BY modifiedtxndate)

SELECT months MONTH,tag,COUNT(DISTINCT mobile)customers FROM cust
WHERE tag IS NOT NULL
GROUP BY 1,2;


#######################product_combos_purchased####################

SELECT 
    Category,
    category_count,
    COUNT(DISTINCT uniquebillno) AS Bills
FROM (
        SELECT 
            uniquebillno,
            GROUP_CONCAT(categoryname ORDER BY categoryname SEPARATOR ',') AS Category,
            COUNT(categoryname) AS category_count
        FROM sku_report_loyalty a
        JOIN item_master b
        ON a.uniqueitemcode=b.uniqueitemcode
        WHERE modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-01'
        GROUP BY uniquebillno
     ) a
GROUP BY 1,2
ORDER BY category_count, Bills DESC;



#################################seasonility_yearly#######################

SELECT 
    DATE_FORMAT(modifiedtxndate, '%d-%m-%y') AS MONTH,
    subcategoryname subcategory,
    SUM(itemnetamount) AS sales
FROM sku_report_loyalty a
JOIN item_master b
ON a.uniqueitemcode=b.uniqueitemcode
WHERE modifiedtxndate BETWEEN '2024-11-01' AND '2025-10-31'
GROUP BY 
    DATE_FORMAT(modifiedtxndate, '%d-%m-%y'),
    subcategoryname
ORDER BY modifiedtxndate;


############################seasonality_enrol_trans_cust##########################


WITH Enroll AS(
SELECT DATE_FORMAT(modifiedenrolledon, '%d-%m-%y') AS PERIOD,
    COUNT(DISTINCT mobile) AS Enrollments
    FROM member_report
    WHERE modifiedenrolledon BETWEEN '2024-11-01' AND '2025-10-31'
    GROUP BY 1
    ORDER BY modifiedenrolledon
),

Sku AS(
SELECT DATE_FORMAT(modifiedtxndate, '%d-%m-%y') AS PERIOD,
COUNT(DISTINCT txnmappedmobile) AS Transacted_Customers,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS Repeaters,
SUM(itemnetamount) AS Sales,SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS Repeaters_Sales,
COUNT(DISTINCT uniquebillno) AS Bills,
SUM(itemqty) AS Quantity
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-11-01' AND '2025-10-31'
GROUP BY 1
ORDER BY modifiedtxndate
),

Txn AS(
SELECT DATE_FORMAT(txndate, '%d-%m-%y') AS PERIOD,
SUM(CASE WHEN pointsspent>0 THEN pointsspent END) AS Point_Redeemed
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-11-01' AND '2025-10-31'
GROUP BY 1
ORDER BY txndate
)

SELECT PERIOD,Enrollments,Transacted_Customers,Repeaters,Point_Redeemed,Sales,Repeaters_Sales,Bills,Quantity
FROM Enroll a 
LEFT JOIN Sku b USING(PERIOD)
JOIN Txn c USING(PERIOD) 
GROUP BY 1;


##############################1y_active_customer###################

SELECT DATE_FORMAT(modifiedtxndate, '%d-%m-%y') AS PERIOD,
COUNT(DISTINCT CASE WHEN dayssincelastvisit<=365 THEN txnmappedmobile END) AS Active_Customer
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-11-01' AND '2025-10-31'
GROUP BY 1
ORDER BY modifiedtxndate;

############################1_2year_active_customer#################

SELECT DATE_FORMAT(modifiedtxndate, '%d-%m-%y') AS PERIOD,
COUNT(DISTINCT CASE WHEN dayssincelastvisit>366 AND dayssincelastvisit<=730 THEN txnmappedmobile END) AS Active_Customer
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-11-01' AND '2025-10-31'
GROUP BY 1
ORDER BY modifiedtxndate;










































