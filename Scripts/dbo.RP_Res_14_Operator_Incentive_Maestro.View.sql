USE [GISData]
GO
/****** Object:  View [dbo].[RP_Res_14_Operator_Incentive_Maestro]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[RP_Res_14_Operator_Incentive_Maestro]
AS
SELECT    dbo.Reservation.Confirmation_Number, 
		  dbo.Reservation.Status,
		  dbo.Contract.Contract_Number,	 		 
          dbo.Reservation.Vehicle_Class_Code,
          dbo.Reservation.Pick_Up_Location_ID,          
          dbo.Reservation.Drop_Off_Location_ID, 
          dbo.Reservation.Pick_Up_On, 
          dbo.Reservation.Drop_Off_On, 
          ResChgHist.ResMadeTime AS TransTime, 
          ResCancelTime.ResCancelTime, 
          
          dbo.Contract.Status AS Contract_status, 
          datediff(mi,dbo.Reservation.Pick_Up_On,dbo.Reservation.Drop_Off_On) / 60.00 as BookedHours,          
          dbo.RT_Rate_Amount.Rate_Name, dbo.RT_Rate_Amount.Rate_Level,
		  SUM(CASE WHEN (RT_Rate_Amount.Time_Period = 'Day' AND 
							RT_Rate_Amount.Time_Period_Start = 1) 
					THEN RT_Rate_Amount.Amount ELSE 0.0 END) AS Daily_rate, 
			MAX(CASE WHEN (RT_Rate_Amount.Time_Period = 'Day' AND 
							RT_Rate_Amount.Time_Period_Start != 1) 
					THEN RT_Rate_Amount.Amount ELSE 0.0 END) AS Addnl_Daily_rate, 
          SUM(CASE RT_Rate_Amount.Time_Period WHEN 'Week' THEN RT_Rate_Amount.Amount ELSE 0.0 END) AS Weekly_rate, 
          SUM(CASE RT_Rate_Amount.Time_Period WHEN 'Hour' THEN RT_Rate_Amount.Amount ELSE 0.0 END) AS Hourly_rate, 
          SUM(CASE RT_Rate_Amount.Time_Period WHEN 'Month' THEN RT_Rate_Amount.Amount ELSE 0.0 END) AS Monthly_rate,

		 'GIS Reservation' AS Rate_Type, 
          dbo.Reservation.First_Name, dbo.Reservation.Last_Name,   
       
          dbo.Reservation.Flex_Discount,
          dbo.Reservation.Discount_ID,          
          Discount.Percentage,
          dbo.Reservation.Reservation_revenue as TimeCharge,
		foreign_confirm_number
              

FROM  dbo.Reservation 
--INNER JOIN  dbo.RT_Rate_Amount 
	Left join dbo.RT_Rate_Amount 
		ON dbo.Reservation.Rate_ID = dbo.RT_Rate_Amount.Rate_ID AND   dbo.Reservation.Vehicle_Class_Code = dbo.RT_Rate_Amount.Vehicle_Class_Code AND dbo.Reservation.Rate_Level = dbo.RT_Rate_Amount.Rate_Level 
Left Join dbo.RP__Reservation_Cancel_Time AS ResCancelTime 
		ON ResCancelTime.Confirmation_Number = dbo.Reservation.Confirmation_Number 
Left OUTER JOIN dbo.RP__Reservation_Make_Time AS ResChgHist 
        ON  ResChgHist.Confirmation_Number = dbo.Reservation.Confirmation_Number   
LEFT OUTER JOIN dbo.Contract 
          ON     dbo.Reservation.Confirmation_Number = dbo.Contract.Confirmation_Number           
Left Join Discount on dbo.Reservation.Discount_ID = Discount.Discount_ID                    
WHERE  (Reservation.Foreign_confirm_number is not null and Left(Reservation.Foreign_confirm_number,1)='I') and 
			((dbo.Reservation.Date_Rate_Assigned BETWEEN dbo.RT_Rate_Amount.VREffectiveDate AND dbo.RT_Rate_Amount.VRTerminationDate) AND 
                      (dbo.Reservation.Date_Rate_Assigned BETWEEN dbo.RT_Rate_Amount.RCAEffectiveDate AND dbo.RT_Rate_Amount.RCATerminationDate) AND 
                      (dbo.Reservation.Date_Rate_Assigned BETWEEN dbo.RT_Rate_Amount.RTPEffectiveDate AND dbo.RT_Rate_Amount.RTPTerminationDate) AND 
                      (dbo.Reservation.Date_Rate_Assigned BETWEEN dbo.RT_Rate_Amount.RVCEffectiveDate AND dbo.RT_Rate_Amount.RVCTerminationDate)-- AND 
                      --(dbo.Reservation.source_code<>'Maestro' or dbo.Reservation.Rate_id is not null)
               or BCD_Rate_Org_ID is not null)   --add BCD rate reservations by Pni 20150225
               
GROUP BY dbo.Reservation.Confirmation_Number, 		
		dbo.Contract.Contract_Number, 
		ResChgHist.ResMadeTime, 
		ResCancelTime.ResCancelTime, 
		dbo.Reservation.Status, 
		dbo.Contract.Status, 
		dbo.Reservation.Pick_Up_On, 
		dbo.Reservation.Drop_Off_On, 
		dbo.Reservation.Pick_Up_Location_ID, 
		dbo.Reservation.Drop_Off_Location_ID, 		
		dbo.Reservation.Vehicle_Class_Code, 		
		dbo.RT_Rate_Amount.Rate_Name, 
		dbo.RT_Rate_Amount.Rate_Level,
		dbo.Reservation.First_Name, 
		dbo.Reservation.Last_Name, 
		dbo.Reservation.Flex_Discount,
		dbo.Reservation.Discount_ID,
		dbo.Reservation.Rate_ID,
		Discount.Percentage,
		dbo.Reservation.Reservation_revenue,
		foreign_confirm_number

union

SELECT    dbo.Reservation.Confirmation_Number, 
		  dbo.Reservation.Status,
		  dbo.Contract.Contract_Number,	 		 
          dbo.Reservation.Vehicle_Class_Code,
          dbo.Reservation.Pick_Up_Location_ID,          
          dbo.Reservation.Drop_Off_Location_ID, 
          dbo.Reservation.Pick_Up_On, 
          dbo.Reservation.Drop_Off_On, 
          ResChgHist.ResMadeTime AS TransTime, 
          ResCancelTime.ResCancelTime, 
          
          dbo.Contract.Status AS Contract_status, 
          datediff(mi,dbo.Reservation.Pick_Up_On,dbo.Reservation.Drop_Off_On) / 60.00 as BookedHours,          
          QVR.Rate_Name, '' as Rate_Level,
		  SUM(CASE WHEN (QTPR.Time_Period = 'Day' AND 
							QTPR.Time_Period_Start = 1) 
					THEN QTPR.Amount ELSE 0.0 END) AS Daily_rate, 
			MAX(CASE WHEN (QTPR.Time_Period = 'Day' AND 
							QTPR.Time_Period_Start != 1) 
					THEN QTPR.Amount ELSE 0.0 END) AS Addnl_Daily_rate, 
          SUM(CASE QTPR.Time_Period WHEN 'Week' THEN QTPR.Amount ELSE 0.0 END) AS Weekly_rate, 
          SUM(CASE QTPR.Time_Period WHEN 'Hour' THEN QTPR.Amount ELSE 0.0 END) AS Hourly_rate, 
          SUM(CASE QTPR.Time_Period WHEN 'Month' THEN QTPR.Amount ELSE 0.0 END) AS Monthly_rate,

		 'Maestro Reservation' AS Rate_Type, 
          dbo.Reservation.First_Name, dbo.Reservation.Last_Name,   
       
          dbo.Reservation.Flex_Discount,
          dbo.Reservation.Discount_ID,          
          Discount.Percentage,
          dbo.Reservation.Reservation_revenue as TimeCharge,
		foreign_confirm_number
              
--select *
FROM  dbo.Reservation 
--INNER JOIN  dbo.RT_Rate_Amount 
	Left join dbo.Quoted_Vehicle_Rate QVR 
		ON dbo.Reservation.Quoted_Rate_ID = QVR.Quoted_Rate_ID --AND   dbo.Reservation.Vehicle_Class_Code = QVR.Vehicle_Class_Code
		inner join dbo.Quoted_Time_Period_Rate QTPR ON QVR.Quoted_Rate_ID = QTPR.Quoted_Rate_ID
Left Join dbo.RP__Reservation_Cancel_Time AS ResCancelTime 
		ON ResCancelTime.Confirmation_Number = dbo.Reservation.Confirmation_Number 
Left OUTER JOIN dbo.RP__Reservation_Make_Time AS ResChgHist 
        ON  ResChgHist.Confirmation_Number = dbo.Reservation.Confirmation_Number   
LEFT OUTER JOIN dbo.Contract 
          ON     dbo.Reservation.Confirmation_Number = dbo.Contract.Confirmation_Number           
Left Join Discount on dbo.Reservation.Discount_ID = Discount.Discount_ID                    
WHERE  (Reservation.Foreign_confirm_number is not null and Left(Reservation.Foreign_confirm_number,1)<>'I')
-- and 
--			((dbo.Reservation.Date_Rate_Assigned BETWEEN dbo.RT_Rate_Amount.VREffectiveDate AND dbo.RT_Rate_Amount.VRTerminationDate) AND 
--                      (dbo.Reservation.Date_Rate_Assigned BETWEEN dbo.RT_Rate_Amount.RCAEffectiveDate AND dbo.RT_Rate_Amount.RCATerminationDate) AND 
--                      (dbo.Reservation.Date_Rate_Assigned BETWEEN dbo.RT_Rate_Amount.RTPEffectiveDate AND dbo.RT_Rate_Amount.RTPTerminationDate) AND 
--                      (dbo.Reservation.Date_Rate_Assigned BETWEEN dbo.RT_Rate_Amount.RVCEffectiveDate AND dbo.RT_Rate_Amount.RVCTerminationDate)-- AND 
--                      --(dbo.Reservation.source_code<>'Maestro' or dbo.Reservation.Rate_id is not null)
--               or BCD_Rate_Org_ID is not null)   --add BCD rate reservations by Pni 20150225
               
GROUP BY dbo.Reservation.Confirmation_Number, 		
		dbo.Contract.Contract_Number, 
		ResChgHist.ResMadeTime, 
		ResCancelTime.ResCancelTime, 
		dbo.Reservation.Status, 
		dbo.Contract.Status, 
		dbo.Reservation.Pick_Up_On, 
		dbo.Reservation.Drop_Off_On, 
		dbo.Reservation.Pick_Up_Location_ID, 
		dbo.Reservation.Drop_Off_Location_ID, 		
		dbo.Reservation.Vehicle_Class_Code, 		
		QVR.Rate_Name, 
		--dbo.RT_Rate_Amount.Rate_Level,
		dbo.Reservation.First_Name, 
		dbo.Reservation.Last_Name, 
		dbo.Reservation.Flex_Discount,
		dbo.Reservation.Discount_ID,
		dbo.Reservation.Rate_ID,
		Discount.Percentage,
		dbo.Reservation.Reservation_revenue,
		foreign_confirm_number
GO
