USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateAdditionalDayRate]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE Procedure [dbo].[UpdateAdditionalDayRate]
as
 

---- 'DSI', 'COI' 
--Update Quoted_Time_Period_Rate Set Time_Period_End=1
----select *
--FROM         dbo.Quoted_Vehicle_Rate 
--INNER JOIN dbo.Quoted_Time_Period_Rate 
--	ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Quoted_Time_Period_Rate.Quoted_Rate_ID 
--INNER JOIN dbo.Reservation 
--	ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Reservation.Quoted_Rate_ID
--where  dbo.Quoted_Vehicle_Rate.Rate_Name in ('DSI', 'COI'  ) and Status='a' --and datediff(mi, dbo.Reservation.Pick_Up_On, dbo.Reservation.Drop_Off_On)/1440.00>11
--And Time_Period='Week' and Time_Period_End<>1




---- Extension Rate Amount
--Update Quoted_Time_Period_Rate Set Amount=Round(TimePeriodWeekly.Amount/4.00, 2)+15
----select Quoted_Time_Period_Rate.amount, Round(TimePeriodWeekly.Amount/4.00, 2)+15   
--FROM         dbo.Quoted_Vehicle_Rate 
--INNER JOIN dbo.Quoted_Time_Period_Rate 
--	ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Quoted_Time_Period_Rate.Quoted_Rate_ID 
--INNER JOIN (select * from dbo.Quoted_Time_Period_Rate where Time_Period='Week') TimePeriodWeekly
--	 ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID=TimePeriodWeekly.Quoted_Rate_ID	
--INNER JOIN dbo.Reservation 
--	ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Reservation.Quoted_Rate_ID
                      
--where  dbo.Quoted_Vehicle_Rate.Rate_Name in ('DSI', 'COI' ) and Status='a' --and datediff(mi, dbo.Reservation.Pick_Up_On, dbo.Reservation.Drop_Off_On)/1440.00<=11
--		And Quoted_Time_Period_Rate.Time_Period='Day' and Quoted_Time_Period_Rate.Time_Period_Start>=8  and Quoted_Time_Period_Rate.Amount<>Round(TimePeriodWeekly.Amount/4.00, 2)+15
		





---- API
--Update Quoted_Time_Period_Rate Set Time_Period_End=5
----select   Quoted_Time_Period_Rate.*
--FROM         dbo.Quoted_Vehicle_Rate INNER JOIN
--                      dbo.Quoted_Time_Period_Rate ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Quoted_Time_Period_Rate.Quoted_Rate_ID INNER JOIN
--                      dbo.Reservation ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Reservation.Quoted_Rate_ID
--where  dbo.Quoted_Vehicle_Rate.Rate_Name in ('API' ) and Status='a'  and Time_Period='Day' and  Time_Period_Start=1 and Time_Period_End<>5


---- Create Additional Day Rate
--Insert Into Quoted_Time_Period_Rate
--SELECT     qtp.Quoted_Rate_ID, qtp.Rate_Type, qtp.Time_Period, 6 AS Time_Period_Start, 9999 AS Time_Period_End, 
--			(case when res.pick_up_on<'15 dec 2011'
--					then qtp.Amount + 20.00 
--					else qtp.Amount + 30.00
--			end) AS Expr1, 

--			 qtp.Km_Cap
--FROM         dbo.Quoted_Vehicle_Rate AS qvr INNER JOIN
--                      dbo.Quoted_Time_Period_Rate AS qtp ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID INNER JOIN
--                      dbo.Reservation AS res ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID
--WHERE     (qvr.Rate_Name IN ('API' )) AND (res.Status = 'a') AND (qtp.Time_Period = 'Day') AND (qtp.Time_Period_Start = 1) and  not EXISTS
--(Select ExQtp.Quoted_Rate_ID  from Quoted_Time_Period_Rate ExQtp where ExQtp.Time_Period = 'Day' and ExQtp.Time_Period_Start=6 
--and ExQtp.Quoted_Rate_ID=qvr.Quoted_Rate_ID)



---- Remove Weekly Rate
--Delete Quoted_Time_Period_Rate
----select   Quoted_Time_Period_Rate.*
--FROM         dbo.Quoted_Vehicle_Rate INNER JOIN
--                      dbo.Quoted_Time_Period_Rate ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Quoted_Time_Period_Rate.Quoted_Rate_ID INNER JOIN
--                      dbo.Reservation ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Reservation.Quoted_Rate_ID
--where  dbo.Quoted_Vehicle_Rate.Rate_Name in ('API' ) and Status='a'  and Time_Period='Week' and  Time_Period_Start=1


	


---- ASI
--Update Quoted_Time_Period_Rate Set Time_Period_End=1
----select   Quoted_Time_Period_Rate.*,dbo.Reservation.pick_up_on
--FROM         dbo.Quoted_Vehicle_Rate INNER JOIN
--                      dbo.Quoted_Time_Period_Rate ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Quoted_Time_Period_Rate.Quoted_Rate_ID INNER JOIN
--                      dbo.Reservation ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Reservation.Quoted_Rate_ID
--where  dbo.Quoted_Vehicle_Rate.Rate_Name in ('ASI' ) and Status='a'  and Time_Period='Day' and  Time_Period_Start=1 and Time_Period_End<>1


