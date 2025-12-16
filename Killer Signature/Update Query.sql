###########################KPI Regional wise##################

WITH 
New_Enrol AS (
    SELECT 
        b.region AS `KPI's`,
        COUNT(DISTINCT a.mobile) AS `New Enrolment`
    FROM member_report a
    LEFT JOIN store_master b ON a.enrolledstorecode = b.storecode
    WHERE a.modifiedenrolledon BETWEEN '2025-11-01' AND '2025-11-30'
    GROUP BY b.region
),
Sku AS (
    SELECT 
        b.region AS `KPI's`,
        '0' AS `Red Tab Revenue`,
        '0' AS `Red Tab Transaction`,
        COUNT(DISTINCT txnmappedmobile) AS `Total Transacting Customers`,
        SUM(itemnetamount) / COUNT(DISTINCT uniquebillno) AS ABV,
        COUNT(DISTINCT CASE WHEN frequencycount > 1 THEN txnmappedmobile END) AS Repeaters,
        COUNT(DISTINCT CASE WHEN dayssincelastvisit <= 365 THEN txnmappedmobile END) AS `Transactors active for one year`,
        COUNT(DISTINCT CASE WHEN dayssincelastvisit > 366 AND dayssincelastvisit <= 545 THEN txnmappedmobile END) AS `Transactors from Dormant base`,  COUNT(DISTINCT CASE WHEN dayssincelastvisit > 730 THEN txnmappedmobile END) AS `Win Back Customers`,
        COUNT(DISTINCT uniquebillno) AS `Total Transaction`
    FROM sku_report_loyalty a
    LEFT JOIN store_master b ON a.modifiedstorecode = b.storecode
    WHERE a.modifiedtxndate BETWEEN '2025-11-01' AND '2025-11-30'
    GROUP BY b.region
),
New_Txn AS (
    SELECT 
        b.region AS `KPI's`,
        COUNT(DISTINCT a.txnmappedmobile) AS `Newly Enrolled and Transacted`
    FROM sku_report_loyalty a
    LEFT JOIN store_master b ON a.modifiedstorecode = b.storecode
    LEFT JOIN member_report c ON a.txnmappedmobile = c.mobile
    WHERE a.modifiedtxndate BETWEEN '2025-11-01' AND '2025-11-30'
      AND c.modifiedenrolledon BETWEEN '2025-11-01' AND '2025-11-30'
    GROUP BY b.region
),
All_Regions AS (
    SELECT DISTINCT `KPI's` FROM New_Enrol
    UNION
    SELECT DISTINCT `KPI's` FROM Sku
    UNION
    SELECT DISTINCT `KPI's` FROM New_Txn
)
 
SELECT 
    r.`KPI's`,
    COALESCE(ne.`New Enrolment`, 0) AS `New Enrolment`,
    COALESCE(s.`Red Tab Revenue`,0) AS `Red Tab Revenue`,
    COALESCE(s.`Red Tab Transaction`,0) AS `Red Tab Transaction`,
    COALESCE(s.`Total Transacting Customers`, 0) AS `Total Transacting Customers`,
    COALESCE(s.ABV, 0) AS ABV,
    COALESCE(nt.`Newly Enrolled and Transacted`, 0) AS `Newly Enrolled and Transacted`,
    COALESCE(s.Repeaters, 0) AS Repeaters,
    COALESCE(s.`Transactors active for one year`, 0) AS `Transactors active for one year`,
    COALESCE(s.`Transactors from Dormant base`, 0) AS `Transactors from Dormant base`,
    COALESCE(s.`Win Back Customers`, 0) AS `Win Back Customers`,
    COALESCE(s.`Total Transaction`, 0) AS `Total Transaction`
FROM All_Regions r
LEFT JOIN New_Enrol ne ON COALESCE(r.`KPI's`, 'ZZZ_NULL') = COALESCE(ne.`KPI's`, 'ZZZ_NULL')
LEFT JOIN Sku s ON COALESCE(r.`KPI's`, 'ZZZ_NULL') = COALESCE(s.`KPI's`, 'ZZZ_NULL')
LEFT JOIN New_Txn nt ON COALESCE(r.`KPI's`, 'ZZZ_NULL') = COALESCE(nt.`KPI's`, 'ZZZ_NULL')
WHERE s.`KPI's` IS NOT NULL
ORDER BY r.`KPI's`;

###########################KPI Regional wise Pev Yr##################


WITH 
New_Enrol AS (
    SELECT 
        b.region AS `KPI's`,
        COUNT(DISTINCT a.mobile) AS `New Enrolment`
    FROM member_report a
    LEFT JOIN store_master b ON a.enrolledstorecode = b.storecode
    WHERE a.modifiedenrolledon BETWEEN '2024-11-01' AND '2024-11-30'
    GROUP BY b.region
),
Sku AS (
    SELECT 
        b.region AS `KPI's`,
        '0' AS `Red Tab Revenue`,
        '0' AS `Red Tab Transaction`,
        COUNT(DISTINCT txnmappedmobile) AS `Total Transacting Customers`,
        SUM(itemnetamount) / COUNT(DISTINCT uniquebillno) AS ABV,
        COUNT(DISTINCT CASE WHEN frequencycount > 1 THEN txnmappedmobile END) AS Repeaters,
        COUNT(DISTINCT CASE WHEN dayssincelastvisit <= 365 THEN txnmappedmobile END) AS `Transactors active for one year`,
        COUNT(DISTINCT CASE WHEN dayssincelastvisit > 366 AND dayssincelastvisit <= 545 THEN txnmappedmobile END) AS `Transactors from Dormant base`,  COUNT(DISTINCT CASE WHEN dayssincelastvisit > 730 THEN txnmappedmobile END) AS `Win Back Customers`,
        COUNT(DISTINCT uniquebillno) AS `Total Transaction`
    FROM sku_report_loyalty a
    LEFT JOIN store_master b ON a.modifiedstorecode = b.storecode
    WHERE a.modifiedtxndate BETWEEN '2024-11-01' AND '2024-11-30'
    GROUP BY b.region
),
New_Txn AS (
    SELECT 
        b.region AS `KPI's`,
        COUNT(DISTINCT a.txnmappedmobile) AS `Newly Enrolled and Transacted`
    FROM sku_report_loyalty a
    LEFT JOIN store_master b ON a.modifiedstorecode = b.storecode
    LEFT JOIN member_report c ON a.txnmappedmobile = c.mobile
    WHERE a.modifiedtxndate BETWEEN '2024-11-01' AND '2024-11-30'
      AND c.modifiedenrolledon BETWEEN '2024-11-01' AND '2024-11-30'
    GROUP BY b.region
),
All_Regions AS (
    SELECT DISTINCT `KPI's` FROM New_Enrol
    UNION
    SELECT DISTINCT `KPI's` FROM Sku
    UNION
    SELECT DISTINCT `KPI's` FROM New_Txn
)
 
