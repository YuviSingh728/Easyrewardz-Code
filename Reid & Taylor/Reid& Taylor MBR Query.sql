-- SELECT CASE WHEN visits<=10 THEN visits ELSE '10+' END AS Visits,COUNT(DISTINCT mobile)Transacting_Customers
-- FROM(
-- SELECT a.mobile,b.customertype,COUNT(DISTINCT txndate)visits,
-- SUM(amount)/COUNT(DISTINCT uniquebillno)ATV ,
-- SUM(amount)sales,
-- COUNT(DISTINCT uniquebillno)bills
-- FROM `reidtaylor`.txn_report_accrual_redemption a
-- JOIN  reidtaylor.member_report b
-- ON a.mobile=b.mobile
-- WHERE txndate <='2025-09-30'
-- AND modifiedbillno NOT LIKE '%test%' AND storecode NOT LIKE '%Demo%'
-- AND modifiedbillno NOT LIKE '%roll%' #and amount>0
-- AND b.customertype<>'employee'
-- GROUP BY 1)b
-- GROUP BY 1;


##################################################################################################################
# data check
SELECT COUNT(*) FROM reidtaylor.`txn_report_accrual_redemption`WHERE txndate<='2025-10-31'   AND frequencycount IS NULL;#0
SELECT COUNT(*) FROM reidtaylor.`txn_report_accrual_redemption`WHERE txndate<='2025-10-31'  AND dayssincelastvisit IS NULL;#0
SELECT COUNT(*) FROM reidtaylor.`sku_report_loyalty`WHERE modifiedtxndate<='2025-10-31'  AND frequencycount IS NULL;#0
SELECT COUNT(*) FROM reidtaylor.`sku_report_loyalty`WHERE modifiedtxndate<='2025-10-31'  AND dayssincelastvisit IS NULL;#0
SELECT MAX(txndate) FROM reidtaylor.txn_report_accrual_redemption;#2025-10-15


-- Lapsation

 #SET @RunningTotal=0 ;
 SET @RunningTotal1=0 ;


SELECT DSLV_band,#Bills AS`Repeat Bills`,(@RunningTotal := @RunningTotal + Bills)`Cumulative Repeat Bills`,
Cust Repeat_Customers ,(@RunningTotal1 := @RunningTotal1 + cust)`Cumulative Repeat Customers`
FROM
(
SELECT CASE WHEN  DaysSinceLastVisit >= 0 AND DaysSinceLastVisit <= 30 THEN '1-30'
    WHEN DaysSinceLastVisit >= 31 AND DaysSinceLastVisit <= 60 THEN '31-60'
    WHEN DaysSinceLastVisit >= 61 AND DaysSinceLastVisit <= 90 THEN '61-90'
    WHEN DaysSinceLastVisit >= 91 AND DaysSinceLastVisit <= 120 THEN '91-120'
    WHEN DaysSinceLastVisit >= 121 AND DaysSinceLastVisit <= 150 THEN '121-150'
    WHEN DaysSinceLastVisit >= 151 AND DaysSinceLastVisit <= 180 THEN '151-180'
    WHEN DaysSinceLastVisit >= 181 AND DaysSinceLastVisit <= 210 THEN '181-210'
    WHEN DaysSinceLastVisit >= 211 AND DaysSinceLastVisit <= 240 THEN '211-240'
    WHEN DaysSinceLastVisit >= 241 AND DaysSinceLastVisit <= 360 THEN '241-360'
    WHEN DaysSinceLastVisit >= 361 AND DaysSinceLastVisit <= 540 THEN '361-540'
    WHEN DaysSinceLastVisit >= 541 AND DaysSinceLastVisit <= 720 THEN '541-720'
    WHEN DaysSinceLastVisit > 720 THEN '720+' END DSLV_band,
COUNT(uniquebillno)AS Bills ,COUNT(DISTINCT mobile)cust
FROM reidtaylor.txn_report_accrual_redemption 
WHERE modifiedbillno NOT LIKE '%test%' AND storecode NOT LIKE '%Demo%'
AND modifiedbillno NOT LIKE '%roll%' 
AND txndate<'2025-10-31' AND amount>=1
AND mobile IN
(SELECT mobile FROM reidtaylor.txn_report_accrual_redemption
GROUP BY mobile
HAVING MAX(frequencycount)>1)
AND mobile NOT IN(SELECT DISTINCT mobile FROM reidtaylor.member_report WHERE customertype='employee')
GROUP BY 1
ORDER BY DaysSinceLastVisit )t;	