---- Create Additional Day Rate
--Insert Into Quoted_Time_Period_Rate
--SELECT	 	
--			qtp.Quoted_Rate_ID, 
--			qtp.Rate_Type, 
--			qtp.Time_Period, 
--			2 AS Time_Period_Start, 
--			9999 AS Time_Period_End, 
--			(case when res.pick_up_on<'15 dec 2011'
--					then qtp.Amount
--					else qtp.Amount + 30.00
--			end) AS Expr1, 
--			qtp.Km_Cap
--FROM         dbo.Quoted_Vehicle_Rate AS qvr INNER JOIN
--                      dbo.Quoted_Time_Period_Rate AS qtp ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID INNER JOIN
--                      dbo.Reservation AS res ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID
--WHERE     (qvr.Rate_Name IN ('ASI')) AND (res.Status = 'a') AND (qtp.Time_Period = 'Day') AND (qtp.Time_Period_Start = 1) and  not EXISTS
--(Select ExQtp.Quoted_Rate_ID  from Quoted_Time_Period_Rate ExQtp where ExQtp.Time_Period = 'Day' and ExQtp.Time_Period_Start=2
--and ExQtp.Quoted_Rate_ID=qvr.Quoted_Rate_ID)
                      
	
---- Remove Weekly Rate
--Delete Quoted_Time_Period_Rate
----select   Quoted_Time_Period_Rate.*
--FROM         dbo.Quoted_Vehicle_Rate INNER JOIN
--                      dbo.Quoted_Time_Period_Rate ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Quoted_Time_Period_Rate.Quoted_Rate_ID INNER JOIN
--                      dbo.Reservation ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Reservation.Quoted_Rate_ID
--where  dbo.Quoted_Vehicle_Rate.Rate_Name in ('ASI' ) and Status='a'  and Time_Period='Week' and  Time_Period_Start=1



---- ARI 
--Update Quoted_Time_Period_Rate Set Time_Period_End=2
----select   Quoted_Time_Period_Rate.*,dbo.Reservation.pick_up_on
--FROM         dbo.Quoted_Vehicle_Rate INNER JOIN
--                      dbo.Quoted_Time_Period_Rate ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Quoted_Time_Period_Rate.Quoted_Rate_ID INNER JOIN
--                      dbo.Reservation ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Reservation.Quoted_Rate_ID
--where  dbo.Quoted_Vehicle_Rate.Rate_Name in ('ARI' ) and Status='a'  and Time_Period='Day' and  Time_Period_Start=1 and Time_Period_End<>2


---- Create Additional Day Rate
--Insert Into Quoted_Time_Period_Rate
--SELECT	--distinct	
--			qtp.Quoted_Rate_ID, 
--			qtp.Rate_Type, 
--			qtp.Time_Period, 
--			3 AS Time_Period_Start, 
--			9999 AS Time_Period_End, 
--			(case when res.pick_up_on<'15 dec 2011'
--					then qtp.Amount
--					else qtp.Amount + 30.00
--			end) AS Expr1, 
--			qtp.Km_Cap
--FROM         dbo.Quoted_Vehicle_Rate AS qvr INNER JOIN
--                      dbo.Quoted_Time_Period_Rate AS qtp ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID INNER JOIN
--                      dbo.Reservation AS res ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID
--WHERE     (qvr.Rate_Name IN ('ARI')) AND (res.Status = 'a') AND (qtp.Time_Period = 'Day') AND (qtp.Time_Period_Start = 1) and  not EXISTS
--(Select ExQtp.Quoted_Rate_ID  from Quoted_Time_Period_Rate ExQtp where ExQtp.Time_Period = 'Day' and ExQtp.Time_Period_Start=3
--and ExQtp.Quoted_Rate_ID=qvr.Quoted_Rate_ID)
                      
	
---- Remove Weekly Rate
--Delete Quoted_Time_Period_Rate
----select   Quoted_Time_Period_Rate.*
--FROM         dbo.Quoted_Vehicle_Rate INNER JOIN
--                      dbo.Quoted_Time_Period_Rate ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Quoted_Time_Period_Rate.Quoted_Rate_ID INNER JOIN
--                      dbo.Reservation ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Reservation.Quoted_Rate_ID
--where  dbo.Quoted_Vehicle_Rate.Rate_Name in ('ARI' ) and Status='a'  and Time_Period='Week' and  Time_Period_Start=1


---- BOI  
--Update Quoted_Time_Period_Rate Set Time_Period_End=3
----select   Quoted_Time_Period_Rate.*,dbo.Reservation.pick_up_on
--FROM         dbo.Quoted_Vehicle_Rate INNER JOIN
--                      dbo.Quoted_Time_Period_Rate ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Quoted_Time_Period_Rate.Quoted_Rate_ID INNER JOIN
--                      dbo.Reservation ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Reservation.Quoted_Rate_ID
--where  dbo.Quoted_Vehicle_Rate.Rate_Name in ('AGI' ) and Status='a'  and Time_Period='Day' and  Time_Period_Start=1 and Time_Period_End<>3