SELECT 
    r.`KPI's`,
    COALESCE(ne.`New Enrolment`, 0) AS `New Enrolment`,
    COALESCE(s.`Red Tab Revenue`,0) AS `Red Tab Revenue`,
    COALESCE(s.`Red Tab Transaction`,0) AS `Red Tab Transaction`,
    COALESCE(s.`Total Transacting Customers`, 0) AS `Total Transacting Customers`,
    COALESCE(s.ABV, 0) AS ABV,
    COALESCE(nt.`Newly Enrolled and Transacted`, 0) AS `Newly Enrolled and Transacted`,
    COALESCE(s.Repeaters, 0) AS Repeaters,
    COALESCE(s.`Transactors active for one year`, 0) AS `Transactors active for one year`,
    COALESCE(s.`Transactors from Dormant base`, 0) AS `Transactors from Dormant base`,
    COALESCE(s.`Win Back Customers`, 0) AS `Win Back Customers`,
    COALESCE(s.`Total Transaction`, 0) AS `Total Transaction`
FROM All_Regions r
LEFT JOIN New_Enrol ne ON COALESCE(r.`KPI's`, 'ZZZ_NULL') = COALESCE(ne.`KPI's`, 'ZZZ_NULL')
LEFT JOIN Sku s ON COALESCE(r.`KPI's`, 'ZZZ_NULL') = COALESCE(s.`KPI's`, 'ZZZ_NULL')
LEFT JOIN New_Txn nt ON COALESCE(r.`KPI's`, 'ZZZ_NULL') = COALESCE(nt.`KPI's`, 'ZZZ_NULL')
WHERE s.`KPI's` IS NOT NULL
ORDER BY r.`KPI's`;

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
  AND modifiedenrolledon BETWEEN '2024-12-01' AND '2025-11-30'
GROUP BY MONTH, c.region
ORDER BY MIN(a.modifiedtxndate);

##################################Winback Trend####################

SELECT CONCAT(MONTH(modifiedtxndate),"-",RIGHT(YEAR(modifiedtxndate),2))AS MONTH,
COUNT(DISTINCT txnmappedmobile) AS customers,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS repeaters,
COUNT(DISTINCT CASE WHEN dayssincelastvisit>730 THEN txnmappedmobile END) AS winback_customers
FROM sku_report_loyalty a
WHERE modifiedtxndate BETWEEN '2024-11-01' AND '2025-11-30'
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
        WHEN dayssincelastvisit > 2000 THEN '>2000'
    END AS recency,
    COUNT(DISTINCT CASE WHEN modifiedtxndate <= '2025-11-30' THEN txnmappedmobile END) AS base,
    COUNT(DISTINCT CASE WHEN modifiedtxndate BETWEEN '2025-11-01' AND '2025-11-30' THEN txnmappedmobile END) AS transactors
FROM `killersignatureclub`.sku_report_loyalty
WHERE dayssincelastvisit > 730 
GROUP BY 1
ORDER BY dayssincelastvisit;

##############################Winback Recency####################

SELECT 
    CONCAT(MONTH(modifiedtxndate),"-",RIGHT(YEAR(modifiedtxndate),2)) AS MONTH,
    CASE 
        WHEN dayssincelastvisit > 730  AND dayssincelastvisit <= 820  THEN '730-820'
        WHEN dayssincelastvisit > 820  AND dayssincelastvisit <= 910  THEN '820-910'
        WHEN dayssincelastvisit > 910  AND dayssincelastvisit <= 1000 THEN '910-1000'
        WHEN dayssincelastvisit > 1000 AND dayssincelastvisit <= 1200 THEN '1000-1200'
        WHEN dayssincelastvisit > 1200 AND dayssincelastvisit <= 1500 THEN '1200-1500'
        WHEN dayssincelastvisit > 1500 AND dayssincelastvisit <= 2000 THEN '1500-2000'
        WHEN dayssincelastvisit > 2000 THEN '>2000'
    END AS recency,
    COUNT(DISTINCT txnmappedmobile) AS customers
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-12-01' AND '2025-11-30'
AND dayssincelastvisit > 730
GROUP BY MONTH, recency
ORDER BY 
    STR_TO_DATE(CONCAT('01-', MONTH), '%d-%m-%y'),   
    FIELD(recency, 
        '730-820','820-910','910-1000','1000-1200',
        '1200-1500','1500-2000','>2000');
        

        
###############################Repeat Cohort#####################


WITH Cohort AS (
    SELECT 
        txnmappedmobile,
        MIN(modifiedtxndate) AS FirstDate
    FROM sku_report_loyalty
    WHERE modifiedtxndate <= '2025-11-30'
    GROUP BY txnmappedmobile
),
Cohort_Filtered AS (
    SELECT *
    FROM Cohort
    WHERE FirstDate BETWEEN '2024-12-01' AND '2025-11-30'
)

SELECT 
    YEAR(a.FirstDate) AS first_year,
    MONTH(a.FirstDate) AS first_month,
    YEAR(b.modifiedtxndate) AS second_year,
    MONTH(b.modifiedtxndate) AS second_month,
    COUNT(DISTINCT a.txnmappedmobile) AS customers
FROM Cohort_Filtered a
JOIN sku_report_loyalty b
    ON a.txnmappedmobile = b.txnmappedmobile
WHERE b.modifiedtxndate <= '2025-11-30'
GROUP BY 
    YEAR(a.FirstDate),
    MONTH(a.FirstDate),
    YEAR(b.modifiedtxndate),
    MONTH(b.modifiedtxndate);

###########################Product Landscape#####################

SELECT categoryname sub_category,SUM(itemnetamount) AS sales,SUM(itemqty) AS qty,
COUNT(DISTINCT txnmappedmobile) AS customers
FROM sku_report_loyalty a
JOIN item_master b
ON a.uniqueitemcode=b.uniqueitemcode
WHERE modifiedtxndate BETWEEN '2025-11-01' AND '2025-11-30'
GROUP BY 1; 

###############################Customer Overview##################

WITH Sku AS (
    SELECT 
        txnmappedmobile,
        DATEDIFF('2025-11-30', MAX(modifiedtxndate)) AS recency,
        SUM(itemnetamount) AS sales,
        COUNT(DISTINCT uniquebillno) AS bills
    FROM sku_report_loyalty
    WHERE modifiedtxndate <= '2025-11-30'
    GROUP BY txnmappedmobile
),