########################################## KPI  ##########################################

SELECT Time_Period,
COUNT(DISTINCT mobile)Customers,
SUM(sales)Loyalty_Sales,
SUM(bills)Loyalty_Bills,
COUNT(DISTINCT CASE WHEN max_f  =  1 AND min_f  =  1 THEN  mobile END)Onetimer,
SUM(CASE WHEN max_f  =  1 AND min_f  =  1 THEN sales END)Onetimer_Sales,
SUM(CASE WHEN max_f  =  1 AND min_f  =  1 THEN bills END)Onetimer_Bills,
COUNT(DISTINCT CASE WHEN max_f > 1 THEN  mobile END)Repeater,#SUM(CASE WHEN max_f > 1 THEN  sales END)Repeater_Sales,SUM(CASE WHEN max_f > 1 THEN  bills END)Repeater_Bills,
ROUND(SUM(sales)/SUM(bills),0) `Overall ATV`, 
ROUND(SUM(CASE WHEN max_f  =  1 AND min_f  =  1 THEN sales END)/SUM(CASE WHEN max_f  =  1 AND min_f  =  1 THEN bills END),0) `One Timer ATV`, 
ROUND(SUM(sales)/COUNT(DISTINCT Mobile),0) `Overall AMV`, 
ROUND(SUM(CASE WHEN max_f  =  1 AND min_f  =  1 THEN sales END)/COUNT(DISTINCT CASE WHEN max_f  =  1 AND min_f  =  1 THEN  mobile END),0) `One Timer AMV`
FROM(
SELECT CASE WHEN txndate BETWEEN '2025-10-01' AND '2025-10-31' THEN 'Oct25'
            WHEN txndate BETWEEN '2025-09-01' AND '2025-09-30' THEN 'Sep25'
	    WHEN txndate BETWEEN '2024-10-01' AND '2024-10-31' THEN 'Oct24' END AS Time_Period,
mobile,
MAX(frequencycount)max_f,
MIN(frequencycount) min_f,
SUM(amount)sales,
COUNT(DISTINCT Uniquebillno)bills
FROM `reidtaylor`.txn_report_accrual_redemption 
WHERE modifiedbillno NOT LIKE '%test%' 
AND storecode NOT LIKE '%Demo%'
AND modifiedbillno NOT LIKE '%roll%' AND insertiondate<CURDATE()
AND ((txndate BETWEEN '2025-10-01' AND '2025-10-31') OR
(txndate BETWEEN '2025-09-01' AND '2025-09-30') OR
(txndate BETWEEN '2024-10-01' AND '2024-10-31'))
AND mobile NOT IN(SELECT DISTINCT mobile FROM reidtaylor.member_report WHERE customertype='employee')
GROUP BY 1,2)b
GROUP BY 1;


-- Repeat KPI
SELECT CASE WHEN txndate BETWEEN '2025-10-01' AND '2025-10-31' THEN 'Oct25'
            WHEN txndate BETWEEN '2025-09-01' AND '2025-09-30' THEN 'Sep25'
	    WHEN txndate BETWEEN '2024-10-01' AND '2024-10-31' THEN 'Oct24' END AS Time_Period,
