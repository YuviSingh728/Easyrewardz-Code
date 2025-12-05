--  RFM
 
 CREATE TABLE dummy.inc5_RFM_till_Oct24 AS
SELECT txnmappedmobile,Recency,Totalvisits,Totalspend,Bills,ROUND(totalspend/Bills,2)ATV,Latency,first_txn_date,last_shopped_date,
PERCENT_RANK() OVER(ORDER BY recency DESC) Recency_PR,
PERCENT_RANK() OVER(ORDER BY totalvisits ASC) Frequency_PR,
PERCENT_RANK() OVER(ORDER BY totalspend ASC) Monetary_PR
FROM 
(SELECT txnmappedmobile,SUM(itemnetamount)totalspend,COUNT(DISTINCT uniquebillno)Bills,COUNT(DISTINCT modifiedtxndate)totalvisits,
DATEDIFF('2024-08-31',MAX(modifiedtxndate))recency,ROUND(DATEDIFF(MAX(modifiedtxndate),MIN(modifiedtxndate))/NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0))AS 'Latency',MIN(modifiedtxndate)first_txn_date,MAX(modifiedtxndate)last_shopped_date
FROM club5.`sku_report_loyalty`
WHERE modifiedtxndate<= '2024-10-31'
 AND txnmappedmobile<>'' GROUP BY 1)a
WHERE totalspend>0
GROUP BY 1;

ALTER TABLE dummy.inc5_RFM_till_Oct24 ADD INDEX mb(txnmappedmobile);
ALTER TABLE dummy.inc5_RFM_till_Oct24 ADD COLUMN(Recency_score INT,Frequency_score INT,Monetary_score INT, RFM_Score DOUBLE,RFM_Rank INT(10),`RFM Segment` VARCHAR(40));

-- RFM Groups
UPDATE dummy.inc5_RFM_till_Oct24 
SET Recency_score=
CASE WHEN recency_pr >= "0" AND recency_pr <= "0.20" THEN "20"
WHEN recency_pr > "0.20" AND recency_pr <=  "0.40" THEN "40"
WHEN recency_pr >  "0.40" AND recency_pr <=  "0.60" THEN "60"
WHEN recency_pr > "0.60" AND  recency_pr <= "0.80" THEN "80" 
WHEN recency_pr > "0.80" AND  recency_pr <= "1.00" THEN "100" END,
Frequency_score=
CASE WHEN frequency_pr >= "0" AND frequency_pr <= "0.20" THEN "20" 
WHEN frequency_pr > "0.20" AND frequency_pr <=  "0.40" THEN "40"
WHEN frequency_pr >  "0.40" AND frequency_pr <=  "0.60" THEN "60"
WHEN frequency_pr > "0.60" AND  frequency_pr <= "0.80" THEN "80"  
WHEN frequency_pr > "0.80" AND  frequency_pr <= "1.00" THEN "100"  END,
Monetary_score=
CASE WHEN monetary_pr >= "0" AND monetary_pr <= "0.20" THEN "20" 
WHEN monetary_pr > "0.20" AND monetary_pr <=  "0.40" THEN "40"
WHEN monetary_pr >  "0.40" AND monetary_pr <=  "0.60" THEN "60"
WHEN monetary_pr > "0.60" AND  monetary_pr <= "0.80" THEN "80"  
WHEN monetary_pr > "0.80" AND  monetary_pr <= "1.00" THEN "100"  END;#1004344


-- RFM Score: Weightage to Variables
UPDATE dummy.inc5_RFM_till_Oct24 SET RFM_Score= 20*((recency_score/20)*0.35 + (frequency_score/20)*.30 + (Monetary_score/20)*0.35);#
 

-- RFM Rank
UPDATE dummy.inc5_RFM_till_Oct24 a JOIN(
SELECT *,DENSE_RANK() OVER (ORDER BY RFM_score DESC,totalspend DESC,recency ASC,totalvisits DESC)Ranks FROM dummy.inc5_RFM_till_Oct24)b
ON a.txnmappedmobile=b.txnmappedmobile SET a.RFM_Rank=b.Ranks;#
 

##   lifesegment definition

ALTER TABLE dummy.inc5_RFM_till_Oct24 ADD COLUMN (`Cust Segment` VARCHAR(40),`Cust Type` VARCHAR(40));

ALTER TABLE dummy.inc5_RFM_till_Oct24 ADD COLUMN (Last_2yr_visits INT);