Txn AS (
    SELECT 
        mobile,
        SUM(pointscollected) AS points_accrual,
        SUM(CASE WHEN pointsspent > 0 THEN pointsspent END) AS points_redeemed,
        SUM(CASE WHEN pointsspent > 0 THEN amount END) AS redemption_sales
    FROM txn_report_accrual_redemption
    WHERE txndate <= '2025-11-30'
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
 SELECT txnmappedmobile,DATEDIFF('2024-11-30',MAX(modifiedtxndate)) AS Old_Recency
 FROM sku_report_loyalty
 WHERE modifiedtxndate<='2024-11-30'
 GROUP BY 1
 ),
 
 New_Recency AS(
 SELECT txnmappedmobile,DATEDIFF('2025-11-30',MAX(modifiedtxndate)) AS New_Recency
 FROM sku_report_loyalty
 WHERE modifiedtxndate<='2025-11-30'
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
WHERE modifiedtxndate BETWEEN '2024-12-01' AND '2025-11-30' #and itemnetamount>0
GROUP BY 1)a
GROUP BY 1
ORDER BY MIN(`Mapped Sales`);

###################################ro_Overall###############################

WITH points AS(
SELECT 'overall'kpis,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END) AS Redeemers,
SUM(CASE WHEN a.pointscollected>0 THEN a.pointscollected END) AS `Points Issued`,
SUM(CASE WHEN a.pointsspent>0 THEN a.pointsspent END) AS `Points Redeemed`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN uniquebillno END) AS `Redemption Bills`,
SUM(CASE WHEN a.pointsspent>0 THEN amount END) AS `Redemption Sales`,
'0' AS `Cost of Redemption`,
'0' AS `Cost of Issue`,
SUM(CASE WHEN a.pointsspent>0 THEN amount END)/
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN uniquebillno END) AS `Redemption ABV`,
SUM(CASE WHEN a.pointscollected>0 THEN a.pointscollected END)/
SUM(CASE WHEN a.pointsspent>0 THEN a.pointsspent END) AS `Earn Burn Ratio`,
SUM(CASE WHEN a.pointsspent>0 THEN a.amount END )/
SUM(CASE WHEN a.pointsspent>0 THEN a.pointsspent END ) AS `Extra Sales per Point Redeemed`
FROM txn_report_accrual_redemption a 
WHERE a.txndate BETWEEN '2025-11-01' AND '2025-11-30'
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%test%'AND modifiedbillno NOT LIKE '%roll%'),

lapse AS(
SELECT 'overall'kpis,
SUM(pointslapsed) AS `Points Expired`
FROM lapse_report
WHERE lapsingdate BETWEEN '2025-11-01' AND '2025-11-30')

SELECT kpis,
Redeemers,`Points Issued`,`Points Redeemed`,`Points Expired`,`Redemption Bills`,`Redemption Sales`,
`Cost of Redemption`,`Cost of Issue`,
`Redemption ABV`,`Earn Burn Ratio`,`Extra Sales per Point Redeemed`
FROM points a
JOIN lapse b USING(kpis);

###########################Ro YOY ##########################

WITH months AS (
    SELECT DATE_FORMAT(DATE_SUB('2025-11-01', INTERVAL seq MONTH), '%Y-%m-01') AS month_start
    FROM (
        SELECT 0 AS seq UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION
        SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION
        SELECT 10 UNION SELECT 11 UNION SELECT 12
    ) s
),

DATA AS (
    SELECT 
        DATE_FORMAT(txndate, '%Y-%m-01') AS month_start,
        SUM(CASE WHEN YEAR(txndate) = 2025 THEN pointscollected END) AS points_issued_ty,
        SUM(CASE WHEN YEAR(txndate) = 2024 THEN pointscollected END) AS points_issued_ly,
        SUM(CASE WHEN YEAR(txndate) = 2025 THEN pointsspent END) AS points_redeemed_ty,
        SUM(CASE WHEN YEAR(txndate) = 2024 THEN pointsspent END) AS points_redeemed_ly
    FROM txn_report_accrual_redemption
    WHERE txndate BETWEEN '2024-11-01' AND '2025-11-30'
      AND storecode NOT LIKE '%demo%'
      AND modifiedbillno NOT LIKE '%test%'
      AND modifiedbillno NOT LIKE '%roll%'
    GROUP BY 1
)

SELECT 
    CONCAT(LEFT(MONTHNAME(m.month_start),3)) AS yoy,
    d.points_issued_ty,
    d.points_issued_ly,
    d.points_redeemed_ty,
    d.points_redeemed_ly
FROM months m
LEFT JOIN DATA d USING (month_start)
ORDER BY m.month_start;


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
WHERE modifiedtxndate<='2025-11-30'
GROUP BY 1
),

Enroll AS(
SELECT 'Overall' KPIs,COUNT(DISTINCT mobile) AS Enrollments FROM member_report
WHERE modifiedenrolledon<='2025-11-30'
),

New_Txn AS(
SELECT 'Overall' KPIs,COUNT(DISTINCT txnmappedmobile) AS `Newly Enrolled and Transacted`,
SUM(itemnetamount) AS `Newly Enrolled and Transacted Sales` FROM sku_report_loyalty a
 JOIN store_master b ON a.modifiedstorecode=b.storecode
 WHERE modifiedtxndate<='2025-11-30' AND txnmappedmobile IN
 (SELECT DISTINCT mobile FROM member_report
 WHERE modifiedtxndate<='2025-11-30')
 ),