---- Create Additional Day Rate
--Insert Into Quoted_Time_Period_Rate
--SELECT		--distinct
--			qtp.Quoted_Rate_ID, 
--			qtp.Rate_Type, 
--			qtp.Time_Period, 
--			4 AS Time_Period_Start, 
--			9999 AS Time_Period_End, 
--			(case when res.pick_up_on<'15 dec 2011'
--					then qtp.Amount
--					else qtp.Amount + 30.00
--			end) AS Expr1, 
--			qtp.Km_Cap
--FROM         dbo.Quoted_Vehicle_Rate AS qvr INNER JOIN
--                      dbo.Quoted_Time_Period_Rate AS qtp ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID INNER JOIN
--                      dbo.Reservation AS res ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID
--WHERE     (qvr.Rate_Name IN ('AGI')) AND (res.Status = 'a') AND (qtp.Time_Period = 'Day') AND (qtp.Time_Period_Start = 1) and  not EXISTS
--(Select ExQtp.Quoted_Rate_ID  from Quoted_Time_Period_Rate ExQtp where ExQtp.Time_Period = 'Day' and ExQtp.Time_Period_Start=4
--and ExQtp.Quoted_Rate_ID=qvr.Quoted_Rate_ID)
                      
	
---- Remove Weekly Rate
--Delete Quoted_Time_Period_Rate
----select   Quoted_Time_Period_Rate.*
--FROM         dbo.Quoted_Vehicle_Rate INNER JOIN
--                      dbo.Quoted_Time_Period_Rate ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Quoted_Time_Period_Rate.Quoted_Rate_ID INNER JOIN
--                      dbo.Reservation ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Reservation.Quoted_Rate_ID
--where  dbo.Quoted_Vehicle_Rate.Rate_Name in ('AGI' ) and Status='a'  and Time_Period='Week' and  Time_Period_Start=1


		
				



---************************************ New Logic Start here **************************************
-- Daily
--**************************************************************************************************

--- AEI

Update Quoted_Time_Period_Rate Set Time_Period_End=1

--SELECT qtp.Quoted_Rate_ID,qtp.Rate_Type, qtp.Time_Period,qtp.Time_Period_Start,qtp.Time_Period_End, qtp.Amount,qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day  RAD	    
		ON res.Vehicle_Class_Code =RAD.Vehicle_Class_Code 
		    AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
			AND res.pick_up_on>=   RAD.Valid_From and	  res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('ASI')) AND (res.Status = 'a') AND (qtp.Time_Period = 'Day') AND (qtp.Time_Period_Start = 1) AND (qtp.Time_Period_End <> 1)

Insert Into Quoted_Time_Period_Rate
SELECT --distinct 
qtp.Quoted_Rate_ID, qtp.Rate_Type, qtp.Time_Period, 2 AS Time_Period_Start, 9999 AS Time_Period_End, 
               qtp.Amount +RAD.Amount_Adjusted AdditionalDateRate, qtp.Km_Cap 
               
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day RAD 
		ON qvr.Rate_Name =RAD.Rate_Name 
           AND res.Vehicle_Class_Code = RAD.Vehicle_Class_Code
           AND res.Pick_Up_Location_ID = RAD.Location_ID
           AND res.pick_up_on>=   RAD.Valid_From and res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('ASI')) AND (res.Status = 'a') AND (qtp.Time_Period = 'Day') AND (qtp.Time_Period_Start = 1) AND (NOT EXISTS
                   (SELECT Quoted_Rate_ID
                    FROM   dbo.Quoted_Time_Period_Rate AS ExQtp
                    WHERE (Time_Period = 'Day') AND (Time_Period_Start = 2) AND (Quoted_Rate_ID = qvr.Quoted_Rate_ID)))
                    
	
-- Remove Weekly Rate
Delete Quoted_Time_Period_Rate
--SELECT qtp.Quoted_Rate_ID, qtp.Rate_Type, qtp.Time_Period, qtp.Time_Period_Start, qtp.Time_Period_End, qtp.Amount, qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day AS RAD 
		ON res.Vehicle_Class_Code = RAD.Vehicle_Class_Code 
			AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
            AND res.pick_up_on>=   RAD.Valid_From and res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('ASI')) AND (res.Status = 'a') AND (qtp.Time_Period = 'Week') AND (qtp.Time_Period_Start = 1)
                      




--- AEI

Update Quoted_Time_Period_Rate Set Time_Period_End=2

--SELECT qtp.Quoted_Rate_ID,qtp.Rate_Type, qtp.Time_Period,qtp.Time_Period_Start,qtp.Time_Period_End, qtp.Amount,qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day  RAD
		ON res.Vehicle_Class_Code =RAD.Vehicle_Class_Code 
			AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
			AND res.pick_up_on>=   RAD.Valid_From and	  res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('AEI','AOI','ARI')) AND (res.Status = 'a') AND (qtp.Time_Period = 'Day') AND (qtp.Time_Period_Start = 1) AND (qtp.Time_Period_End <> 2)

Insert Into Quoted_Time_Period_Rate
SELECT --distinct 
qtp.Quoted_Rate_ID, qtp.Rate_Type, qtp.Time_Period, 3 AS Time_Period_Start, 9999 AS Time_Period_End, 
               qtp.Amount +RAD.Amount_Adjusted AdditionalDateRate, qtp.Km_Cap 
               
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day RAD 
		ON qvr.Rate_Name =RAD.Rate_Name 
			AND res.Pick_Up_Location_ID = RAD.Location_ID	
           AND res.Vehicle_Class_Code = RAD.Vehicle_Class_Code
           AND res.pick_up_on>=   RAD.Valid_From and res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('AEI','AOI','ARI')) AND (res.Status = 'a') AND (qtp.Time_Period = 'Day') AND (qtp.Time_Period_Start = 1) AND (NOT EXISTS
                   (SELECT Quoted_Rate_ID
                    FROM   dbo.Quoted_Time_Period_Rate AS ExQtp
                    WHERE (Time_Period = 'Day') AND (Time_Period_Start = 3) AND (Quoted_Rate_ID = qvr.Quoted_Rate_ID)))
                    
	
