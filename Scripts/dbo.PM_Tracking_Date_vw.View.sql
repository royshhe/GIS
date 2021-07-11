USE [GISData]
GO
/****** Object:  View [dbo].[PM_Tracking_Date_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[PM_Tracking_Date_vw]
AS
--Select Convert(datetime, CONVERT(VarChar, getdate(), 111)) -Day(getdate())+1
               
SELECT PMS.Unit_Number, 
		PMS.Service_Code, 
		PMS.Type, 
		PLS.Service_Date AS Last_Service_Date, 
		PLS.KM_Reading, 
		PMS.Current_Km, 
		(Case 
			When PMS.Tracking_Time_Unit='m' 
			Then
				Dateadd(m,
						PMS.Recurring_Time+1,
						Convert(datetime, CONVERT(VarChar,PLS.Service_Date, 111)) -- get rid of time 
						-Day(PLS.Service_Date)+1  -- Convert to Month Beginning			
				)-1
			When PMS.Tracking_Time_Unit='d' 
			Then
			Dateadd(d, PMS.Recurring_Time,PLS.Service_Date) 
			When PMS.Tracking_Time_Unit='h' 
			Then
			Dateadd(hh, PMS.Recurring_Time,PLS.Service_Date) 
			When PMS.Tracking_Time_Unit='w' 
			Then Dateadd(w, PMS.Recurring_Time,PLS.Service_Date)  
		End)   	as NextServiceDate,
		--Dateadd(m, PMS.Recurring_Time,PLS.Service_Date) as NextServiceDate,
        --PMS.Date_Tracking, 
        NULL as NetServiceKM,
        PMS.Recurring_Time, 
        PMS.Tracking_Time_Unit, 
        PMS.Advance_Notification_Days, 
        (
        Case 
			When PMS.Tracking_Time_Unit='m' 
			Then
			     
			    (Case 
					When DateDiff(d,getdate(), 
							--Dateadd(m, PMS.Recurring_Time,PLS.Service_Date)
							
							Dateadd(m,
									PMS.Recurring_Time+1,
									Convert(datetime, CONVERT(VarChar,PLS.Service_Date, 111)) -- get rid of time 
									-Day(PLS.Service_Date)+1  -- Convert to Month Beginning			
							)-1
							
							
							)<=PMS.Advance_Notification_Days
							AND 
							
							DateDiff(d,getdate(), 
									--Dateadd(m, PMS.Recurring_Time,PLS.Service_Date)
									Dateadd(m,
											PMS.Recurring_Time+1,
											Convert(datetime, CONVERT(VarChar,PLS.Service_Date, 111)) -- get rid of time 
											-Day(PLS.Service_Date)+1  -- Convert to Month Beginning			
									)-1
							
							) >= 0
						Then 0
					WHEN (DateDiff(d,getdate(), 
							--Dateadd(m, PMS.Recurring_Time,PLS.Service_Date)
							
							
							
							Dateadd(m,
										PMS.Recurring_Time+1,
										Convert(datetime, CONVERT(VarChar,PLS.Service_Date, 111)) -- get rid of time 
										-Day(PLS.Service_Date)+1  -- Convert to Month Beginning			
							)-1
						  ) < 0 )
						THEN - 1 
					WHEN  (DateDiff(d,getdate(), 
								--Dateadd(m, PMS.Recurring_Time,PLS.Service_Date)
								Dateadd(m,
										PMS.Recurring_Time+1,
										Convert(datetime, CONVERT(VarChar,PLS.Service_Date, 111)) -- get rid of time 
										-Day(PLS.Service_Date)+1  -- Convert to Month Beginning			
							)-1
								
						) > PMS.Advance_Notification_Days )
						THEN 1 
				 End)
				 	
		    When PMS.Tracking_Time_Unit='d' 
			Then
			     
			    (Case 
					When DateDiff(d,getdate(), Dateadd(d, PMS.Recurring_Time,PLS.Service_Date))<=PMS.Advance_Notification_Days
							AND DateDiff(d,getdate(), Dateadd(m, PMS.Recurring_Time,PLS.Service_Date)) >= 0
						Then 0
					WHEN (DateDiff(d,getdate(), Dateadd(d, PMS.Recurring_Time,PLS.Service_Date)) < 0 )
						THEN - 1 
					WHEN  (DateDiff(d,getdate(), Dateadd(d, PMS.Recurring_Time,PLS.Service_Date)) > PMS.Advance_Notification_Days )
						THEN 1 
				 End)
			When PMS.Tracking_Time_Unit='h' 
			Then
			     
			    (Case 
					When DateDiff(d,getdate(), Dateadd(hh, PMS.Recurring_Time,PLS.Service_Date))<=PMS.Advance_Notification_Days
							AND DateDiff(d,getdate(), Dateadd(m, PMS.Recurring_Time,PLS.Service_Date)) >= 0
						Then 0
					WHEN (DateDiff(d,getdate(), Dateadd(hh, PMS.Recurring_Time,PLS.Service_Date)) < 0 )
						THEN - 1 
					WHEN  (DateDiff(d,getdate(), Dateadd(hh, PMS.Recurring_Time,PLS.Service_Date)) > PMS.Advance_Notification_Days )
						THEN 1 
				 End)
				 		
			When PMS.Tracking_Time_Unit='w' 
			Then
			     
			    (Case 
					When DateDiff(d,getdate(), Dateadd(w, PMS.Recurring_Time,PLS.Service_Date))<=PMS.Advance_Notification_Days
							AND DateDiff(d,getdate(), Dateadd(m, PMS.Recurring_Time,PLS.Service_Date)) >= 0
						Then 0
					WHEN (DateDiff(d,getdate(), Dateadd(w, PMS.Recurring_Time,PLS.Service_Date)) < 0 )
						THEN - 1 
					WHEN  (DateDiff(d,getdate(), Dateadd(w, PMS.Recurring_Time,PLS.Service_Date)) > PMS.Advance_Notification_Days )
						THEN 1 
				 End)
				 		 	 		 	
		End) Status,
        PMS.Date_Overdue_Restrict
FROM  dbo.PM_Service_Schedule_vw AS PMS INNER JOIN
               dbo.PM_Last_Service_vw AS PLS ON PMS.Unit_Number = PLS.Unit_Number AND PMS.Service_Code = PLS.Service_Code
WHERE (PMS.Date_Tracking = 1)

union
Select 
 PMS.Unit_Number, 
		PMS.Service_Code, 
		PMS.Type, 
		NULL AS Last_Service_Date, 
		NULL KM_Reading, 
		PMS.Current_Km, 
		Dateadd(m,
						1,
						Convert(datetime, CONVERT(VarChar,VEH.Ownership_Date, 111)) -- get rid of time 
						-Day(VEH.Ownership_Date)+1  -- Convert to Month Beginning			
				)-1 NextServiceDate,
		--Convert(datetime, CONVERT(VarChar,Getdate(), 111)) 	as NextServiceDate,
		--Dateadd(m, PMS.Recurring_Time,PLS.Service_Date) as NextServiceDate,
        --PMS.Date_Tracking, 
        NULL as NetServiceKM,
        PMS.Recurring_Time, 
        PMS.Tracking_Time_Unit, 
        PMS.Advance_Notification_Days, 
        0 Status,
        PMS.Date_Overdue_Restrict
FROM  dbo.PM_Service_Schedule_vw AS PMS 
Inner Join Vehicle VEH 
		on PMS.Unit_Number=VEH.Unit_Number
Left  JOIN dbo.PM_Last_Service_vw AS PLS 
		ON PMS.Unit_Number = PLS.Unit_Number AND PMS.Service_Code = PLS.Service_Code
WHERE (PMS.Date_Tracking = 1)  and  PLS.Unit_Number is null
 
  
--Select 
-- PMS.Unit_Number, 
--		PMS.Service_Code, 
--		PMS.Type, 
--		NULL AS Last_Service_Date, 
--		NULL KM_Reading, 
--		PMS.Current_Km, 
		
--		Convert(datetime, CONVERT(VarChar,Getdate(), 111)) 	as NextServiceDate,
--		--Dateadd(m, PMS.Recurring_Time,PLS.Service_Date) as NextServiceDate,
--        --PMS.Date_Tracking, 
--        NULL as NetServiceKM,
--        PMS.Recurring_Time, 
--        PMS.Tracking_Time_Unit, 
--        PMS.Advance_Notification_Days, 
--        0 Status,
--        PMS.Date_Overdue_Restrict
--FROM  dbo.PM_Service_Schedule_vw AS PMS 
----INNER JOIN
----               dbo.PM_Last_Service_vw AS PLS ON PMS.Unit_Number = PLS.Unit_Number AND PMS.Service_Code = PLS.Service_Code
--WHERE (PMS.Date_Tracking = 1) and PMS.Unit_Number not in (Select Unit_Number
--from PM_Service_History PSH )


GO