New_Repeat AS(
SELECT 'Overall' KPIs,COUNT(DISTINCT CASE WHEN min_f=1 AND max_f>1 THEN txnmappedmobile END) AS `New to Repeat`,
SUM(CASE WHEN min_f=1 AND max_f>1 THEN itemnetamount END) AS `New to Repeat Sales`
FROM
(SELECT txnmappedmobile,itemnetamount,MIN(frequencycount)Min_f,MAX(frequencycount)Max_f
FROM sku_report_loyalty
WHERE modifiedtxndate<='2025-11-30'
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
WHERE txndate<='2025-11-30'
),

NonLoyalty AS(
SELECT 
'Overall' KPIs,SUM(itemnetamount) AS nonloyalty
FROM sku_report_nonloyalty
WHERE modifiedtxndate<='2025-11-30'
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
		WHEN modifiedtxndate>='2024-11-01' AND modifiedtxndate<='2024-11-30' THEN 'curr_mn_prev_yr'
		WHEN modifiedtxndate>='2025-10-01' AND modifiedtxndate<='2025-10-31' THEN 'prev_mn_curr_yr'
		WHEN modifiedtxndate>='2025-11-01' AND modifiedtxndate<='2025-11-30' THEN 'curr_mn_curr_yr'
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
WHERE ((modifiedtxndate>='2024-11-01' AND modifiedtxndate<='2024-11-30')OR
(modifiedtxndate>='2025-10-01' AND modifiedtxndate<='2025-10-31')OR
(modifiedtxndate>='2025-11-01' AND modifiedtxndate<='2025-11-30'))
GROUP BY 1
),

Enroll_data AS(
SELECT 	
	CASE 
		WHEN modifiedenrolledon>='2024-11-01' AND modifiedenrolledon<='2024-11-30' THEN 'curr_mn_prev_yr'
		WHEN modifiedenrolledon>='2025-10-01' AND modifiedenrolledon<='2025-10-31' THEN 'prev_mn_curr_yr'
		WHEN modifiedenrolledon>='2025-11-01' AND modifiedenrolledon<='2025-11-30' THEN 'curr_mn_curr_yr'
		END AS 'KPIs',COUNT(DISTINCT mobile) AS Enrollments 
FROM member_report
WHERE ((modifiedenrolledon>='2024-11-01' AND modifiedenrolledon<='2024-11-30')OR
(modifiedenrolledon>='2025-10-01' AND modifiedenrolledon<='2025-10-31')OR
(modifiedenrolledon>='2025-11-01' AND modifiedenrolledon<='2025-11-30'))
GROUP BY 1
),

New_Txn_data AS(
SELECT 
	CASE 
		WHEN modifiedtxndate>='2024-11-01' AND modifiedtxndate<='2024-11-30' THEN 'curr_mn_prev_yr'
 		WHEN modifiedtxndate>='2025-10-01' AND modifiedtxndate<='2025-10-31' THEN 'prev_mn_curr_yr'
 		WHEN modifiedtxndate>='2025-11-01' AND modifiedtxndate<='2025-11-30' THEN 'curr_mn_curr_yr'
 		END AS 'KPIs',
COUNT(DISTINCT txnmappedmobile) AS `Newly Enrolled and Transacted`,
SUM(itemnetamount) AS `Newly Enrolled and Transacted Sales` FROM sku_report_loyalty a JOIN member_Report b
ON a.txnmappedmobile = b.mobile
WHERE 
(
    (a.modifiedtxndate BETWEEN '2024-11-01' AND '2024-11-30'
     AND b.modifiedenrolledon BETWEEN '2024-11-01' AND '2024-11-30')
 OR
    (a.modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31'
     AND b.modifiedenrolledon BETWEEN '2025-10-01' AND '2025-10-31')
 OR
    (a.modifiedtxndate BETWEEN '2025-11-01' AND '2025-11-30'
     AND b.modifiedenrolledon BETWEEN '2025-11-01' AND '2025-11-30')
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
		WHEN modifiedtxndate>='2024-11-01' AND modifiedtxndate<='2024-11-30' THEN 'curr_mn_prev_yr'
		WHEN modifiedtxndate>='2025-10-01' AND modifiedtxndate<='2025-10-31' THEN 'prev_mn_curr_yr'
		WHEN modifiedtxndate>='2025-11-01' AND modifiedtxndate<='2025-11-30' THEN 'curr_mn_curr_yr'
		END AS 'KPIs',txnmappedmobile,itemnetamount,MIN(frequencycount)Min_f,MAX(frequencycount)Max_f
FROM sku_report_loyalty
WHERE ((modifiedtxndate>='2024-11-01' AND modifiedtxndate<='2024-11-30')OR
(modifiedtxndate>='2025-10-01' AND modifiedtxndate<='2025-10-31')OR
(modifiedtxndate>='2025-11-01' AND modifiedtxndate<='2025-11-30'))
GROUP BY 1,2)a
GROUP BY 1
),

Points_data AS(
SELECT 
	CASE 
		WHEN txndate>='2024-11-01' AND txndate<='2024-11-30' THEN 'curr_mn_prev_yr'
		WHEN txndate>='2025-10-01' AND txndate<='2025-10-31' THEN 'prev_mn_curr_yr'
		WHEN txndate>='2025-11-01' AND txndate<='2025-11-30' THEN 'curr_mn_curr_yr'
		END AS 'KPIs',
SUM(pointscollected) AS `Total Points Issued`,
SUM(CASE WHEN pointsspent>0 THEN pointsspent END) AS `Points Redeemed`,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) AS `Redeemer`,
SUM(CASE WHEN pointsspent>0 THEN amount END) AS `Redeemers sales`,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END) AS `Redemers bills`
FROM txn_report_accrual_redemption
WHERE ((txndate>='2024-11-01' AND txndate<='2024-11-30')OR
(txndate>='2025-10-01' AND txndate<='2025-10-31')OR
(txndate>='2025-11-01' AND txndate<='2025-11-30'))
GROUP BY 1
),

NonLoyalty_data AS(
SELECT 
	CASE 
		WHEN modifiedtxndate>='2024-11-01' AND modifiedtxndate<='2024-11-30' THEN 'curr_mn_prev_yr'
		WHEN modifiedtxndate>='2025-10-01' AND modifiedtxndate<='2025-10-31' THEN 'prev_mn_curr_yr'
		WHEN modifiedtxndate>='2025-11-01' AND modifiedtxndate<='2025-11-30' THEN 'curr_mn_curr_yr'
		END AS 'KPIs',SUM(itemnetamount) AS nonloyalty
FROM sku_report_nonloyalty
WHERE ((modifiedtxndate>='2024-11-01' AND modifiedtxndate<='2024-11-30')OR
(modifiedtxndate>='2025-10-01' AND modifiedtxndate<='2025-10-31')OR
(modifiedtxndate>='2025-11-01' AND modifiedtxndate<='2025-11-30'))
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
  WHERE modifiedtxndate <= '2025-11-30'
  GROUP BY 1
),
 
Enroll AS (
  SELECT 'Overall' KPIs,
    COUNT(DISTINCT mobile) AS Enrollments
  FROM member_report
  WHERE modifiedenrolledon <= '2025-11-30'
),
 
New_Txn AS (
  SELECT 'Overall' KPIs,
    COUNT(DISTINCT txnmappedmobile) AS `Newly Enrolled and Transacted`,
    SUM(itemnetamount) AS `Newly Enrolled and Transacted Sales`
  FROM sku_report_loyalty a
  JOIN store_master b ON a.modifiedstorecode = b.storecode
  WHERE a.modifiedtxndate <= '2025-11-30'
    AND txnmappedmobile IN (
      SELECT DISTINCT mobile
      FROM member_report
      WHERE modifiedtxndate <= '2025-11-30'
    )
),
 