-- Remove Weekly Rate
Delete Quoted_Time_Period_Rate
--SELECT qtp.Quoted_Rate_ID, qtp.Rate_Type, qtp.Time_Period, qtp.Time_Period_Start, qtp.Time_Period_End, qtp.Amount, qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day AS RAD 
		ON res.Vehicle_Class_Code = RAD.Vehicle_Class_Code 
			AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
            AND res.pick_up_on>=   RAD.Valid_From and res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('AEI','AOI','ARI')) AND (res.Status = 'a') AND (qtp.Time_Period = 'Week') AND (qtp.Time_Period_Start = 1)
                      
--AFI

  
Update Quoted_Time_Period_Rate Set Time_Period_End=3

--SELECT qtp.Quoted_Rate_ID,qtp.Rate_Type, qtp.Time_Period,qtp.Time_Period_Start,qtp.Time_Period_End, qtp.Amount,qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day  RAD
		ON res.Vehicle_Class_Code =RAD.Vehicle_Class_Code 
			AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
			AND res.pick_up_on>=   RAD.Valid_From and	  res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('AFI','BII')) AND (res.Status = 'a') AND (qtp.Time_Period = 'Day') AND (qtp.Time_Period_Start = 1) AND (qtp.Time_Period_End <> 3)

Insert Into Quoted_Time_Period_Rate
SELECT --distinct 
qtp.Quoted_Rate_ID, qtp.Rate_Type, qtp.Time_Period, 4 AS Time_Period_Start, 9999 AS Time_Period_End, 
               qtp.Amount +RAD.Amount_Adjusted AdditionalDateRate, qtp.Km_Cap 
               
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day RAD 
		ON qvr.Rate_Name =RAD.Rate_Name 
		   AND res.Pick_Up_Location_ID = RAD.Location_ID
           AND res.Vehicle_Class_Code = RAD.Vehicle_Class_Code
           AND res.pick_up_on>=   RAD.Valid_From and res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('AFI','BII')) AND (res.Status = 'a') AND (qtp.Time_Period = 'Day') AND (qtp.Time_Period_Start = 1) AND (NOT EXISTS
                   (SELECT Quoted_Rate_ID
                    FROM   dbo.Quoted_Time_Period_Rate AS ExQtp
                    WHERE (Time_Period = 'Day') AND (Time_Period_Start = 4) AND (Quoted_Rate_ID = qvr.Quoted_Rate_ID)))
                    
	
-- Remove Weekly Rate
Delete Quoted_Time_Period_Rate
--SELECT qtp.Quoted_Rate_ID, qtp.Rate_Type, qtp.Time_Period, qtp.Time_Period_Start, qtp.Time_Period_End, qtp.Amount, qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day AS RAD 
		ON res.Vehicle_Class_Code = RAD.Vehicle_Class_Code 
			AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
            AND res.pick_up_on>=   RAD.Valid_From and res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('AFI','BII')) AND (res.Status = 'a') AND (qtp.Time_Period = 'Week') AND (qtp.Time_Period_Start = 1)
                      




--- A7I, AMI

Update Quoted_Time_Period_Rate Set Time_Period_End=4

--SELECT qtp.Quoted_Rate_ID,qtp.Rate_Type, qtp.Time_Period,qtp.Time_Period_Start,qtp.Time_Period_End, qtp.Amount,qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day  RAD
		ON res.Vehicle_Class_Code =RAD.Vehicle_Class_Code 
			AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
			AND res.pick_up_on>=   RAD.Valid_From and	  res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('A7I', 'AMI')) AND (res.Status = 'a') AND (qtp.Time_Period = 'Day') AND (qtp.Time_Period_Start = 1) AND (qtp.Time_Period_End <> 4)

Insert Into Quoted_Time_Period_Rate
SELECT --distinct 
qtp.Quoted_Rate_ID, qtp.Rate_Type, qtp.Time_Period, 5 AS Time_Period_Start, 9999 AS Time_Period_End, 
               qtp.Amount +RAD.Amount_Adjusted AdditionalDateRate, qtp.Km_Cap 
               
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day RAD 
		ON qvr.Rate_Name =RAD.Rate_Name 
		   AND res.Pick_Up_Location_ID = RAD.Location_ID
           AND res.Vehicle_Class_Code = RAD.Vehicle_Class_Code
           AND res.pick_up_on>=   RAD.Valid_From and res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('A7I', 'AMI')) AND (res.Status = 'a') AND (qtp.Time_Period = 'Day') AND (qtp.Time_Period_Start = 1) AND (NOT EXISTS
                   (SELECT Quoted_Rate_ID
                    FROM   dbo.Quoted_Time_Period_Rate AS ExQtp
                    WHERE (Time_Period = 'Day') AND (Time_Period_Start = 5) AND (Quoted_Rate_ID = qvr.Quoted_Rate_ID)))
                    
	
-- Remove Weekly Rate
Delete Quoted_Time_Period_Rate
--SELECT qtp.Quoted_Rate_ID, qtp.Rate_Type, qtp.Time_Period, qtp.Time_Period_Start, qtp.Time_Period_End, qtp.Amount, qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day AS RAD 
		ON res.Vehicle_Class_Code = RAD.Vehicle_Class_Code 
			AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
            AND res.pick_up_on>=   RAD.Valid_From and res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('A7I',   'AMI' )) AND (res.Status = 'a') AND (qtp.Time_Period = 'Week') AND (qtp.Time_Period_Start = 1)
                      

-- A8I A9I
Update Quoted_Time_Period_Rate Set Time_Period_End=5

