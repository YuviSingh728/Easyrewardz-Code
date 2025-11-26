############################################## Quarter KPI's ##############################################
SELECT Time_Period,
COUNT(DISTINCT txnmappedmobile)`Customers`,
COUNT(DISTINCT CASE WHEN MIN_fc = 1 AND Max_fc > 1 THEN txnmappedmobile END)'New to Repeat',
COUNT(DISTINCT CASE WHEN `repeat sales` IS NOT NULL THEN txnmappedmobile END)'Repeater',
COUNT(DISTINCT CASE WHEN MIN_fc = 1  THEN txnmappedmobile END)'New Cust',
SUM(Loyalty_Sales)'Loyalty_Sales',SUM(`repeat sales`)'Repeat Sales',
SUM(CASE WHEN MIN_fc = 1 THEN Loyalty_Sales END)'New Sales',
SUM(Loyalty_Bills)'Loyalty_Bills',SUM(`repeat Bills`)'Repeat Bills',
SUM(CASE WHEN MIN_fc = 1 THEN Loyalty_Bills END)'New Bills',
SUM(Qty)'Total Qty',SUM(`repeat qty`)'Repeat Qty',SUM(CASE WHEN MIN_fc = 1 THEN qty END)'New Qty',
SUM(Visits)'Total Visits',
ROUND(SUM(Loyalty_Sales)/SUM(Loyalty_Bills),0)ABV,ROUND(SUM(Qty)/SUM(Loyalty_Bills),2)`ABS`,
ROUND(SUM(Loyalty_Sales)/SUM(Visits),0)'Spend Per Visit',
ROUND(SUM(Loyalty_Sales)/SUM(Qty),0)APP
#ROUND(SUM(sales)/COUNT(DISTINCT txnmappedmobile),0)AMV,
FROM
(
SELECT txnmappedmobile, 
CASE 
    WHEN modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul24_Sep24'
    WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30' THEN 'Apr25_Jun25'
    WHEN modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30' THEN 'Jul25_Sep25'
  END AS Time_Period,
MIN(frequencycount) AS MIN_fc,
MAX(frequencycount) AS Max_fc, 
SUM(itemnetamount) AS Loyalty_Sales, 
COUNT(DISTINCT uniquebillno) AS Loyalty_Bills, 
SUM(itemqty)qty, 
ROUND(SUM(itemnetamount) / COUNT(DISTINCT uniquebillno), 2) AS ATV, 
COUNT(DISTINCT Modifiedtxndate) AS Visits, 
MIN(CASE WHEN frequencycount >1 THEN 1 ELSE 0 END)'Repeater', 
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END)'Repeat Bills', 
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END)'Repeat Sales' ,
SUM(CASE WHEN frequencycount>1 THEN itemqty END)'Repeat qty'
FROM club5.sku_report_loyalty WHERE 
((modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30') OR 
(modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30')  OR 
(modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30'))
GROUP BY 1,2 )b
GROUP BY 1;


-- 
SELECT CASE 
    WHEN modifiedenrolledon BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul24_Sep24'
    WHEN modifiedenrolledon BETWEEN '2025-04-01' AND '2025-06-30' THEN 'Apr25_Jun25'
    WHEN modifiedenrolledon BETWEEN '2025-07-01' AND '2025-09-30' THEN 'Jul25_Sep25'   END AS Time_Period,
    COUNT(DISTINCT Mobile)Enrolled
FROM club5.Member_report 
WHERE((modifiedenrolledon BETWEEN '2024-07-01' AND '2024-09-30') OR 
(modifiedenrolledon BETWEEN '2025-04-01' AND '2025-06-30')  OR 
(modifiedenrolledon BETWEEN '2025-07-01' AND '2025-09-30'))
AND enrolledstore NOT LIKE '%demo%'
GROUP BY 1;



SELECT Time_Period,
COUNT(DISTINCT mobile)`Customers`,
SUM(PointsCollected)'Total Points Issued',
SUM(Pointsspent)'Points Redeemed',
SUM(Redemption_Sales)'Redemption Sales',
#ROUND(SUM(Pointsspent) / NULLIF(SUM(PointsCollected), 0), 0) AS Redemption_Ratio,
CONCAT(ROUND(((SUM(Pointsspent)/SUM(PointsCollected))*100),2), '%')'Redemption_Ratio', 
#ROUND(SUM(Pointsspent) * 100.0 / NULLIF(SUM(PointsCollected), 0), 2) AS Redemption_Ratio,
COUNT(DISTINCT CASE WHEN Redeemers =1 THEN mobile END)'Redeemers'
FROM
(
SELECT mobile, 
CASE 
    WHEN txndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul24_Sep24'
    WHEN txndate BETWEEN '2025-04-01' AND '2025-06-30' THEN 'Apr25_Jun25'
    WHEN txndate BETWEEN '2025-07-01' AND '2025-09-30' THEN 'Jul25_Sep25'
  END AS Time_Period,
SUM(pointscollected)PointsCollected, 
SUM(pointsspent)Pointsspent,
SUM(CASE WHEN Pointsspent>0 THEN amount END) Redemption_Sales,
COUNT(DISTINCT(CASE WHEN pointsspent>0 THEN mobile END)) AS Redeemers
FROM club5.txn_report_accrual_redemption 
WHERE modifiedbillno NOT LIKE '%test%' AND storecode NOT LIKE '%demo%'
 AND modifiedbillno NOT LIKE '%roll%' 
AND ((txndate BETWEEN '2024-07-01' AND '2024-09-30') OR 
(txndate BETWEEN '2025-04-01' AND '2025-06-30')  OR 
(txndate BETWEEN '2025-07-01' AND '2025-09-30'))
GROUP BY 1,2 )b
GROUP BY 1;

SELECT CASE 
    WHEN modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul24_Sep24'
    WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30' THEN 'Apr25_Jun25'
    WHEN modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30' THEN 'Jul25_Sep25'
  END AS Time_Period,COUNT(DISTINCT modifiedstorecode)Stores
FROM club5.sku_report_loyalty 
WHERE ((modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30') OR 
(modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30')  OR 
(modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30'))
GROUP BY 1;


SELECT CASE 
    WHEN modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul24_Sep24'
    WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30' THEN 'Apr25_Jun25'
    WHEN modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30' THEN 'Jul25_Sep25'
  END AS Time_Period,SUM(itemnetamount) NonLoyalty_Sale,
  COUNT(DISTINCT uniquebillno)NonLoyalty_Bills
FROM club5.sku_report_nonloyalty 
WHERE ((modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30') OR 
(modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30')  OR 
(modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30'))
GROUP BY 1;


############################################## Region wise KPIs ##############################################

SELECT Region,
COUNT(DISTINCT txnmappedmobile)`Customers`,
COUNT(DISTINCT CASE WHEN MIN_fc = 1 AND Max_fc > 1 THEN txnmappedmobile END)'New to Repeat',
COUNT(DISTINCT CASE WHEN `repeat sales` IS NOT NULL THEN txnmappedmobile END)'Repeater',
COUNT(DISTINCT CASE WHEN MIN_fc = 1  THEN txnmappedmobile END)'New Cust',
SUM(Loyalty_Sales)'Loyalty_Sales',SUM(`repeat sales`)'Repeat Sales',
SUM(CASE WHEN MIN_fc = 1 THEN Loyalty_Sales END)'New Sales',
SUM(Loyalty_Bills)'Loyalty_Bills',SUM(`repeat Bills`)'Repeat Bills',
SUM(CASE WHEN MIN_fc = 1 THEN Loyalty_Bills END)'New Bills',
SUM(Qty)'Total Qty',SUM(`repeat qty`)'Repeat Qty',SUM(CASE WHEN MIN_fc = 1 THEN qty END)'New Qty',
SUM(Visits)'Total Visits',
ROUND(SUM(Loyalty_Sales)/SUM(Loyalty_Bills),0)ABV,ROUND(SUM(Qty)/SUM(Loyalty_Bills),2)`ABS`,
ROUND(SUM(Loyalty_Sales)/SUM(Visits),0)'Spend Per Visit',
ROUND(SUM(Loyalty_Sales)/SUM(Qty),0)APP
#ROUND(SUM(sales)/COUNT(DISTINCT txnmappedmobile),0)AMV,
FROM
(
SELECT b.region,txnmappedmobile, 
MIN(frequencycount) AS MIN_fc,
MAX(frequencycount) AS Max_fc, 
SUM(itemnetamount) AS Loyalty_Sales, 
COUNT(DISTINCT uniquebillno) AS Loyalty_Bills, 
SUM(itemqty)qty, 
ROUND(SUM(itemnetamount) / COUNT(DISTINCT uniquebillno), 2) AS ATV, 
COUNT(DISTINCT Modifiedtxndate) AS Visits, 
MIN(CASE WHEN frequencycount >1 THEN 1 ELSE 0 END)'Repeater', 
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END)'Repeat Bills', 
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END)'Repeat Sales' ,
SUM(CASE WHEN frequencycount>1 THEN itemqty END)'Repeat qty'
FROM club5.sku_report_loyalty a
JOIN club5.store_master b
ON a.modifiedstorecode=b.storecode
WHERE 
(modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30')
GROUP BY 1,2)b
GROUP BY 1;


SELECT Region,COUNT(DISTINCT Mobile)Enrolled
FROM club5.Member_report a
JOIN club5.store_master b
ON a.enrolledstorecode=b.storecode
WHERE (modifiedenrolledon BETWEEN '2025-07-01' AND '2025-09-30')
AND enrolledstore NOT LIKE '%demo%'
GROUP BY 1;


SELECT Region,
COUNT(DISTINCT modifiedstorecode)stores
 FROM club5.sku_report_loyalty a
JOIN club5.store_master b
ON a.modifiedstorecode=b.storecode
WHERE (modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30')
GROUP BY 1;

SELECT Region,
SUM(itemnetamount) NonLoyalty_Sale,
  COUNT(DISTINCT uniquebillno)NonLoyalty_Bills
FROM club5.sku_report_nonloyalty a
JOIN club5.store_master b
ON a.modifiedstorecode=b.storecode
WHERE modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30'
GROUP BY 1;

############################################## Bill Banding ##############################################


SELECT CASE WHEN sales >= 0 AND sales  <=2500 THEN  '0-2500'
 WHEN sales  >2500 AND sales  <= 5000 THEN  '2500-5000'
 WHEN sales  >5000 AND sales  <= 7500 THEN  '5000-7500'
 WHEN sales  >7500 AND sales  <= 10000 THEN  '7500-10000'
 WHEN sales  >10000 AND sales  <= 12500 THEN  '10000-12500'
 WHEN sales  >12500 AND sales  <= 15000 THEN  '12500-15000'
 WHEN sales  >15000 AND sales  <= 17500 THEN  '15000-17500'
 WHEN sales  >17500 AND sales  <= 20000 THEN  '17500-20000'
 WHEN sales  >20000 AND sales  <= 25000 THEN  '20000-25000'
 WHEN sales  >25000 AND sales  <= 30000 THEN  '25000-30000'
 WHEN sales >30000 THEN   '30K+' END  AS `Spend Bucket`,COUNT(DISTINCT txnmappedmobile)Customers,SUM(sales)Sales,SUM(bills)Bills ,
SUM(`Repeater Bills`)Repeat_Bills,
ROUND(SUM(Sales) / SUM(Bills), 2) AS ABV, 
SUM(`Repeater Sales`)Repeat_Sales,
ROUND(SUM(`Repeater Sales`) / SUM(`Repeater Bills`), 2) AS Repeat_ATV, #sum(QTY)qty,
ROUND(SUM(QTY)/ SUM(Bills),0) `ABS`
		FROM (
		SELECT txnmappedmobile
		,SUM(itemnetamount) AS Sales,
		COUNT(DISTINCT uniquebillno) AS Bills,
		SUM(itemQty) AS QTY,
		SUM(CASE WHEN frequencycount>1 THEN itemnetamount END) AS `Repeater Sales`,
		COUNT(CASE WHEN frequencycount>1 THEN Uniquebillno END) AS `Repeater Bills`
		FROM club5.sku_report_loyalty
		WHERE modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30' #AND itemnetamount>0
		GROUP BY 1
		)a
		GROUP BY 1
		ORDER BY sales ;
		
		
		SELECT  tier,COUNT(*) FROM club5.member_report GROUP BY 1;


############################################## KPI Overview ##############################################


WITH base_loyalty AS (
  SELECT 
    YEAR(txndate) AS YEAR,
    LEFT(MONTHNAME(txndate), 3) AS MONTH,
    COUNT(DISTINCT mobile) AS Customers,
    COUNT(DISTINCT CASE WHEN frequencycount > 1 THEN mobile END) AS repeat_customers,
    COUNT(DISTINCT mobile, txndate) AS visits,
    COUNT(DISTINCT CASE WHEN pointsspent > 0 THEN mobile END) AS redeemers,
    IFNULL(SUM(pointscollected), 0) AS points_accrued,
    IFNULL(SUM(pointsspent), 0) AS points_redeemed,
    SUM(amount) AS loyalty_sales,
    SUM(CASE WHEN frequencycount > 1 THEN amount END) AS repeat_sales,
    COUNT(DISTINCT modifiedbillno, txndate, storecode) AS loyalty_txn,
    COUNT(DISTINCT CASE WHEN frequencycount > 1 THEN CONCAT(modifiedbillno, txndate, storecode) END) AS repeat_txn,
    SUM(ITEMQTY) AS loyalty_qty,
    SUM(CASE WHEN frequencycount > 1 THEN ITEMQTY END) AS repeat_qty,
    COUNT(DISTINCT Storecode) AS Stores
  FROM dummy.INC5_temp_txn
  WHERE storecode NOT LIKE '%demo%' 
    AND tag_ = 'L' 
    AND modifiedbillno NOT LIKE '%test%' 
    AND modifiedbillno NOT LIKE '%roll%' 
    AND txndate BETWEEN '2025-07-01' AND '2025-09-30'
  GROUP BY 1, 2
),
nonloyalty_data AS (
  SELECT 
    YEAR(txndate) AS YEAR,
    LEFT(MONTHNAME(txndate), 3) AS MONTH,
    SUM(amount) AS nonloyalty_sales,
    SUM(ITEMQTY) AS nonloyalty_qty,
    COUNT(DISTINCT modifiedbillno, txndate, storecode) AS nonloyalty_txn
    FROM dummy.INC5_temp_txn
    WHERE storecode NOT LIKE '%demo%'  AND tag_='NL'
    AND modifiedbillno NOT LIKE '%test%'
    AND modifiedbillno NOT LIKE '%roll%'
    AND txndate>='2025-07-01' AND txndate<='2025-09-30'
  GROUP BY 1, 2
)

SELECT 
  bl.YEAR,
  bl.MONTH,
  bl.Customers,
  bl.Loyalty_sales,
  bl.Repeat_sales,
  ROUND((bl.repeat_customers / bl.customers) * 100, 2) AS Pct_Repeaters,
  nl.Nonloyalty_Sales,
  bl.Loyalty_txn,
  bl.Repeat_txn,
  nl.Nonloyalty_txn,
  ROUND(bl.loyalty_sales / NULLIF(bl.loyalty_txn, 0), 3) AS Loyalty_abv,
  ROUND(bl.repeat_sales / NULLIF(bl.repeat_txn, 0), 3) AS Repeat_abv,
  ROUND(nl.nonloyalty_sales / NULLIF(nl.nonloyalty_txn, 0), 3) AS Nonloyalty_abv,
  ROUND(bl.loyalty_qty / NULLIF(bl.loyalty_txn, 0), 3) AS Loyalty_abs,
  ROUND(bl.repeat_qty / NULLIF(bl.repeat_txn, 0), 3) AS Repeat_abs,
  ROUND(nl.nonloyalty_qty / NULLIF(nl.nonloyalty_txn, 0), 3) AS Nonloyalty_abs,
  ROUND(bl.loyalty_sales / NULLIF(bl.loyalty_qty, 0), 3) AS Loyalty_app,
  ROUND(bl.repeat_sales / NULLIF(bl.repeat_qty, 0), 3) AS Repeat_app,
  ROUND(nl.nonloyalty_sales / NULLIF(nl.nonloyalty_qty, 0), 3) AS Nonloyalty_app,
  ROUND((bl.redeemers / bl.customers) * 100, 2) AS Pct_Redeemers,
  bl.Visits,
  bl.Points_accrued,
  bl.Points_redeemed,
  ROUND(bl.points_accrued / NULLIF(bl.points_redeemed, 0), 2) AS Earn_burn_ratio,
  ROUND((bl.repeat_sales / NULLIF(bl.loyalty_sales, 0)) * 100, 2) AS pct_repeat_sales#,bl.Stores
FROM base_loyalty bl
LEFT JOIN nonloyalty_data nl 
  ON bl.YEAR = nl.YEAR AND bl.MONTH = nl.MONTH;



		
############################################## StoreWise KPI ##############################################

CREATE TABLE dummy.club_Storelevel_KPI
WITH MOM_Enrolled AS (
    SELECT Enrolledstorecode AS Storecode,
           COUNT(mobile) AS EnrolledCustomers 
    FROM club5.member_report 
    WHERE modifiedenrolledon BETWEEN '2025-07-01' AND '2025-09-30'
      AND enrolledstorecode NOT LIKE '%Demo%' 
    GROUP BY 1
),
  
MOM_NONLoyalty AS (
    SELECT Modifiedstorecode AS Storecode,
           SUM(itemnetamount) AS Nonloyalty_Sales,
           COUNT(DISTINCT uniquebillno) AS Nonloyalty_Bills,
           SUM(itemqty) AS Nonloyalty_Qty
    FROM club5.sku_report_nonloyalty 
    WHERE modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30'  
    GROUP BY 1
),

Storename AS (
    SELECT Storecode, Lpaasstore, City, State, Region
    FROM club5.store_master 
),

LoyaltyMetrics AS (
    SELECT Modifiedstorecode AS Storecode,
           ROUND(SUM(itemnetamount), 0) AS LoyaltySales,
           COUNT(DISTINCT uniquebillno) AS Loyaltybills,
           COUNT(DISTINCT txnmappedmobile) AS Transacting_customers,
           COUNT(DISTINCT CASE WHEN frequencycount > 1 THEN txnmappedmobile END) AS Repeaters,
           (COUNT(DISTINCT CASE WHEN frequencycount > 1 THEN txnmappedmobile END) * 100.0 / 
            COUNT(DISTINCT txnmappedmobile)) AS `%Repeater`,
           ROUND(SUM(CASE WHEN frequencycount > 1 THEN itemnetamount END), 0) AS Repeat_Sales,
           COUNT(DISTINCT CASE WHEN frequencycount > 1 THEN uniquebillno END) AS Repeat_Bills,
           COUNT(DISTINCT txnmappedmobile,modifiedtxndate) AS LoyaltyVisits,
           SUM(itemqty) AS Loyalty_Qty
    FROM club5.sku_report_loyalty 
    WHERE modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30'
    GROUP BY 1
),

MultiCategoryBuyers AS (
    SELECT Modifiedstorecode AS Storecode,
           COUNT(DISTINCT CASE WHEN Catg_count >= 2 THEN txnmappedmobile END) AS Customers_2plus_Categories
    FROM (
        SELECT Modifiedstorecode, txnmappedmobile,
               COUNT(DISTINCT categoryname) AS Catg_count
        FROM club5.sku_report_loyalty a
        JOIN club5.item_master b
          ON a.uniqueitemcode = b.uniqueitemcode
        WHERE modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30'
        GROUP BY Modifiedstorecode, txnmappedmobile
    ) AS sub
    GROUP BY 1
)

SELECT 
    a.Storecode,
    d.Lpaasstore AS Storename, d.City, d.State, d.Region,
    a.EnrolledCustomers,b.Transacting_customers,
    b.LoyaltySales, b.Loyaltybills , b.Repeaters,
    b.Repeat_Sales, b.LoyaltyVisits, b.Loyalty_Qty,e.Customers_2plus_Categories,c.Nonloyalty_Sales, c.Nonloyalty_Bills, c.Nonloyalty_Qty, b.`%Repeater`, b.Repeat_Bills
FROM MOM_Enrolled a
LEFT JOIN LoyaltyMetrics b ON a.Storecode = b.Storecode
LEFT JOIN MOM_NONLoyalty c ON a.Storecode = c.Storecode
JOIN Storename d ON a.Storecode = d.Storecode
LEFT JOIN MultiCategoryBuyers e ON a.Storecode = e.Storecode;


ALTER TABLE dummy.club_Storelevel_KPI ADD INDEX Storecode(Storecode);
ALTER TABLE dummy.club_Storelevel_KPI ADD COLUMN  (Pts_redeemed DECIMAL(10,2),Last3M_Winback INT);

  UPDATE dummy.club_Storelevel_KPI s
LEFT JOIN (
    SELECT storecode,
           COUNT(DISTINCT CASE WHEN Pts_spent > 0 THEN mobile END) AS Customers_Redeeming
    FROM (
        SELECT storecode, mobile,
               SUM(Pointsspent) AS Pts_spent 
        FROM club5.txn_report_accrual_redemption
        WHERE txndate BETWEEN '2025-07-01' AND '2025-09-30' 
          AND modifiedbillno NOT LIKE '%test%'
          AND storecode NOT LIKE '%demo%' 
          AND modifiedbillno NOT LIKE '%roll%'
        GROUP BY storecode, mobile
    ) AS sub
    GROUP BY storecode
) AS r
ON s.Storecode = r.storecode
SET s.Pts_redeemed = r.Customers_Redeeming;
           
#UPDATE dummy.club_Storelevel_KPI s SET s.Last3M_Winback=null
UPDATE dummy.club_Storelevel_KPI s
LEFT JOIN (
    SELECT Modifiedstorecode AS Storecode,
           COUNT(DISTINCT txnmappedmobile) AS Last3M_Winback_Customers
    FROM club5.sku_report_loyalty
    WHERE modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30'
      AND dayssincelastvisit > 730
    GROUP BY Modifiedstorecode
) AS w
ON s.Storecode = w.Storecode
SET s.Last3M_Winback = w.Last3M_Winback_Customers;

SELECT * FROM dummy.club_Storelevel_KPI;


###########################################  RFM Till Sep 25#####################################################################



 CREATE TABLE dummy.Club5_RFM_Sep_25_end AS
SELECT txnmappedmobile,Recency,Totalvisits,Totalspend,Bills,ROUND(totalspend/Bills,2)ATV,Latency,first_txn_date,last_shopped_date,
PERCENT_RANK() OVER(ORDER BY recency DESC) Recency_PR,
PERCENT_RANK() OVER(ORDER BY totalvisits ASC) Frequency_PR,
PERCENT_RANK() OVER(ORDER BY totalspend ASC) Monetary_PR
FROM 
(
SELECT txnmappedmobile,SUM(Itemnetamount)totalspend,COUNT(DISTINCT uniquebillno)Bills,COUNT(DISTINCT modifiedtxndate)totalvisits,
DATEDIFF('2025-09-30',MAX(modifiedtxndate))recency,ROUND(DATEDIFF(MAX(modifiedtxndate),MIN(modifiedtxndate))/NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0))AS 'Latency',MIN(modifiedtxndate)first_txn_date,MAX(modifiedtxndate)last_shopped_date
FROM club5.sku_report_loyalty a
JOIN club5.member_report b
ON a.txnmappedmobile=b.mobile
WHERE modifiedtxndate<= '2025-09-30'
AND txnmappedmobile<>'' 
GROUP BY 1
 )p
WHERE totalspend>0
GROUP BY 1;#1282085

ALTER TABLE dummy.Club5_RFM_Sep_25_end ADD INDEX mb(txnmappedmobile);
ALTER TABLE dummy.Club5_RFM_Sep_25_end ADD COLUMN(Recency_group INT,Frequency_group INT,Monetary_group INT, RFM_Score DOUBLE,RFM_Rank INT(10),`RFM Segment` VARCHAR(40));


-- RFM Groups
UPDATE dummy.Club5_RFM_Sep_25_end
 SET Recency_Group=
CASE WHEN recency_pr >= "0" AND recency_pr <= "0.20" THEN "20"
WHEN recency_pr > "0.20" AND recency_pr <=  "0.40" THEN "40"
WHEN recency_pr >  "0.40" AND recency_pr <=  "0.60" THEN "60"
WHEN recency_pr > "0.60" AND  recency_pr <= "0.80" THEN "80" 
WHEN recency_pr > "0.80" AND  recency_pr <= "1.00" THEN "100" END,
Frequency_Group=
CASE WHEN frequency_pr >= "0" AND frequency_pr <= "0.20" THEN "20" 
WHEN frequency_pr > "0.20" AND frequency_pr <=  "0.40" THEN "40"
WHEN frequency_pr >  "0.40" AND frequency_pr <=  "0.60" THEN "60"
WHEN frequency_pr > "0.60" AND  frequency_pr <= "0.80" THEN "80"  
WHEN frequency_pr > "0.80" AND  frequency_pr <= "1.00" THEN "100"  END,
Monetary_Group=
CASE WHEN monetary_pr >= "0" AND monetary_pr <= "0.20" THEN "20" 
WHEN monetary_pr > "0.20" AND monetary_pr <=  "0.40" THEN "40"
WHEN monetary_pr >  "0.40" AND monetary_pr <=  "0.60" THEN "60"
WHEN monetary_pr > "0.60" AND  monetary_pr <= "0.80" THEN "80"  
WHEN monetary_pr > "0.80" AND  monetary_pr <= "1.00" THEN "100"  END;#

UPDATE dummy.Club5_RFM_Sep_25_end
 SET rfm_score = 20*((Monetary_Group/20)*0.35 + (Recency_Group/20)*.30 + (Frequency_Group/20)*0.35);#
 
  -- RFM Rank
 UPDATE dummy.Club5_RFM_Sep_25_end a JOIN(
SELECT *,DENSE_RANK() OVER (ORDER BY rfm_score DESC,totalspend DESC,recency ASC,totalvisits DESC)Ranks FROM dummy.Club5_RFM_Sep_25_end)b
ON a.txnmappedmobile=b.txnmappedmobile SET a.RFM_Rank=b.Ranks;
 
 ALTER TABLE dummy.Club5_RFM_Sep_25_end ADD COLUMN recency_bucket INT;
ALTER TABLE dummy.Club5_RFM_Sep_25_end ADD COLUMN frequency_bucket INT;
ALTER TABLE dummy.Club5_RFM_Sep_25_end ADD COLUMN monetary_bucket INT;
ALTER TABLE dummy.Club5_RFM_Sep_25_end ADD COLUMN rfm_score2 INT;

 UPDATE dummy.Club5_RFM_Sep_25_end
 SET Recency_Bucket=
CASE WHEN recency_pr >= "0" AND recency_pr <= "0.20" THEN "1"
WHEN recency_pr > "0.20" AND recency_pr <=  "0.40" THEN "2"
WHEN recency_pr >  "0.40" AND recency_pr <=  "0.60" THEN "3"
WHEN recency_pr > "0.60" AND  recency_pr <= "0.80" THEN "4" 
WHEN recency_pr > "0.80" AND  recency_pr <= "1.00" THEN "5" END,
Frequency_Bucket=
CASE WHEN frequency_pr >= "0" AND frequency_pr <= "0.20" THEN "1" 
WHEN frequency_pr > "0.20" AND frequency_pr <=  "0.40" THEN "2"
WHEN frequency_pr >  "0.40" AND frequency_pr <=  "0.60" THEN "3"
WHEN frequency_pr > "0.60" AND  frequency_pr <= "0.80" THEN "4"  
WHEN frequency_pr > "0.80" AND  frequency_pr <= "1.00" THEN "5"  END,
Monetary_Bucket=
CASE WHEN monetary_pr >= "0" AND monetary_pr <= "0.20" THEN "1" 
WHEN monetary_pr > "0.20" AND monetary_pr <=  "0.40" THEN "2"
WHEN monetary_pr >  "0.40" AND monetary_pr <=  "0.60" THEN "3"
WHEN monetary_pr > "0.60" AND  monetary_pr <= "0.80" THEN "4"  
WHEN monetary_pr > "0.80" AND  monetary_pr <= "1.00" THEN "5"  END;#

UPDATE dummy.Club5_RFM_Sep_25_end
 SET rfm_score2 = (recency_bucket+frequency_bucket+monetary_bucket);


 
-- UPDATE dummy.Club5_RFM_Sep_25_end a JOIN(
-- SELECT *,DENSE_RANK() OVER (ORDER BY rfm_score2 DESC,totalspend DESC,recency ASC,totalvisits DESC)Ranks FROM dummy.Club5_RFM_Sep_25_end)b
-- ON a.txnmappedmobile=b.txnmappedmobile SET a.RFM_Rank=b.Ranks;#
--  

##   lifesegment definition
ALTER TABLE dummy.Club5_RFM_Sep_25_end ADD COLUMN (`Cust Segment` VARCHAR(40),`Cust Type` VARCHAR(40),Last_2yr_visits INT);

UPDATE  dummy.Club5_RFM_Sep_25_end a 
JOIN(SELECT txnmappedmobile,COUNT(DISTINCT modifiedtxndate)visit
FROM club5.sku_report_loyalty
WHERE modifiedtxndate>= '2023-10-01' AND  modifiedtxndate<= '2025-09-30'
AND insertiondate< CURDATE()
GROUP BY 1)b
USING(txnmappedmobile)
SET a.Last_2yr_visits=b.visit;#735312

UPDATE dummy.Club5_RFM_Sep_25_end a SET a.Last_2yr_visits=0 WHERE Last_2yr_visits IS NULL;#546773


ALTER TABLE dummy.Club5_RFM_Sep_25_end ADD COLUMN (Last_1yr_visits INT);

UPDATE  dummy.Club5_RFM_Sep_25_end a 
JOIN(SELECT txnmappedmobile,COUNT(DISTINCT modifiedtxndate)visit
FROM club5.sku_report_loyalty
WHERE modifiedtxndate>= '2024-10-01' AND  modifiedtxndate<= '2025-09-30'
AND insertiondate< CURDATE()
GROUP BY 1)b
USING(txnmappedmobile)
SET a.Last_1yr_visits=b.visit;#

UPDATE dummy.Club5_RFM_Sep_25_end a SET a.Last_1yr_visits=0 WHERE Last_1yr_visits IS NULL;#

ALTER TABLE dummy.Club5_RFM_Sep_25_end ADD COLUMN (enrolmentdate DATE,Availablepoints DECIMAL(10,2),isnondnd INT,enrolledstore VARCHAR(30),vintage INT,
State VARCHAR(50),`L-R` INT);


UPDATE  dummy.Club5_RFM_Sep_25_end a 
JOIN(SELECT mobile,modifiedenrolledon,availablepoints,isnondnd,enrolledstorecode,DATEDIFF('2025-09-30',modifiedenrolledon)vintage
FROM club5.member_report
)b
ON a.txnmappedmobile=b.mobile
SET a.vintage=b.vintage,a.enrolmentdate=b.modifiedenrolledon,a.Availablepoints=b.availablepoints,a.isnondnd=b.isnondnd,a.enrolledstore=b.enrolledstorecode;#

/*
UPDATE dummy.Club5_RFM_Sep_25_end a
JOIN club5.store_master b ON a.enrolledstore = b.storecode
SET a.State=b.State;#
*/
-- UPDATE dummy.Club5_RFM_Sep_25_end SET Latency=0 WHERE Latency IS NULL;#
-- UPDATE dummy.Club5_RFM_Sep_25_end SET `L-R`=Latency-Recency ;#
SELECT * FROM dummy.Club5_RFM_Sep_25_end;

ALTER TABLE dummy.Club5_RFM_Sep_25_end ADD COLUMN (OT_Repeater VARCHAR (10));

UPDATE dummy.Club5_RFM_Sep_25_end SET OT_Repeater= CASE WHEN Totalvisits= 1 THEN 'Onetimer' WHEN Totalvisits> 1 THEN 'Repeater' END;


UPDATE dummy.Club5_RFM_Sep_25_end SET `Cust Segment` = CASE WHEN recency <= 365 AND vintage <=365 
AND totalvisits =1 THEN 'New' 
 WHEN recency <= 365 AND totalvisits <3 THEN 'Grow' 
 WHEN recency <= 365 AND totalvisits >=3 THEN 'Stable' 
 WHEN recency BETWEEN 366 AND 730 AND totalvisits =1 THEN 'Declining1' 
 WHEN recency BETWEEN 366 AND 730 AND totalvisits >=2 THEN 'Declining2' 
 WHEN recency BETWEEN 731 AND 913 THEN 'Recently lapsed' 
 WHEN recency BETWEEN 914 AND 1095 THEN 'Long lapsed' 
 WHEN recency >1095 THEN 'Lost pool' END;
*/
 UPDATE dummy.Club5_RFM_Sep_25_end SET `Cust Type`=CASE WHEN Recency<=365 THEN 'Active' 
								WHEN recency BETWEEN 366 AND 730 THEN 'Dormant' 
								WHEN recency>730 THEN 'Lapsed' END ;

SELECT * FROM dummy.Club5_RFM_Sep_25_end;

ALTER TABLE dummy.Club5_RFM_Sep_25_end ADD COLUMN (is_transacted_APJ_25 INT);

ALTER TABLE dummy.Club5_RFM_Sep_25_end ADD COLUMN (lasttxnstorecode VARCHAR(50));
 
UPDATE  dummy.Club5_RFM_Sep_25_end a
JOIN ( SELECT txnmappedmobile,modifiedtxndate,modifiedstorecode 
FROM club5.sku_report_loyalty 
WHERE modifiedtxndate<= '2025-09-30' 
)b
ON a.txnmappedmobile=b.txnmappedmobile AND a.Last_shopped_date=b.modifiedtxndate
SET a.lasttxnstorecode=b.modifiedstorecode ; 

 ALTER TABLE dummy.Club5_RFM_Sep_25_end ADD COLUMN (Last_1yr_ATV DECIMAL(10,2));

UPDATE dummy.Club5_RFM_Sep_25_end a
LEFT JOIN (SELECT txnmappedmobile,  (SUM(itemnetamount)/COUNT(DISTINCT uniquebillno))ATV  
           FROM club5.sku_report_loyalty
           WHERE modifiedtxndate BETWEEN '2024-10-01' AND '2025-09-30' #AND itemnetamount>0
           GROUP BY txnmappedmobile
           )b 
           ON a.txnmappedmobile = b.txnmappedmobile
           SET a.Last_1yr_ATV = IFNULL(b.ATV, 0);
           
ALTER TABLE dummy.Club5_RFM_Sep_25_end ADD COLUMN (Itemqty DECIMAL(10,2));

UPDATE dummy.Club5_RFM_Sep_25_end a
LEFT JOIN (SELECT txnmappedmobile,SUM(itemqty) qty
           FROM club5.sku_report_loyalty
           WHERE modifiedtxndate <='2025-09-30'
           GROUP BY txnmappedmobile
           )b 
           ON a.txnmappedmobile = b.txnmappedmobile
           SET a.Itemqty = IFNULL(b.qty, 0);
             

SELECT SUM(amount)sales,COUNT(DISTINCT uniquebillno)Bills ,(SUM(amount)/COUNT(DISTINCT uniquebillno))ATV
           FROM club5.txn_report_accrual_redemption
           WHERE txndate <='2025-09-30' 
           AND modifiedbillno NOT LIKE '%test%'
           AND storecode NOT LIKE '%demo%' 
           AND modifiedbillno NOT LIKE '%roll%';#3591
           
           SELECT 7075363453.73/1970066;

 SELECT lasttxnstorecode AS Storecode,
COUNT(DISTINCT CASE WHEN RFM_Score > 10 THEN txnmappedmobile END) AS `No of Customers in Top RFM segments >10 score`,
COUNT(DISTINCT CASE WHEN `Cust Type` = 'Active' THEN txnmappedmobile END) AS `No. of Customers in Active`,
COUNT(DISTINCT CASE WHEN `Cust Type` = 'Dormant' THEN txnmappedmobile END) AS `No. of Customers in Dormant`,
COUNT(DISTINCT CASE WHEN `Cust Type` = 'Lapsed' THEN txnmappedmobile END) AS `No. of Customers in Lapsed`,
COUNT(DISTINCT CASE WHEN Last_1yr_visits > 2 THEN txnmappedmobile END) AS `Customers WITH frequency > 2 IN LAST 1 years`,
COUNT(DISTINCT CASE WHEN Last_1yr_ATV > 3618 THEN txnmappedmobile END) AS `Customers with ATV greater than brand's average ATV`
FROM dummy.Club5_RFM_Sep_25_end GROUP BY 1;

SELECT 
    #a.*, 
  a.Storecode,Storename,City,State,Region,
  EnrolledCustomers AS `Enrolled Customers` ,
  Transacting_customers AS `Transacting Customers`,
  LoyaltySales AS `Loyalty Sales`,
  Loyaltybills AS `Loyalty Bills`,
  Repeaters,
  Repeat_Sales AS `Repeat Sales`,
  LoyaltyVisits AS `Loyalty Visits`,
  Loyalty_Qty AS `Loyalty Qty`,
  Customers_2plus_Categories AS `Customers buying  At least 2 Categories`,
  Pts_redeemed AS `Customers Redeeming`,
  Last3M_Winback AS `No of Dormant/Lapsed customers who came back in last 3M`,
    b.`No of Customers in Top RFM segments >10 score`,
    b.`No. of Customers in Active`,
    b.`No. of Customers in Dormant`,
    b.`No. of Customers in Lapsed`,
    b.`Customers WITH frequency > 2 IN LAST 1 years`,
    b.`Customers with ATV greater than brand's average ATV`
FROM 
    dummy.club_Storelevel_KPI a
LEFT JOIN (
    SELECT lasttxnstorecode AS Storecode,
COUNT(DISTINCT CASE WHEN RFM_Score2 > 10 THEN txnmappedmobile END) AS `No of Customers in Top RFM segments >10 score`,
COUNT(DISTINCT CASE WHEN `Cust Type` = 'Active' THEN txnmappedmobile END) AS `No. of Customers in Active`,
COUNT(DISTINCT CASE WHEN `Cust Type` = 'Dormant' THEN txnmappedmobile END) AS `No. of Customers in Dormant`,
COUNT(DISTINCT CASE WHEN `Cust Type` = 'Lapsed' THEN txnmappedmobile END) AS `No. of Customers in Lapsed`,
COUNT(DISTINCT CASE WHEN Last_1yr_visits > 2 THEN txnmappedmobile END) AS `Customers WITH frequency > 2 IN LAST 1 years`,
COUNT(DISTINCT CASE WHEN Last_1yr_ATV > 3618 THEN txnmappedmobile END) AS `Customers with ATV greater than brand's average ATV`
FROM dummy.Club5_RFM_Sep_25_end GROUP BY 1
) b
ON a.Storecode = b.Storecode ;

############################################## Cust Overview ##############################################


SELECT  CONCAT(`Cust Type`,'-',OT_Repeater)Tag,COUNT(DISTINCT txnmappedmobile)Customers, ROUND(SUM(Totalspend),3)Total_sales, SUM(Bills)Total_Bills,SUM(Totalvisits)Total_Visits, 
ROUND(AVG(recency),2) AS Avg_Recency,
ROUND(SUM(Itemqty)/NULLIF(SUM(Bills),0),2) AS ABS
FROM dummy.Club5_RFM_Sep_25_end
GROUP BY 1;

-- select distinct `Cust Type`,OT_Repeater from dummy.Club5_RFM_Sep_25_end

SELECT MIN(first_txn_date),MAX(last_shopped_date) FROM dummy.Club5_RFM_Sep_25_end

#################################Tier Overview#############################

SELECT Tier,COUNT(DISTINCT txnmappedmobile) AS Customer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END) 'Repeater',
COUNT(DISTINCT txnmappedmobile,modifiedtxndate) Visits,
COUNT(DISTINCT txnmappedmobile,modifiedtxndate)/COUNT(DISTINCT txnmappedmobile) AS Avg_Visit,
SUM(a.itemnetamount) AS Mapped_sales,COUNT(DISTINCT uniquebillno) AS Bills,
SUM(a.itemnetamount)/COUNT(DISTINCT uniquebillno) AS ABV,
SUM(itemqty)/COUNT(DISTINCT uniquebillno) AS ABS,
SUM(a.itemnetamount)/SUM(itemqty) AS APP
FROM club5.sku_report_loyalty a
JOIN member_report b
ON a.txnmappedmobile=b.mobile
WHERE modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30'
GROUP BY 1;


SELECT Tier,
COUNT(DISTINCT CASE WHEN a.pointsspent>1 THEN a.mobile END)'Redeemers',
SUM(a.pointscollected) AS Points_Accrual,
SUM(CASE WHEN a.pointsspent>1 THEN a.pointsspent END) Point_Redeemed
FROM txn_report_accrual_redemption a
JOIN member_report b
USING(mobile)
WHERE txndate BETWEEN '2025-07-01' AND '2025-09-30'
GROUP BY 1;

SELECT Tier,AVG(recency) Avg_recency,AVG(Latency)AS Avg_Latency,
COUNT(DISTINCT CASE WHEN recency<=365 THEN txnmappedmobile END)'active',
COUNT(DISTINCT CASE WHEN recency>730 THEN txnmappedmobile END)'Lapse'
FROM
(SELECT txnmappedmobile,Tier,DATEDIFF('2025-09-30',MAX(modifiedtxndate))recency,ROUND(DATEDIFF(MAX(modifiedtxndate),MIN(modifiedtxndate))/NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0))AS 'Latency'
FROM sku_report_loyalty a
JOIN member_report b
ON a.txnmappedmobile=b.mobile
WHERE modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30'
GROUP BY 1)a
GROUP BY 1;

SELECT * FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30'
AND TierName IS NULL;


SELECT * FROM sku_report_loyalty a JOIN member_report b
ON a.txnmappedmobile = b.mobile
WHERE modifiedtxndate  BETWEEN '2025-07-01' AND '2025-09-30' 

AND a.TierName IS NULL;


DESC sku_report_loyalty;