New_Repeat AS (
  SELECT 'Overall' KPIs,
    COUNT(DISTINCT CASE WHEN min_f=1 AND max_f>1 THEN txnmappedmobile END) AS `New to Repeat`,
    SUM(CASE WHEN min_f=1 AND max_f>1 THEN itemnetamount END) AS `New to Repeat Sales`
  FROM (
    SELECT txnmappedmobile, itemnetamount, MIN(frequencycount) min_f, MAX(frequencycount) max_f
    FROM sku_report_loyalty
    WHERE modifiedtxndate <= '2025-11-30'
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
    WHERE txndate <= '2025-11-30'
    AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%test%'AND modifiedbillno NOT LIKE '%roll%'
),
 
NonLoyalty AS (
  SELECT 'Overall' KPIs,
    SUM(itemnetamount) AS nonloyalty
  FROM sku_report_nonloyalty
  WHERE modifiedtxndate <= '2025-11-30'
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
      WHEN modifiedtxndate >= '2024-11-01' AND modifiedtxndate <= '2024-11-30' THEN 'curr_mn_prev_yr'
      WHEN modifiedtxndate >= '2025-10-01' AND modifiedtxndate <= '2025-10-31' THEN 'prev_mn_curr_yr'
      WHEN modifiedtxndate >= '2025-11-01' AND modifiedtxndate <= '2025-11-30' THEN 'curr_mn_curr_yr'
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
  WHERE (modifiedtxndate BETWEEN '2024-11-01' AND '2024-11-30'
         OR modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31'
         OR modifiedtxndate BETWEEN '2025-11-01' AND '2025-11-30')
  GROUP BY KPIs
),
 
Enroll_data AS (
  SELECT
    CASE
      WHEN modifiedenrolledon >= '2024-11-01' AND modifiedenrolledon <= '2024-11-30' THEN 'curr_mn_prev_yr'
      WHEN modifiedenrolledon >= '2025-10-01' AND modifiedenrolledon <= '2025-10-31' THEN 'prev_mn_curr_yr'
      WHEN modifiedenrolledon >= '2025-11-01' AND modifiedenrolledon <= '2025-11-30' THEN 'curr_mn_curr_yr'
    END AS KPIs,
    COUNT(DISTINCT mobile) AS Enrollments
  FROM member_report
  WHERE (modifiedenrolledon BETWEEN '2024-11-01' AND '2024-11-30'
         OR modifiedenrolledon BETWEEN '2025-10-01' AND '2025-10-31'
         OR modifiedenrolledon BETWEEN '2025-11-01' AND '2025-11-30')
  GROUP BY KPIs
),
 
New_Txn_data AS (
  SELECT
    CASE
      WHEN a.modifiedtxndate BETWEEN '2024-11-01' AND '2024-11-30' THEN 'curr_mn_prev_yr'
      WHEN a.modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31' THEN 'prev_mn_curr_yr'
      WHEN a.modifiedtxndate BETWEEN '2025-11-01' AND '2025-11-30' THEN 'curr_mn_curr_yr'
    END AS KPIs,
    COUNT(DISTINCT a.txnmappedmobile) AS `Newly Enrolled and Transacted`,
    SUM(a.itemnetamount) AS `Newly Enrolled and Transacted Sales`
  FROM sku_report_loyalty a
  JOIN member_report b ON a.txnmappedmobile = b.mobile
  WHERE (
    (a.modifiedtxndate BETWEEN '2024-11-01' AND '2024-11-30' AND b.modifiedenrolledon BETWEEN '2024-11-01' AND '2024-11-30')
    OR (a.modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31' AND b.modifiedenrolledon BETWEEN '2025-10-01' AND '2025-10-31')
    OR (a.modifiedtxndate BETWEEN '2025-11-01' AND '2025-11-30' AND b.modifiedenrolledon BETWEEN '2025-11-01' AND '2025-11-30')
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
        WHEN modifiedtxndate BETWEEN '2024-11-01' AND '2024-11-30' THEN 'curr_mn_prev_yr'
        WHEN modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31' THEN 'prev_mn_curr_yr'
        WHEN modifiedtxndate BETWEEN '2025-11-01' AND '2025-11-30' THEN 'curr_mn_curr_yr'
      END AS KPIs,
      txnmappedmobile, itemnetamount, MIN(frequencycount) min_f, MAX(frequencycount) max_f
    FROM sku_report_loyalty
    WHERE (modifiedtxndate BETWEEN '2024-11-01' AND '2024-11-30'
           OR modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31'
           OR modifiedtxndate BETWEEN '2025-11-01' AND '2025-11-30')
    GROUP BY KPIs, txnmappedmobile
  ) a
  GROUP BY KPIs
),
 
Points_data AS (
  SELECT
    CASE
      WHEN txndate BETWEEN '2024-11-01' AND '2024-11-30' THEN 'curr_mn_prev_yr'
      WHEN txndate BETWEEN '2025-10-01' AND '2025-10-31' THEN 'prev_mn_curr_yr'
      WHEN txndate BETWEEN '2025-11-01' AND '2025-11-30' THEN 'curr_mn_curr_yr'
    END AS KPIs,
    SUM(pointscollected) AS `Total Points Issued`,
    SUM(CASE WHEN pointsspent>0 THEN pointsspent END) AS `Points Redeemed`,
    COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) AS `Redeemer`,
    SUM(CASE WHEN pointsspent>0 THEN amount END) AS `Redeemers sales`,
    COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END) AS `Redemers bills`
  FROM txn_report_accrual_redemption
  WHERE (txndate BETWEEN '2024-11-01' AND '2024-11-30'
         OR txndate BETWEEN '2025-10-01' AND '2025-10-31'
         OR txndate BETWEEN '2025-11-01' AND '2025-11-30')
         AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%test%'AND modifiedbillno NOT LIKE '%roll%'
  GROUP BY KPIs
),
 
NonLoyalty_data AS (
  SELECT
    CASE
      WHEN modifiedtxndate BETWEEN '2024-11-01' AND '2024-11-30' THEN 'curr_mn_prev_yr'
      WHEN modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31' THEN 'prev_mn_curr_yr'
      WHEN modifiedtxndate BETWEEN '2025-11-01' AND '2025-11-30' THEN 'curr_mn_curr_yr'
    END AS KPIs,
    SUM(itemnetamount) AS nonloyalty
  FROM sku_report_nonloyalty
  WHERE (modifiedtxndate BETWEEN '2024-11-01' AND '2024-11-30'
         OR modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31'
         OR modifiedtxndate BETWEEN '2025-11-01' AND '2025-11-30')
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
WHERE modifiedtxndate BETWEEN '2025-10-01' AND '2025-11-30'
GROUP BY modifiedstorecode
),

txndata AS (
SELECT storecode,COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END)Redeemers 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-10-01' AND '2025-11-30'
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
WHERE modifiedtxndate BETWEEN '2025-10-01' AND '2025-11-30'
GROUP BY modifiedstorecode
),