--SELECT qtp.Quoted_Rate_ID,qtp.Rate_Type, qtp.Time_Period,qtp.Time_Period_Start,qtp.Time_Period_End, qtp.Amount,qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day  RAD
		ON res.Vehicle_Class_Code =RAD.Vehicle_Class_Code 
			AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
			AND res.pick_up_on>=   RAD.Valid_From and	  res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('A8I', 'A9I')) AND (res.Status = 'a') AND (qtp.Time_Period = 'Day') AND (qtp.Time_Period_Start = 1) AND (qtp.Time_Period_End <> 5)

Insert Into Quoted_Time_Period_Rate
SELECT --distinct 
qtp.Quoted_Rate_ID, qtp.Rate_Type, qtp.Time_Period, 6 AS Time_Period_Start, 9999 AS Time_Period_End, 
               qtp.Amount +RAD.Amount_Adjusted AdditionalDateRate, qtp.Km_Cap 
               
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day RAD 
		ON qvr.Rate_Name =RAD.Rate_Name 
		   AND res.Pick_Up_Location_ID = RAD.Location_ID
           AND res.Vehicle_Class_Code = RAD.Vehicle_Class_Code
           AND res.pick_up_on>=   RAD.Valid_From and res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('A8I', 'A9I')) AND (res.Status = 'a') AND (qtp.Time_Period = 'Day') AND (qtp.Time_Period_Start = 1) AND (NOT EXISTS
                   (SELECT Quoted_Rate_ID
                    FROM   dbo.Quoted_Time_Period_Rate AS ExQtp
                    WHERE (Time_Period = 'Day') AND (Time_Period_Start = 6) AND (Quoted_Rate_ID = qvr.Quoted_Rate_ID)))
                    
	
-- Remove Weekly Rate
Delete Quoted_Time_Period_Rate
--SELECT qtp.Quoted_Rate_ID, qtp.Rate_Type, qtp.Time_Period, qtp.Time_Period_Start, qtp.Time_Period_End, qtp.Amount, qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day AS RAD 
		ON res.Vehicle_Class_Code = RAD.Vehicle_Class_Code 
			AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
            AND res.pick_up_on>=   RAD.Valid_From and res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('A8I', 'A9I')) AND (res.Status = 'a') AND (qtp.Time_Period = 'Week') AND (qtp.Time_Period_Start = 1)
                      
 
 --BPI, BQI, F1I,JWI 
 
 Update Quoted_Time_Period_Rate Set Time_Period_End=5

--SELECT qtp.Quoted_Rate_ID,qvr.Rate_Name,qtp.Rate_Type, qtp.Time_Period,qtp.Time_Period_Start,qtp.Time_Period_End, qtp.Amount,qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day  RAD
		ON res.Vehicle_Class_Code =RAD.Vehicle_Class_Code 
			AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
			AND res.pick_up_on>=   RAD.Valid_From and	  res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('BPI', 'BQI','L1I', 'F1I','JWI','ADI','AII','AGI', 'API')) AND (res.Status = 'a') AND (qtp.Time_Period = 'Day') AND (qtp.Time_Period_Start = 1) AND (qtp.Time_Period_End <> 5)

Insert Into Quoted_Time_Period_Rate
SELECT --distinct 
qtp.Quoted_Rate_ID, qtp.Rate_Type, qtp.Time_Period, 6 AS Time_Period_Start, 9999 AS Time_Period_End, 
               qtp.Amount +RAD.Amount_Adjusted AdditionalDateRate, qtp.Km_Cap 
               
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day RAD 
		ON qvr.Rate_Name =RAD.Rate_Name 
		   AND res.Pick_Up_Location_ID = RAD.Location_ID
           AND res.Vehicle_Class_Code = RAD.Vehicle_Class_Code
           AND res.pick_up_on>=   RAD.Valid_From and res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('BPI', 'BQI','L1I', 'F1I','JWI','ADI','AII','AGI', 'API')) AND (res.Status = 'a') AND (qtp.Time_Period = 'Day') AND (qtp.Time_Period_Start = 1) AND (NOT EXISTS
                   (SELECT Quoted_Rate_ID
                    FROM   dbo.Quoted_Time_Period_Rate AS ExQtp
                    WHERE (Time_Period = 'Day') AND (Time_Period_Start = 6) AND (Quoted_Rate_ID = qvr.Quoted_Rate_ID)))
                    
	
-- Remove Weekly Rate
Delete Quoted_Time_Period_Rate
--SELECT qtp.Quoted_Rate_ID, qtp.Rate_Type, qtp.Time_Period, qtp.Time_Period_Start, qtp.Time_Period_End, qtp.Amount, qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day AS RAD 
		ON res.Vehicle_Class_Code = RAD.Vehicle_Class_Code 
		 AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
            AND res.pick_up_on>=   RAD.Valid_From and res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('BPI', 'BQI','L1I', 'F1I','JWI', 'ADI', 'AII','AGI', 'API')) AND (res.Status = 'a') AND (qtp.Time_Period = 'Week') AND (qtp.Time_Period_Start = 1)
                      
 
 --********************************************** Weekly Rate******************************************
 	
-- New Logic
-- DBI
--1. LOR <=7 Days  Apply to all Weekly Rates	 

-- Week 1 - 1			
Update Quoted_Time_Period_Rate Set Time_Period_End=1

--SELECT res.foreign_confirm_number,qvr.Rate_Name, qtp.Quoted_Rate_ID,qtp.Rate_Type, qtp.Time_Period,qtp.Time_Period_Start,qtp.Time_Period_End, qtp.Amount,qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day  RAD
		ON res.Vehicle_Class_Code =RAD.Vehicle_Class_Code 
		 AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
			AND res.pick_up_on>=   RAD.Valid_From and	  res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('DBI', 'CTI', 'DDI', 'DQI','CNI','DAI','CPI','DSI','COI','DTI','DLI','F3I','CMI')) AND (res.Status = 'a') AND (qtp.Time_Period = 'Week') AND (qtp.Time_Period_Start = 1) AND (qtp.Time_Period_End <> 1)
 and CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)<=7