SUM(CASE WHEN frequencycount>1 THEN amount END) Repeat_Sales,
COUNT(DISTINCT (CASE WHEN FrequencyCount>1 THEN uniquebillno END)) Repeat_Bills,
ROUND(SUM(CASE WHEN frequencycount>1 THEN amount END)/COUNT(DISTINCT (CASE WHEN FrequencyCount>1 THEN uniquebillno END)),0) AS Repeat_ATV, 
ROUND(SUM(CASE WHEN frequencycount>1 THEN amount END)/COUNT(DISTINCT Mobile),0) Repeat_AMV 
#SUM(amount) LoyaltySales,COUNT(DISTINCT (CASE WHEN frequencycount>1 THEN mobile  END)) AS Repeaters, 
FROM `reidtaylor`.txn_report_accrual_redemption 
WHERE modifiedbillno NOT LIKE '%test%' 
AND storecode NOT LIKE '%Demo%'
AND modifiedbillno NOT LIKE '%roll%' AND insertiondate<CURDATE()
AND ((txndate BETWEEN '2025-10-01' AND '2025-10-31') OR
(txndate BETWEEN '2025-09-01' AND '2025-09-30') OR
(txndate BETWEEN '2024-10-01' AND '2024-10-31'))
AND mobile NOT IN(SELECT DISTINCT mobile FROM reidtaylor.member_report WHERE customertype='employee')
GROUP BY 1;

###################################################################  Last 13 Month Trends  ###############################


SELECT Time_Period,
COUNT(DISTINCT mobile)Customers,
SUM(sales)Loyalty_Sales,
SUM(bills)Loyalty_Bills,
COUNT(DISTINCT CASE WHEN max_f  =  1 AND min_f  =  1 THEN  mobile END)Onetimer,
SUM(CASE WHEN max_f  =  1 AND min_f  =  1 THEN sales END)Onetimer_Sales,
SUM(CASE WHEN max_f  =  1 AND min_f  =  1 THEN bills END)Onetimer_Bills,
COUNT(DISTINCT CASE WHEN max_f > 1 THEN  mobile END)Repeater,#SUM(CASE WHEN max_f > 1 THEN  sales END)Repeater_Sales,SUM(CASE WHEN max_f > 1 THEN  bills END)Repeater_Bills,
ROUND(SUM(sales)/SUM(bills),0) `Overall ATV`, 
ROUND(SUM(CASE WHEN max_f  =  1 AND min_f  =  1 THEN sales END)/SUM(CASE WHEN max_f  =  1 AND min_f  =  1 THEN bills END),0) `One Timer ATV`, 
ROUND(SUM(sales)/COUNT(DISTINCT Mobile),0) `Overall AMV`, 
ROUND(SUM(CASE WHEN max_f  =  1 AND min_f  =  1 THEN sales END)/COUNT(DISTINCT CASE WHEN max_f  =  1 AND min_f  =  1 THEN  mobile END),0) `One Timer AMV`
FROM(
SELECT CONCAT(LEFT(MONTHNAME(txndate),3),"-",YEAR(txndate)) AS Time_Period,
mobile,
MAX(frequencycount)max_f,
MIN(frequencycount) min_f,
SUM(amount)sales,
COUNT(DISTINCT Uniquebillno)bills
FROM `reidtaylor`.txn_report_accrual_redemption 
WHERE modifiedbillno NOT LIKE '%test%' 
AND storecode NOT LIKE '%Demo%'
AND modifiedbillno NOT LIKE '%roll%' AND insertiondate<CURDATE()
AND txndate <='2025-10-31'
AND mobile NOT IN(SELECT DISTINCT mobile FROM reidtaylor.member_report WHERE customertype='employee')
GROUP BY 1,2 ORDER BY txndate)b
GROUP BY 1 ORDER BY 1;


SELECT CONCAT(LEFT(MONTHNAME(txndate),3),"-",YEAR(txndate)) AS Time_Period,
SUM(CASE WHEN frequencycount>1 THEN amount END) Repeat_Sales,
COUNT(DISTINCT (CASE WHEN FrequencyCount>1 THEN uniquebillno END)) Repeat_Bills,
ROUND(SUM(CASE WHEN frequencycount>1 THEN amount END)/COUNT(DISTINCT (CASE WHEN FrequencyCount>1 THEN uniquebillno END)),0) AS Repeat_ATV, 
ROUND(SUM(CASE WHEN frequencycount>1 THEN amount END)/COUNT(DISTINCT Mobile),0) Repeat_AMV 
#SUM(amount) LoyaltySales,COUNT(DISTINCT (CASE WHEN frequencycount>1 THEN mobile  END)) AS Repeaters, 
FROM `reidtaylor`.txn_report_accrual_redemption 
WHERE modifiedbillno NOT LIKE '%test%' 
AND storecode NOT LIKE '%Demo%'
AND modifiedbillno NOT LIKE '%roll%' AND insertiondate<CURDATE()
AND txndate <='2025-10-31'
AND mobile NOT IN(SELECT DISTINCT mobile FROM reidtaylor.member_report WHERE customertype='employee')
GROUP BY 1;