txndata AS (
SELECT storecode `Store code`,COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END)Redeemers 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-10-01' AND '2025-11-30'
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%test%'AND modifiedbillno NOT LIKE '%roll%'
GROUP BY 1)

SELECT `Store Code`,Store,`Transacted Customers`,`Repeaters`,Redeemers AS Redeemers,`Total Sales`,
`Repeaters Sales`,`Total Bills` FROM sku_data a LEFT JOIN txndata b USING(`Store Code`)
ORDER BY `Total Sales`
LIMIT 10;


############################Tier Level Till Last Month#######################

WITH Loyalty AS(
    SELECT 
        Tier,
        COUNT(DISTINCT txnmappedmobile) AS `Total Customers`,
        COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS `Repeaters`,
        COUNT(DISTINCT txnmappedmobile,modifiedtxndate) AS Visits,
        COUNT(DISTINCT txnmappedmobile,modifiedtxndate)/COUNT(DISTINCT txnmappedmobile) AS `Average Customer Visit`,
        SUM(itemnetamount) AS `Customer sales`,
        SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS `Repeat Sales`,
        COUNT(DISTINCT uniquebillno) AS `Loyalty bills`
    FROM sku_report_loyalty a
    JOIN member_report b ON a.txnmappedmobile=b.mobile
    WHERE modifiedtxndate <= '2025-11-30'
    GROUP BY Tier
),

Txn AS(
    SELECT 
        Tier,
        COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END) AS `Redeemers`,
        SUM(a.pointscollected) AS `Points collected`,
        SUM(CASE WHEN a.pointsspent>0 THEN a.pointsspent END) AS `Point Redeemed`
    FROM txn_report_accrual_redemption a
    JOIN member_report b USING(mobile)
    WHERE txndate <= '2025-11-30'
      AND storecode NOT LIKE '%demo%'
      AND modifiedbillno NOT LIKE '%test%'
      AND modifiedbillno NOT LIKE '%roll%'
    GROUP BY Tier
),

Final_Data AS(
    SELECT 
        Tier,
        `Total Customers`,
        `Repeaters`,
        Visits,
        `Average Customer Visit`,
        `Redeemers`,
        `Customer sales`,
        `Repeat Sales`,
        `Loyalty bills`,
        `Points collected`,
        `Point Redeemed`
    FROM Loyalty a
    JOIN Txn b USING(Tier)
)

SELECT * FROM Final_Data

UNION ALL
SELECT 
    'Classic',
    0,0,0,0,
    0,0,0,0,
    0,0

UNION ALL
SELECT 
    'Platinum',
    0,0,0,0,
    0,0,0,0,
    0,0

ORDER BY 
CASE
    WHEN Tier = 'Orange' THEN 1
    WHEN Tier = 'Classic' THEN 2
    WHEN Tier = 'Silver' THEN 3
    WHEN Tier = 'Glod' THEN 4
    WHEN Tier = 'Platinum' THEN 5
  END;
  
  
  
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
WHERE modifiedtxndate BETWEEN '2025-11-01' AND'2025-11-30'
GROUP BY 1
),

Txn AS(
SELECT Tier,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END) AS `Redeemers`,
SUM(a.pointscollected) AS `Points collected`,
SUM(CASE WHEN a.pointsspent>0 THEN a.pointsspent END) AS `Point Redeemed`
FROM txn_report_accrual_redemption a
JOIN member_report b USING(mobile)
WHERE txndate BETWEEN '2025-11-01' AND'2025-11-30'
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%test%'AND modifiedbillno NOT LIKE '%roll%'
GROUP BY 1
),

Final_data AS (
SELECT Tier,`Total Customers`,`Repeaters`,Visits,`Average Customer Visit`,`Redeemers`,`Customer sales`,`Repeat Sales`,`Loyalty bills`,
`Points collected`,`Point Redeemed`
FROM Loyalty a
JOIN txn b USING(tier)
)

SELECT * FROM Final_Data

UNION ALL
SELECT 
    'Classic',
    0,0,0,0,
    0,0,0,0,
    0,0

UNION ALL
SELECT 
    'Platinum',
    0,0,0,0,
    0,0,0,0,
    0,0
UNION ALL
SELECT 
    'Elite',
    0,0,0,0,
    0,0,0,0,
    0,0
ORDER BY tier;


###################################tier_wise_kpis_graph_repres#####################

SELECT Tier,COUNT(DISTINCT txnmappedmobile) AS `Total Customers`,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS `Repeaters`,
SUM(itemnetamount) AS Sales,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS `Repeat Sales`
FROM sku_report_loyalty a
JOIN member_report b
ON a.txnmappedmobile=b.mobile 
WHERE modifiedtxndate BETWEEN '2025-10-01' AND'2025-11-30'
GROUP BY 1;

###############################tier_wise_kpis_graph_repres_1############

WITH Tier1 AS(
SELECT Tier,
SUM(itemnetamount) AS Sales,COUNT(DISTINCT uniquebillno) AS bills
FROM sku_report_loyalty a
JOIN member_report b
ON a.txnmappedmobile=b.mobile 
WHERE modifiedtxndate BETWEEN '2025-10-01' AND'2025-11-30'
GROUP BY 1),