--- Day  8 ~ 9999  Amount=	Amount +RAD.Amount_Adjusted
--- Have to break into 8 ~ 8 and 9 ~9 to differentiate from the old record when update

--9 ~99999
Insert Into Quoted_Time_Period_Rate
SELECT --distinct 
qtp.Quoted_Rate_ID, qtp.Rate_Type, qtp.Time_Period, 9 AS Time_Period_Start, 9999 AS Time_Period_End, 
               qtp.Amount +RAD.Amount_Adjusted AdditionalDateRate, qtp.Km_Cap 
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day RAD 
		ON qvr.Rate_Name =RAD.Rate_Name 
		 AND res.Pick_Up_Location_ID = RAD.Location_ID
           AND res.Vehicle_Class_Code = RAD.Vehicle_Class_Code
           AND res.pick_up_on>=   RAD.Valid_From and res.pick_up_on<	RAD.Valid_To+1
WHERE  
(qvr.Rate_Name IN ('DBI','CTI','DDI','DQI','CNI','DAI','CPI','DSI','COI','DTI','DLI','F3I','CMI')) 
AND (res.Status = 'a') 
AND (qtp.Time_Period = 'Day') 
AND (qtp.Time_Period_Start = 8) 
And	  qtp.Time_Period_End  =9999
and CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)<=7

-- 8 ~ 8
Update  Quoted_Time_Period_Rate 
Set Amount = qtp.Amount +RAD.Amount_Adjusted, Time_Period_End=8
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day RAD 
		ON qvr.Rate_Name =RAD.Rate_Name 
		 AND res.Pick_Up_Location_ID = RAD.Location_ID
           AND res.Vehicle_Class_Code = RAD.Vehicle_Class_Code
           AND res.pick_up_on>=   RAD.Valid_From and res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('DBI','CTI','DDI','DQI','CNI','DAI','CPI','DSI','COI','DTI','DLI','F3I','CMI')) 
AND (res.Status = 'a') 
AND (qtp.Time_Period = 'Day') 
AND (qtp.Time_Period_Start = 8) 
And	  Time_Period_End  = 9999
and CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)<=7



--2. LOR > 8 days  

--------------2A for the following rates-----------------------------------
--DBI Weekly/6
--DAI Weekly/6
--CPI Weekly/5
--CNI Weekly/5

--a. LOR 8 ~ 12 Days
-- Update Weekly Rate End Period
-- Week 1 - 1			
Update Quoted_Time_Period_Rate Set Time_Period_End=1
--SELECT res.foreign_confirm_number,qvr.Rate_Name, datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00, qtp.Quoted_Rate_ID,qtp.Rate_Type, qtp.Time_Period,qtp.Time_Period_Start,qtp.Time_Period_End, qtp.Amount,qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day  RAD
		ON res.Vehicle_Class_Code =RAD.Vehicle_Class_Code 
		 AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
			AND res.pick_up_on>=   RAD.Valid_From and	  res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('DBI', 'DAI', 'CPI', 'CNI')) 
	AND (res.Status = 'a') 
	AND (qtp.Time_Period = 'Week') 
	AND (qtp.Time_Period_Start = 1) 
	AND (qtp.Time_Period_End <> 1)
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)>=8 
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)<=12



 
-- b 13 ~ 19


-- Week 1 - 2			
Update Quoted_Time_Period_Rate Set Time_Period_End=2
--SELECT res.foreign_confirm_number,qvr.Rate_Name, datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00, qtp.Quoted_Rate_ID,qtp.Rate_Type, qtp.Time_Period,qtp.Time_Period_Start,qtp.Time_Period_End, qtp.Amount,qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day  RAD
		ON res.Vehicle_Class_Code =RAD.Vehicle_Class_Code 
		 AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
			AND res.pick_up_on>=   RAD.Valid_From and	  res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('DBI', 'DAI', 'CPI', 'CNI')) 
	AND (res.Status = 'a') 
	AND (qtp.Time_Period = 'Week') 
	AND (qtp.Time_Period_Start = 1) 
	 AND (qtp.Time_Period_End <> 2)
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)>=13 
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)<=19


-- c 20 ~ 26
-- Week 1 - 3			
Update Quoted_Time_Period_Rate Set Time_Period_End=3
--SELECT res.foreign_confirm_number,qvr.Rate_Name, datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00, qtp.Quoted_Rate_ID,qtp.Rate_Type, qtp.Time_Period,qtp.Time_Period_Start,qtp.Time_Period_End, qtp.Amount,qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day  RAD
		ON res.Vehicle_Class_Code =RAD.Vehicle_Class_Code 
		 AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
			AND res.pick_up_on>=   RAD.Valid_From and	  res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('DBI', 'DAI', 'CPI', 'CNI')) 
	AND (res.Status = 'a') 
	AND (qtp.Time_Period = 'Week') 
	AND (qtp.Time_Period_Start = 1) 
	AND (qtp.Time_Period_End <> 3)
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)>=20 
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)<=26
	
	
	