UPDATE  dummy.inc5_RFM_till_Oct24 a 
JOIN(SELECT txnmappedmobile,COUNT(DISTINCT modifiedtxndate)visit
FROM club5.`sku_report_loyalty`
WHERE modifiedtxndate>= '2022-09-01' AND  modifiedtxndate<= '2024-08-31'
AND insertiondate< CURDATE()
GROUP BY 1)b
USING(txnmappedmobile)
SET a.Last_2yr_visits=b.visit;

UPDATE dummy.inc5_RFM_till_Oct24 a SET a.Last_2yr_visits=0 WHERE Last_2yr_visits IS NULL;

 -- customers who have shopped in Festive Season in the last 2 years and  have high RFM score  
 
 ALTER TABLE dummy.inc5_RFM_till_Oct24 ADD COLUMN (Is_festive_shopper INT);

 UPDATE  dummy.inc5_RFM_till_Oct24 a 
JOIN(SELECT txnmappedmobile,modifiedtxndate
FROM club5.`sku_report_loyalty`
WHERE ((modifiedtxndate>= '2022-10-01' AND  modifiedtxndate<= '2022-12-31') OR
      (modifiedtxndate>= '2023-10-01' AND  modifiedtxndate<= '2023-12-31'))
AND insertiondate< CURDATE()
GROUP BY 1)b
USING(txnmappedmobile)
SET a.Is_festive_shopper=1;

UPDATE dummy.inc5_RFM_till_Oct24 a SET a.Is_festive_shopper=0 WHERE Is_festive_shopper IS NULL;

ALTER TABLE dummy.inc5_RFM_till_Oct24 ADD COLUMN (last_2yr_bills INT,last_2yr_discount_bills INT,last_2yr_%DiscountBill);
ALTER TABLE dummy.inc5_RFM_till_Oct24 ADD COLUMN (festive_Bills INT,festive_Discount_Bills INT,);

 UPDATE  dummy.inc5_RFM_till_Oct24 a 
JOIN(SELECT txnmappedmobile,
      COUNT(DISTINCT uniquebillno)festive_Bills,
      COUNT(DISTINCT(CASE WHEN (price*Itemqty)>Itemnetamount THEN uniquebillno END))festive_Discount_Bills
      FROM club5.`sku_report_loyalty` a JOIN club5.item_master b ON a.uniqueitemcode = b.uniqueitemcode
         WHERE ((modifiedtxndate>= '2022-10-01' AND  modifiedtxndate<= '2022-12-31') OR
              (modifiedtxndate>= '2023-10-01' AND  modifiedtxndate<= '2023-12-31'))AND a.insertiondate< CURDATE()
                  GROUP BY 1)b
USING(txnmappedmobile)
SET a.festive_Bills=b.festive_Bills,a.festive_Discount_Bills=b.festive_Discount_Bills;

UPDATE IGNORE dummy.inc5_RFM_till_Oct24 SET `%DiscountBill`=((festive_Discount_Bills/festive_Bills)*100);
 UPDATE  dummy.inc5_RFM_till_Oct24 SET `%DiscountBill`=0 WHERE `%DiscountBill` IS NULL;


UPDATE dummy.inc5_RFM_till_Oct24 a SET a.festive_Bills=0 WHERE festive_Bills IS NULL;
UPDATE dummy.inc5_RFM_till_Oct24 a SET a.festive_Discount_Bills=0 WHERE festive_Discount_Bills IS NULL;


 ALTER TABLE dummy.inc5_RFM_till_Oct24 ADD COLUMN (festive_Points_redeemed DECIMAL(10,2),festive_Points_collected DECIMAL(10,2));

 UPDATE  dummy.inc5_RFM_till_Oct24 a 
JOIN(SELECT Mobile,SUM(pointscollected)pointscollected,SUM(pointsspent)pointsspent
FROM club5.txn_report_accrual_redemption
WHERE ((txndate>= '2022-10-01' AND  txndate<= '2022-12-31') OR
      (txndate>= '2023-10-01' AND  txndate<= '2023-12-31'))
      AND modifiedbillno NOT LIKE '%test%'
AND modifiedbillno NOT LIKE '%roll%' 
GROUP BY 1
)b
ON a.txnmappedMobile=b.Mobile
SET a.festive_Points_redeemed=b.pointsspent,a.festive_Points_collected=b.pointscollected;

UPDATE dummy.inc5_RFM_till_Oct24 a SET a.festive_Points_redeemed=0 WHERE festive_Points_redeemed IS NULL;
UPDATE dummy.inc5_RFM_till_Oct24 a SET a.festive_Points_collected=0 WHERE festive_Points_collected IS NULL;


 ALTER TABLE dummy.inc5_RFM_till_Oct24 ADD COLUMN (`%Redemption_rate` VARCHAR(10)  ,`%DiscountBill` VARCHAR(10));
 