Tier2 AS(
SELECT Tier,SUM(a.pointscollected) AS `Points_collected`,
SUM(CASE WHEN a.pointsspent>0 THEN a.pointsspent END) AS `Point_Redeemed`
FROM txn_report_accrual_redemption a
JOIN member_report b USING(mobile)
WHERE txndate BETWEEN '2025-10-01' AND'2025-11-30' 
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
WHERE modifiedtxndate BETWEEN '2024-11-01' AND'2025-11-30'
GROUP BY 1,2; 

############################ tier_Wise_new_loyalty_sales##################

WITH new_sale AS(
SELECT txnmappedmobile,MIN(frequencycount)Min_F,MAX(frequencycount)Max_F,COUNT(DISTINCT Uniquebillno)bills,SUM(Itemnetamount)sales
FROM sku_report_loyalty a
WHERE modifiedtxndate BETWEEN '2025-11-01' AND '2025-11-30'
GROUP BY 1
),

final_data AS(
SELECT Tier,COUNT(DISTINCT CASE WHEN min_F=1 AND max_f>1 THEN txnmappedmobile END) AS `New Customers`,
SUM(CASE WHEN min_f=1 AND max_f>1 THEN bills END) AS `New Loyalty Bills`,
SUM(CASE WHEN min_f=1 AND max_f>1 THEN sales END) AS `New Sale`
FROM new_sale a JOIN member_report b ON a.txnmappedmobile=b.mobile
GROUP BY 1
)
SELECT*FROM final_data
UNION ALL
SELECT 
    'Classic',
    0,0,0
UNION ALL
SELECT 
    'Platinum',
    0,0,0
UNION ALL
SELECT 
    'Elite',
    0,0,0
ORDER BY tier;

#######################tier_wise_frequency###########################



WITH Frq AS (
    SELECT 
        Txnmappedmobile,
        COUNT(DISTINCT modifiedtxndate) AS Visit
    FROM sku_report_loyalty
    WHERE modifiedtxndate BETWEEN '2025-11-01' AND '2025-11-30'
    GROUP BY 1
),

Base AS (
    SELECT 
        b.Tier,
        CASE 
            WHEN Visit = 1 THEN '1'
            WHEN Visit = 2 THEN '2'
            WHEN Visit = 3 THEN '3'
            WHEN Visit = 4 THEN '4'
            WHEN Visit = 5 THEN '5'
            ELSE '>5'
        END AS visits,
        COUNT(DISTINCT a.Txnmappedmobile) AS Customers
    FROM Frq a
    JOIN member_report b 
        ON a.Txnmappedmobile = b.mobile
    GROUP BY Tier, visits
),

All_Tiers AS (
    SELECT 'Classic' AS Tier
    UNION ALL SELECT 'Platinum'
    UNION ALL SELECT 'Elite'
    UNION ALL SELECT DISTINCT Tier FROM member_report
),

All_Visits AS (
    SELECT '1' AS visits
    UNION ALL SELECT '2'
    UNION ALL SELECT '3'
    UNION ALL SELECT '4'
    UNION ALL SELECT '5'
    UNION ALL SELECT '>5'
)

SELECT 
    t.Tier,
    COALESCE(b.Customers, 0) AS Customers,
    v.visits
FROM All_Tiers t
CROSS JOIN All_Visits v
LEFT JOIN Base b 
    ON t.Tier = b.Tier AND v.visits = b.visits
ORDER BY t.Tier, 
         CASE 
            WHEN v.visits = '1' THEN 1
            WHEN v.visits = '2' THEN 2
            WHEN v.visits = '3' THEN 3
            WHEN v.visits = '4' THEN 4
            WHEN v.visits = '5' THEN 5
            ELSE 6
         END;

#######################tier_wise_spend###########################

WITH Spend AS (
    SELECT 
        Txnmappedmobile,
        SUM(itemnetamount) AS sales
    FROM sku_report_loyalty
    WHERE modifiedtxndate BETWEEN '2025-11-01' AND '2025-11-30'
    GROUP BY 1
),

Base AS (
    SELECT 
        b.Tier,
        COUNT(DISTINCT a.Txnmappedmobile) AS Customers,
        CASE 
            WHEN sales > 0 AND sales <= 1000 THEN '0-1000'
            WHEN sales > 1000 AND sales <= 2500 THEN '1001-2500'
            WHEN sales > 2500 AND sales <= 4000 THEN '2501-4000'
            WHEN sales > 4000 AND sales <= 6000 THEN '4001-6000'
            WHEN sales > 6000 AND sales <= 10000 THEN '6001-10000'
            WHEN sales > 10000 THEN '>10000'
        END AS visits
    FROM Spend a
    JOIN member_report b 
        ON a.Txnmappedmobile = b.mobile
    GROUP BY Tier, visits
),

All_Tiers AS (
    SELECT 'Classic' AS Tier
    UNION ALL SELECT 'Platinum'
    UNION ALL SELECT 'Elite'
    UNION ALL SELECT DISTINCT Tier FROM member_report
),

All_Buckets AS (
    SELECT '0-1000' AS visits
    UNION ALL SELECT '1001-2500'
    UNION ALL SELECT '2501-4000'
    UNION ALL SELECT '4001-6000'
    UNION ALL SELECT '6001-10000'
    UNION ALL SELECT '>10000'
)


SELECT 
    t.Tier,
    COALESCE(b.Customers, 0) AS Customers,
    v.visits
FROM All_Tiers t
CROSS JOIN All_Buckets v
LEFT JOIN Base b
    ON t.Tier = b.Tier AND v.visits = b.visits
    WHERE v.visits IS NOT NULL
ORDER BY t.Tier,
         CASE 
            WHEN v.visits = '0-1000' THEN 1
            WHEN v.visits = '1001-2500' THEN 2
            WHEN v.visits = '2501-4000' THEN 3
            WHEN v.visits = '4001-6000' THEN 4
            WHEN v.visits = '6001-10000' THEN 5
            ELSE 6
         END;


#########################tier_movement##############################
  


WITH ExistingTiers AS (
    SELECT DISTINCT currentTier AS tier_name
    FROM tier_report_log
    WHERE CurrentTier <> '11/01/2025 12:00:00 AM'
),

AddedTiers AS (
    SELECT 'Classic' AS tier_name
    UNION ALL SELECT 'Platinum'
    UNION ALL SELECT 'Elite'
),

AllTiers AS (
    SELECT tier_name FROM ExistingTiers
    UNION
    SELECT tier_name FROM AddedTiers
),

Last_Yr_Tier AS (
    SELECT 
        mobile,
        MAX(TierStartDate) AS TierStartDate
    FROM tier_report_log
    WHERE TierStartDate <= '2024-11-30'
    GROUP BY mobile
),

Last_Tier AS (
    SELECT 
        a.mobile,
        b.currentTier AS pre_tier
    FROM Last_Yr_Tier a
    JOIN tier_report_log b
        ON a.mobile = b.mobile
       AND a.TierStartDate = b.TierStartDate
),

Current_Yr_Tier AS (
    SELECT 
        mobile,
        MAX(TierStartDate) AS TierStartDate
    FROM tier_report_log
    WHERE TierStartDate <= '2025-11-30'
    GROUP BY mobile
),

Current_Tier AS (
    SELECT 
        a.mobile,
        b.currentTier AS Cur_tier
    FROM Current_Yr_Tier a
    JOIN tier_report_log b
        ON a.mobile = b.mobile
       AND a.TierStartDate = b.TierStartDate
),

Combined AS (
    SELECT 
        LT.mobile,
        LT.pre_tier,
        CT.Cur_tier
    FROM Last_Tier LT
    LEFT JOIN Current_Tier CT ON LT.mobile = CT.mobile

    UNION ALL
    
    SELECT 
        CT.mobile,
        NULL AS pre_tier,
        CT.Cur_tier
    FROM Current_Tier CT
    LEFT JOIN Last_Tier LT ON CT.mobile = LT.mobile
    WHERE LT.mobile IS NULL
)

SELECT 
    CAST(LT.tier_name AS CHAR) AS pre_tier,
    CAST(CT.tier_name AS CHAR) AS Cur_tier,
    COUNT(DISTINCT c.mobile) AS customers
FROM AllTiers LT
CROSS JOIN AllTiers CT
LEFT JOIN Combined c
    ON c.pre_tier = LT.tier_name
   AND c.Cur_tier = CT.tier_name
GROUP BY LT.tier_name, CT.tier_name
ORDER BY LT.tier_name, CT.tier_name;


##################################loyalty_non_yoyalty _comparison##########################

WITH Loyalty AS(
SELECT CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),"-",RIGHT(YEAR(modifiedtxndate),2)) AS MONTH,
SUM(itemnetamount) AS `Loyalty Sales`,COUNT(DISTINCT uniquebillno) AS `Loyalty Bills`
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-12-01' AND '2025-11-30'
GROUP BY 1
ORDER BY modifiedtxndate
),