-- d 27 ~ 33
-- Week 1 - 4			
Update Quoted_Time_Period_Rate Set Time_Period_End=4
--SELECT res.foreign_confirm_number,qvr.Rate_Name, datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00, qtp.Quoted_Rate_ID,qtp.Rate_Type, qtp.Time_Period,qtp.Time_Period_Start,qtp.Time_Period_End, qtp.Amount,qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day  RAD
		ON res.Vehicle_Class_Code =RAD.Vehicle_Class_Code 
		 AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
			AND res.pick_up_on>=   RAD.Valid_From and	  res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('DBI', 'DAI', 'CPI', 'CNI')) 
	AND (res.Status = 'a') 
	AND (qtp.Time_Period = 'Week') 
	AND (qtp.Time_Period_Start = 1) 
	AND (qtp.Time_Period_End <> 3)
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)>=27
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)<=33




--------------2B for the following rates-----------------------------------

--DSI Weekly/4
--COI Weekly/4
--DTI Weekly/4
--DLI Weekly/4
--DQI Weekly/4
--L5  Weekly/4
 



--a. LOR 8 ~ 11 Days
-- Update Weekly Rate End Period
-- Week 1 - 1			
Update Quoted_Time_Period_Rate Set Time_Period_End=1
--SELECT res.foreign_confirm_number,qvr.Rate_Name, datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00, qtp.Quoted_Rate_ID,qtp.Rate_Type, qtp.Time_Period,qtp.Time_Period_Start,qtp.Time_Period_End, qtp.Amount,qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day  RAD
		ON res.Vehicle_Class_Code =RAD.Vehicle_Class_Code 
		 AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
			AND res.pick_up_on>=   RAD.Valid_From and	  res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('DSI', 'COI', 'DTI', 'DLI', 'L5', 'DDI','DQI')) 
	AND (res.Status = 'a') 
	AND (qtp.Time_Period = 'Week') 
	AND (qtp.Time_Period_Start = 1) 
	AND (qtp.Time_Period_End <> 1)
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)>=8 
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)<=11



 
-- b 12 ~ 18


-- Week 1 - 2			
Update Quoted_Time_Period_Rate Set Time_Period_End=2
--SELECT res.foreign_confirm_number,qvr.Rate_Name, datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00, qtp.Quoted_Rate_ID,qtp.Rate_Type, qtp.Time_Period,qtp.Time_Period_Start,qtp.Time_Period_End, qtp.Amount,qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day  RAD
		ON res.Vehicle_Class_Code =RAD.Vehicle_Class_Code 
		 AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
			AND res.pick_up_on>=   RAD.Valid_From and	  res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('DSI', 'COI', 'DTI', 'DLI', 'L5', 'DDI','DQI')) 
	AND (res.Status = 'a') 
	AND (qtp.Time_Period = 'Week') 
	AND (qtp.Time_Period_Start = 1) 
	 AND (qtp.Time_Period_End <> 2)
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)>=12 
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)<=18


-- c 19 ~ 25
-- Week 1 - 3			
Update Quoted_Time_Period_Rate Set Time_Period_End=3
--SELECT res.foreign_confirm_number,qvr.Rate_Name, datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00, qtp.Quoted_Rate_ID,qtp.Rate_Type, qtp.Time_Period,qtp.Time_Period_Start,qtp.Time_Period_End, qtp.Amount,qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day  RAD
		ON res.Vehicle_Class_Code =RAD.Vehicle_Class_Code 
		 AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
			AND res.pick_up_on>=   RAD.Valid_From and	  res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('DSI', 'COI', 'DTI', 'DLI', 'L5', 'DDI','DQI')) 
	AND (res.Status = 'a') 
	AND (qtp.Time_Period = 'Week') 
	AND (qtp.Time_Period_Start = 1) 
	AND (qtp.Time_Period_End <> 3)
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)>=19 
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)<=25
	
	
	
-- d 26 ~ 32
-- Week 1 - 4			
Update Quoted_Time_Period_Rate Set Time_Period_End=4
--SELECT res.foreign_confirm_number,qvr.Rate_Name, datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00, qtp.Quoted_Rate_ID,qtp.Rate_Type, qtp.Time_Period,qtp.Time_Period_Start,qtp.Time_Period_End, qtp.Amount,qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day  RAD
		ON res.Vehicle_Class_Code =RAD.Vehicle_Class_Code 
		 AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
			AND res.pick_up_on>=   RAD.Valid_From and	  res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('DSI', 'COI', 'DTI', 'DLI', 'L5','DDI', 'DQI')) 
	AND (res.Status = 'a') 
	AND (qtp.Time_Period = 'Week') 
	AND (qtp.Time_Period_Start = 1) 
	AND (qtp.Time_Period_End <> 3)
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)>=26
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)<=32


--------------2C for the following rates-----------------------------------

--F3I Weekly/3

--a. LOR 8 ~ 10 Days
-- Update Weekly Rate End Period
-- Week 1 - 1			
Update Quoted_Time_Period_Rate Set Time_Period_End=1
--SELECT res.foreign_confirm_number,qvr.Rate_Name, datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00, qtp.Quoted_Rate_ID,qtp.Rate_Type, qtp.Time_Period,qtp.Time_Period_Start,qtp.Time_Period_End, qtp.Amount,qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day  RAD
		ON res.Vehicle_Class_Code =RAD.Vehicle_Class_Code 
		 AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
			AND res.pick_up_on>=   RAD.Valid_From and	  res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('F3I')) 
	AND (res.Status = 'a') 
	AND (qtp.Time_Period = 'Week') 
	AND (qtp.Time_Period_Start = 1) 
	AND (qtp.Time_Period_End <> 1)
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)>=8 
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)<=10



 
-- b 11 ~ 17