################################################# BillBanding #################################################

SELECT
bill_band AS Overall,COUNT(DISTINCT mobile)Customers,SUM(Sales)`Loyalty Sales`,
COUNT(DISTINCT uniquebillno)`Loyalty Bills`,
CONCAT(ROUND(SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER (), 2), '%') AS `% Sales Contribution`,
CONCAT(ROUND(COUNT(DISTINCT uniquebillno) * 100.0 / SUM(COUNT(DISTINCT uniquebillno)) OVER (), 2), '%') AS  `% Bills Contribution`
FROM
(SELECT a.*,(CASE 	 WHEN sales >= 0 AND sales  <=500 THEN  '0-500'
 WHEN sales  >500 AND sales  <= 1000 THEN  '500-1000'
 WHEN sales  >1000 AND sales  <= 1500 THEN  '1000-1500'
 WHEN sales  >1500 AND sales  <= 2000 THEN  '1500-2000'
 WHEN sales  >2000 AND sales  <= 2500 THEN  '2000-2500'
 WHEN sales  >2500 AND sales  <= 3000 THEN  '2500-3000'
 WHEN sales  >3000 AND sales  <= 3500 THEN  '3000-3500'
 WHEN sales  >3500 AND sales  <= 4000 THEN  '3500-4000'
 WHEN sales  >4000 AND sales  <= 4500 THEN  '4000-4500'
 WHEN sales  >4500 AND sales  <= 5000 THEN  '4500-5000'
 WHEN sales >5000 THEN   '5000+' END )bill_band,uniquebillno skubill
			FROM
			(
			SELECT mobile,uniquebillno,SUM(amount) AS sales,COUNT(DISTINCT mobile,txndate)Frequency
			FROM `reidtaylor`.txn_report_accrual_redemption 
                        WHERE modifiedbillno NOT LIKE '%test%' 
                        AND storecode NOT LIKE '%Demo%'
                        AND modifiedbillno NOT LIKE '%roll%' AND insertiondate<CURDATE()
                        AND txndate BETWEEN '2025-10-01' AND '2025-10-31'
                        AND mobile NOT IN(SELECT DISTINCT mobile FROM reidtaylor.member_report WHERE customertype='employee')
                        GROUP BY 1,2
			)a 
			
)t1		
GROUP BY 1 ;	


################  Daywise ##########################################


SELECT DAYNAME(txndate)`WeekDay`,
SUM(amount)Loyalty_Sales,
COUNT(DISTINCT uniquebillno) Loyalty_Bills ,
CONCAT(ROUND(SUM(amount) * 100.0 / SUM(SUM(amount)) OVER (), 1), '%') AS `% Sales Contribution`,
CONCAT(ROUND(COUNT(DISTINCT uniquebillno) * 100.0 / SUM(COUNT(DISTINCT uniquebillno)) OVER (), 1), '%') AS `% Bills Contribution`
FROM `reidtaylor`.txn_report_accrual_redemption 
WHERE modifiedbillno NOT LIKE '%test%' 
AND storecode NOT LIKE '%Demo%'
AND modifiedbillno NOT LIKE '%roll%' AND insertiondate<CURDATE()
AND txndate BETWEEN '2025-10-01' AND '2025-10-31'
AND mobile NOT IN(SELECT DISTINCT mobile FROM reidtaylor.member_report WHERE customertype='employee')
GROUP BY 1
ORDER BY FIELD(DAYNAME(txndate), 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');