UPDATE IGNORE dummy.inc5_RFM_till_Oct24 SET `%Redemption_rate`=((festive_Points_redeemed/festive_Points_collected)*100);
 UPDATE  dummy.inc5_RFM_till_Oct24 SET `%Redemption_rate`=0 WHERE `%Redemption_rate` IS NULL;

 ALTER TABLE dummy.inc5_RFM_till_Oct24 ADD COLUMN (Is_festive_redeemer INT);

 UPDATE  dummy.inc5_RFM_till_Oct24 a 
JOIN(SELECT Mobile#,SUM(pointscollected)pointscollected,SUM(pointsspent)pointsspent
FROM club5.txn_report_accrual_redemption
WHERE ((txndate>= '2022-10-01' AND  txndate<= '2022-12-31') OR
      (txndate>= '2023-10-01' AND  txndate<= '2023-12-31'))
      AND modifiedbillno NOT LIKE '%test%'AND modifiedbillno NOT LIKE '%roll%' AND pointsspent>0
GROUP BY 1)b
ON a.txnmappedMobile=b.Mobile
SET a.Is_festive_redeemer=1;

UPDATE dummy.inc5_RFM_till_Oct24 a SET a.Is_festive_redeemer=0 WHERE Is_festive_redeemer IS NULL;

SELECT DISTINCT Is_festive_redeemer FROM dummy.inc5_RFM_till_Oct24;



ALTER TABLE dummy.inc5_RFM_till_Oct24 ADD COLUMN (State VARCHAR(50));

CREATE TABLE dummy.inc5_mobile_state
SELECT mobile,state FROM club5.member_report a
JOIN club5.store_master b ON a.enrolledstorecode = b.storecode;

ALTER TABLE dummy.inc5_mobile_state ADD INDEX mob(mobile);

UPDATE dummy.inc5_RFM_till_Oct24 a
JOIN dummy.inc5_mobile_state b ON a.txnmappedmobile = mobile
SET a.State=b.State;

SELECT * FROM dummy.inc5_RFM_till_Oct24 WHERE State IS NOT NULL;

#SELECT * FROM dummy.inc5_RFM_till_Oct24 WHERE Region IS NULL;

ALTER TABLE dummy.inc5_RFM_till_Oct24 ADD COLUMN (Fav_SubCategory VARCHAR(255),Fav_Category VARCHAR(255),Bill_count INT);


-- Fav catg & Sub Catg
UPDATE dummy.inc5_RFM_till_Oct24 p
JOIN(
SELECT txnmappedmobile,MAX(Bills)max_Bill,Bills,Category,subcategoryname
FROM(
SELECT txnmappedmobile,subcategoryname,GROUP_CONCAT(DISTINCT categoryname)Category,COUNT(DISTINCT uniquebillno)Bills#,sum(itemnetamount)sales
FROM club5.`sku_report_loyalty` a
JOIN club5.item_master b
ON a.uniqueitemcode=b.uniqueitemcode
WHERE ((modifiedtxndate>= '2022-10-01' AND modifiedtxndate<='2022-12-31') OR (modifiedtxndate>= '2023-10-01' AND modifiedtxndate<='2023-12-31')) 
AND txnmappedmobile<>''GROUP BY txnmappedmobile,subcategoryname
ORDER BY Bills DESC 
)b
GROUP BY 1
)q
ON p.txnmappedmobile=q.txnmappedmobile
SET p.Fav_SubCategory=q.subcategoryname,p.Fav_Category=q.Category,p.Bill_count=q.max_Bill;

ALTER TABLE dummy.inc5_RFM_till_Oct24 ADD COLUMN(`L-R` INT,Tag VARCHAR(10))#,Vintage INT,OT_repeater VARCHAR(10));

UPDATE dummy.inc5_RFM_till_Oct24 SET Latency=0 WHERE Latency IS NULL;#
UPDATE dummy.inc5_RFM_till_Oct24 SET `L-R`=Latency-Recency ;
ALTER TABLE dummy.inc5_RFM_till_Oct24 ADD COLUMN(is_Eoss_Buyer INT,Eoss_visits INT);

 UPDATE  dummy.inc5_RFM_till_Oct24 a 