NonLoyalty AS(
SELECT CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),"-",RIGHT(YEAR(modifiedtxndate),2)) AS MONTH,
SUM(itemnetamount) AS `NonLoyalty Sales`,COUNT(DISTINCT uniquebillno) AS `NonLoyalty Bills`
FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2024-12-01' AND '2025-11-30'
GROUP BY 1
ORDER BY modifiedtxndate
)

SELECT MONTH,(`Loyalty Sales`+`NonLoyalty Sales`) AS `Total Sales`,(`Loyalty Bills`+`NonLoyalty Bills`) AS `Total Bills`,
`Loyalty Sales`,`NonLoyalty Sales`,`Loyalty Bills`,`NonLoyalty Bills`
FROM loyalty a
JOIN nonloyalty b USING(MONTH)
GROUP BY 1;

####################loyality_kpis########################

WITH monthly_txn AS (
    SELECT
        txnmappedmobile AS mobile,
        CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),'-',RIGHT(YEAR(modifiedtxndate),2)) AS MONTH,
        COUNT(DISTINCT txnmappedmobile,modifiedtxndate) AS monthly_visit,
        dayssincelastvisit
    FROM sku_report_loyalty
    WHERE modifiedtxndate BETWEEN '2024-12-01' AND '2025-11-30'
    GROUP BY mobile, MONTH
),

tagging AS (
    SELECT 
        MONTH,
        mobile,
        CASE 
            WHEN dayssincelastvisit <= 365 AND monthly_visit = 1 THEN 'Active Onetimer'
            WHEN dayssincelastvisit <= 365 AND monthly_visit > 1 THEN 'Active Repeater'
            WHEN dayssincelastvisit BETWEEN 366 AND 730 AND monthly_visit = 1 THEN 'Dormant Onetimer'
            WHEN dayssincelastvisit BETWEEN 366 AND 730 AND monthly_visit > 1 THEN 'Dormant Repeater'
            WHEN dayssincelastvisit > 730 AND monthly_visit = 1 THEN 'Lapsed Onetimer'
            WHEN dayssincelastvisit > 730 AND monthly_visit > 1 THEN 'Lapsed Repeater'
        END AS tag
    FROM monthly_txn
    ORDER BY MONTH
)

SELECT MONTH, tag, COUNT(DISTINCT mobile) AS customers
FROM tagging
WHERE tag IS NOT NULL
GROUP BY MONTH, tag
ORDER BY MIN(MONTH),tag;


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
        WHERE modifiedtxndate BETWEEN '2025-11-01' AND '2025-11-30'
        GROUP BY uniquebillno
     ) a
GROUP BY 1,2
ORDER BY category_count, Bills DESC;



#################################seasonility_yearly#######################

SELECT 
    DATE_FORMAT(DATE_FORMAT(modifiedtxndate, '%Y-%m-01'), '%d/%m/%y') AS MONTH,
    subcategoryname AS subcategory,
    SUM(itemnetamount) AS sales
FROM sku_report_loyalty a
JOIN item_master b
    ON a.uniqueitemcode = b.uniqueitemcode
WHERE modifiedtxndate BETWEEN '2024-12-01' AND '2025-11-30'
GROUP BY 
    DATE_FORMAT(modifiedtxndate, '%Y-%m'), 
    subcategoryname
ORDER BY 
    DATE_FORMAT(modifiedtxndate, '%Y-%m');



############################seasonality_enrol_trans_cust##########################


WITH Enroll AS(
SELECT DATE_FORMAT(DATE_FORMAT(modifiedenrolledon, '%Y-%m-01'), '%d/%m/%y') AS PERIOD,
    COUNT(DISTINCT mobile) AS Enrollments
    FROM member_report
    WHERE modifiedenrolledon BETWEEN '2024-12-01' AND '2025-11-30'
    GROUP BY 1
    ORDER BY modifiedenrolledon
),

Sku AS(
SELECT DATE_FORMAT(DATE_FORMAT(modifiedtxndate, '%Y-%m-01'), '%d/%m/%y') AS PERIOD,
COUNT(DISTINCT txnmappedmobile) AS Transacted_Customers,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) AS Repeaters,
SUM(itemnetamount) AS Sales,SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS Repeaters_Sales,
COUNT(DISTINCT uniquebillno) AS Bills,
SUM(itemqty) AS Quantity
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-12-01' AND '2025-11-30'
GROUP BY 1
ORDER BY modifiedtxndate
),

Txn AS(
SELECT DATE_FORMAT(DATE_FORMAT(txndate, '%Y-%m-01'), '%d/%m/%y') AS PERIOD,
SUM(CASE WHEN pointsspent>0 THEN pointsspent END) AS Point_Redeemed
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-12-01' AND '2025-11-30'
GROUP BY 1
ORDER BY txndate
)

SELECT PERIOD,Enrollments,Transacted_Customers,Repeaters,Point_Redeemed,Sales,Repeaters_Sales,Bills,Quantity
FROM Enroll a 
LEFT JOIN Sku b USING(PERIOD)
JOIN Txn c USING(PERIOD) 
GROUP BY 1;


##############################1y_active_customer###################

SELECT DATE_FORMAT(DATE_FORMAT(modifiedtxndate, '%Y-%m-01'), '%d/%m/%y') AS PERIOD,
COUNT(DISTINCT CASE WHEN dayssincelastvisit<=365 THEN txnmappedmobile END) AS Active_Customer
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-12-01' AND '2025-11-30'
GROUP BY 1
ORDER BY modifiedtxndate;

############################1_2year_active_customer#################

SELECT DATE_FORMAT(DATE_FORMAT(modifiedtxndate, '%Y-%m-01'), '%d/%m/%y') AS PERIOD,
COUNT(DISTINCT CASE WHEN dayssincelastvisit>366 AND dayssincelastvisit<=730 THEN txnmappedmobile END) AS Active_Customer
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-12-01' AND '2025-11-30'
GROUP BY 1
ORDER BY modifiedtxndate;










