-- Week 1 - 2			
Update Quoted_Time_Period_Rate Set Time_Period_End=2
--SELECT res.foreign_confirm_number,qvr.Rate_Name, datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00, qtp.Quoted_Rate_ID,qtp.Rate_Type, qtp.Time_Period,qtp.Time_Period_Start,qtp.Time_Period_End, qtp.Amount,qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day  RAD
		ON res.Vehicle_Class_Code =RAD.Vehicle_Class_Code 
		 AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
			AND res.pick_up_on>=   RAD.Valid_From and	  res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('F3I')) 
	AND (res.Status = 'a') 
	AND (qtp.Time_Period = 'Week') 
	AND (qtp.Time_Period_Start = 1) 
	 AND (qtp.Time_Period_End <> 2)
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)>=11 
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)<=17


-- c 18 ~ 24
-- Week 1 - 3			
Update Quoted_Time_Period_Rate Set Time_Period_End=3
--SELECT res.foreign_confirm_number,qvr.Rate_Name, datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00, qtp.Quoted_Rate_ID,qtp.Rate_Type, qtp.Time_Period,qtp.Time_Period_Start,qtp.Time_Period_End, qtp.Amount,qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day  RAD
		ON res.Vehicle_Class_Code =RAD.Vehicle_Class_Code 
		 AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
			AND res.pick_up_on>=   RAD.Valid_From and	  res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('F3I')) 
	AND (res.Status = 'a') 
	AND (qtp.Time_Period = 'Week') 
	AND (qtp.Time_Period_Start = 1) 
	AND (qtp.Time_Period_End <> 3)
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)>=18 
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)<=24
	
	
	
-- d 25 ~ 31
-- Week 1 - 4			
Update Quoted_Time_Period_Rate Set Time_Period_End=4
--SELECT res.foreign_confirm_number,qvr.Rate_Name, datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00, qtp.Quoted_Rate_ID,qtp.Rate_Type, qtp.Time_Period,qtp.Time_Period_Start,qtp.Time_Period_End, qtp.Amount,qtp.Km_Cap
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day  RAD
		ON res.Vehicle_Class_Code =RAD.Vehicle_Class_Code 
		 AND res.Pick_Up_Location_ID = RAD.Location_ID
			AND qvr.Rate_Name = RAD.Rate_Name
			AND res.pick_up_on>=   RAD.Valid_From and	  res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('F3I')) 
	AND (res.Status = 'a') 
	AND (qtp.Time_Period = 'Week') 
	AND (qtp.Time_Period_Start = 1) 
	AND (qtp.Time_Period_End <> 3)
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)>=25
	AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)<=31


---*************************************************************-

 -- Extension Rate Apply to all weekly rates
 -- X +1 ~ 9999
 
 --select CEILING(datediff(mi, '2013-12-13 13:00', '2013-12-13 14:00')/1440.00),
Insert Into Quoted_Time_Period_Rate
SELECT --distinct 
qtp.Quoted_Rate_ID, qtp.Rate_Type, qtp.Time_Period, CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)+1 AS Time_Period_Start, 9999 AS Time_Period_End, 
               qtp.Amount +RAD.Amount_Adjusted AdditionalDateRate, qtp.Km_Cap 
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day RAD 
		ON qvr.Rate_Name =RAD.Rate_Name 
		 AND res.Pick_Up_Location_ID = RAD.Location_ID
           AND res.Vehicle_Class_Code = RAD.Vehicle_Class_Code
           AND res.pick_up_on>=   RAD.Valid_From and res.pick_up_on<	RAD.Valid_To+1
WHERE  
(qvr.Rate_Name IN ('DBI','CTI','DDI','DQI','CNI','DAI','CPI','DSI','COI','DTI','DLI','F3I','CMI')) 
AND (res.Status = 'a') 
AND (qtp.Time_Period = 'Day') 
AND (qtp.Time_Period_Start = 8) 
And	  qtp.Time_Period_End  =9999
AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)>7 
--AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)<=12


---*************************************************************-
-- for the duration of LOR start 8  to LOR  Apply to all weekly rates
Update  Quoted_Time_Period_Rate 
Set  Time_Period_End=CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)
FROM  dbo.Quoted_Vehicle_Rate AS qvr 
	INNER JOIN dbo.Quoted_Time_Period_Rate AS qtp 
		ON qvr.Quoted_Rate_ID = qtp.Quoted_Rate_ID 
	INNER JOIN dbo.Reservation AS res 
		ON qvr.Quoted_Rate_ID = res.Quoted_Rate_ID 
	INNER JOIN dbo.Rate_Additional_Day RAD 
		ON qvr.Rate_Name =RAD.Rate_Name 
		 AND res.Pick_Up_Location_ID = RAD.Location_ID
           AND res.Vehicle_Class_Code = RAD.Vehicle_Class_Code
           AND res.pick_up_on>=   RAD.Valid_From and res.pick_up_on<	RAD.Valid_To+1
WHERE  (qvr.Rate_Name IN ('DBI','CTI','DDI','DQI','CNI','DAI','CPI','DSI','COI','DTI','DLI','F3I','CMI')) 
AND (res.Status = 'a') 
AND (qtp.Time_Period = 'Day') 
AND (qtp.Time_Period_Start = 8) 
And	 Time_Period_End  = 9999
AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)>7 
--AND CEILING(datediff(mi, res.Pick_Up_On, res.Drop_Off_On)/1440.00)<=12

                  
 
 
 
 ---********************************** End of New Logic ******************************************************
 


GO