JOIN(SELECT txnmappedmobile
FROM club5.`sku_report_loyalty`
WHERE ((modifiedtxndate>='2021-10-01' AND  modifiedtxndate<= '2021-12-31') OR
(modifiedtxndate>='2022-10-01' AND  modifiedtxndate<= '2022-12-31')OR
 (modifiedtxndate>='2023-10-01' AND  modifiedtxndate<= '2023-12-31'))
AND insertiondate< CURDATE()
GROUP BY 1)b
USING(txnmappedmobile)
SET a.is_Eoss_Buyer=1;

 UPDATE  dummy.inc5_RFM_till_Oct24 SET is_Eoss_Buyer=0 WHERE is_Eoss_Buyer IS NULL;

 UPDATE  dummy.inc5_RFM_till_Oct24 a 
JOIN(SELECT txnmappedmobile,COUNT(DISTINCT modifiedtxndate)visits
FROM club5.`sku_report_loyalty`
WHERE ((modifiedtxndate>='2021-10-01' AND  modifiedtxndate<= '2021-12-31') OR
(modifiedtxndate>='2022-10-01' AND  modifiedtxndate<= '2022-12-31')OR
 (modifiedtxndate>='2023-10-01' AND  modifiedtxndate<= '2023-12-31'))
AND insertiondate< CURDATE()
GROUP BY 1)b
USING(txnmappedmobile)
SET a.Eoss_visits=b.visits;

ALTER TABLE dummy.inc5_RFM_till_Oct24 ADD COLUMN (Last_3yr_visits INT);

UPDATE  dummy.inc5_RFM_till_Oct24 a 
JOIN(SELECT txnmappedmobile,COUNT(DISTINCT modifiedtxndate)visit
FROM club5.`sku_report_loyalty`
WHERE modifiedtxndate>= '2021-09-01' AND  modifiedtxndate<= '2024-08-31'
AND insertiondate< CURDATE()
GROUP BY 1)b
USING(txnmappedmobile)
SET a.Last_3yr_visits=b.visit;

ALTER TABLE dummy.inc5_RFM_till_Oct24 ADD COLUMN (Availablepoints DECIMAL(10,2));

UPDATE  dummy.inc5_RFM_till_Oct24 a 
JOIN(SELECT mobile,availablepoints
FROM club5.member_report
)b
ON a.txnmappedmobile=b.mobile
SET a.Availablepoints=b.availablepoints;

ALTER TABLE dummy.inc5_RFM_till_Oct24 ADD COLUMN (last_12M_pts_redeem DECIMAL(10,2),last_12M_pts_collected DECIMAL(10,2));

 UPDATE  dummy.inc5_RFM_till_Oct24 a 
JOIN(SELECT Mobile,SUM(pointscollected)pointscollected,SUM(pointsspent)pointsspent
FROM club5.txn_report_accrual_redemption
WHERE (txndate>= '2023-09-01' AND  txndate<= '2024-08-31') 
      AND modifiedbillno NOT LIKE '%test%' AND modifiedbillno NOT LIKE '%roll%' 
GROUP BY 1
)b
ON a.txnmappedMobile=b.Mobile
SET a.last_12M_pts_redeem=b.pointsspent,a.last_12M_pts_collected=b.pointscollected;

UPDATE dummy.inc5_RFM_till_Oct24 a SET a.last_12M_pts_redeem=0 WHERE last_12M_pts_redeem IS NULL;
UPDATE dummy.inc5_RFM_till_Oct24 a SET a.last_12M_pts_collected=0 WHERE last_12M_pts_collected IS NULL;

ALTER TABLE dummy.inc5_RFM_till_Oct24 ADD COLUMN (last_12M_bills INT,last_12M_discount_bill INT);

 UPDATE  dummy.inc5_RFM_till_Oct24 a 
JOIN(SELECT txnmappedmobile,
COUNT(DISTINCT uniquebillno)last_12M_bills,
#COUNT(DISTINCT(CASE WHEN itemdiscountamount=0 THEN uniquebillno END))last_12M_bills,
COUNT(DISTINCT(CASE WHEN itemdiscountamount>0 THEN uniquebillno END))last_12M_discount_bill
FROM club5.`sku_report_loyalty`
WHERE (modifiedtxndate>= '2023-09-01' AND  modifiedtxndate<= '2024-08-31')
AND insertiondate< CURDATE()
GROUP BY 1)b
USING(txnmappedmobile)
SET a.last_12M_bills=b.last_12M_bills,a.last_12M_discount_bill=b.last_12M_discount_bill;


UPDATE dummy.inc5_RFM_till_Oct24 a SET a.last_12M_bills=0 WHERE last_12M_bills IS NULL;
UPDATE dummy.inc5_RFM_till_Oct24 a SET a.last_12M_discount_bill=0 WHERE last_12M_discount_bill IS NULL;


ALTER TABLE dummy.inc5_RFM_till_Oct24 ADD COLUMN (last_3Yr_bills INT,last_3Y_discount_bill INT);

 UPDATE  dummy.inc5_RFM_till_Oct24 a 
JOIN(SELECT txnmappedmobile,
COUNT(DISTINCT uniquebillno)last_3Yr_bills,
#COUNT(DISTINCT(CASE WHEN itemdiscountamount=0 THEN uniquebillno END))last_3Yr_bills,
COUNT(DISTINCT(CASE WHEN itemdiscountamount>0 THEN uniquebillno END))last_3Y_discount_bill
FROM club5.`sku_report_loyalty`
WHERE (modifiedtxndate>= '2021-09-01' AND  modifiedtxndate<= '2024-08-31')
AND insertiondate< CURDATE()
GROUP BY 1)b
USING(txnmappedmobile)
SET a.last_3Yr_bills=b.last_3Yr_bills,a.last_3Y_discount_bill=b.last_3Y_discount_bill;


UPDATE dummy.inc5_RFM_till_Oct24 a SET a.last_3Yr_bills=0 WHERE last_3Yr_bills IS NULL;
UPDATE dummy.inc5_RFM_till_Oct24 a SET a.last_3Y_discount_bill=0 WHERE last_3Y_discount_bill IS NULL;


 ALTER TABLE dummy.inc5_RFM_till_Oct24 ADD COLUMN (`last_12M_%redemption_rate` VARCHAR(10)  ,`last_12M_%dis_bill` VARCHAR(10),`last_3Y_%dis_bill` VARCHAR(10)
 );
 

 UPDATE IGNORE dummy.inc5_RFM_till_Oct24 SET `last_12M_%redemption_rate`=((last_12M_pts_redeem/last_12M_pts_collected)*100);
 UPDATE  dummy.inc5_RFM_till_Oct24 SET `last_12M_%redemption_rate`= 0 WHERE `last_12M_%redemption_rate` IS NULL;


 UPDATE IGNORE dummy.inc5_RFM_till_Oct24 SET `last_12M_%dis_bill`=((last_12M_discount_bill/last_12M_bills)*100);
 UPDATE  dummy.inc5_RFM_till_Oct24 SET`last_12M_%dis_bill`=0 WHERE`last_12M_%dis_bill` IS NULL;
 
 
  UPDATE IGNORE dummy.inc5_RFM_till_Oct24 SET `last_3Y_%dis_bill`=((last_3Y_discount_bill/last_3Yr_bills)*100);
 UPDATE  dummy.inc5_RFM_till_Oct24 SET `last_3Y_%dis_bill`=0 WHERE `last_3Y_%dis_bill` IS NULL;
 
ALTER TABLE dummy.inc5_RFM_till_Oct24 ADD COLUMN (last_2yr_bills INT,last_2yr_discount_bills INT,`last_2yr_%DiscountBill` VARCHAR(10));

UPDATE dummy.inc5_RFM_till_Oct24 
SET last_2yr_bills = NULL,
    last_2yr_discount_bills = NULL,
   `last_2yr_%DiscountBill` = NULL;
    

UPDATE  dummy.inc5_RFM_till_Oct24 a 
JOIN(SELECT txnmappedmobile,
      COUNT(DISTINCT uniquebillno)last_2yr_bills,
      COUNT(DISTINCT(CASE WHEN (price*Itemqty)>Itemnetamount THEN uniquebillno END))last_2yr_discount_bills
      FROM club5.`sku_report_loyalty` a JOIN club5.item_master b ON a.uniqueitemcode = b.uniqueitemcode
         WHERE modifiedtxndate>= '2022-09-01' AND  modifiedtxndate<= '2024-08-31' AND a.insertiondate< CURDATE()
                  GROUP BY 1)b
USING(txnmappedmobile)
SET a.last_2yr_bills = b.last_2yr_bills,
a.last_2yr_discount_bills = b.last_2yr_discount_bills;

UPDATE  dummy.inc5_RFM_till_Oct24 SET `last_2yr_%DiscountBill` =((last_2yr_discount_bills/last_2yr_bills)*100);
UPDATE  dummy.inc5_RFM_till_Oct24 SET `last_2yr_%DiscountBill`= 0 WHERE `last_2yr_%DiscountBill` IS NULL;

SELECT * FROM dummy.inc5_RFM_till_Oct24;