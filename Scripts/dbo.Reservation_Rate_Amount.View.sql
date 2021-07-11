USE [GISData]
GO
/****** Object:  View [dbo].[Reservation_Rate_Amount]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[Reservation_Rate_Amount]

as

SELECT     dbo.Reservation.Confirmation_Number,  dbo.RT_Rate_Amount.Rate_Name,            
	   --dbo.RT_Rate_Amount.Time_Period
	   --dbo.RT_Rate_Amount.Amount, 	




	        Daily_rate = sum(case when (dbo.RT_Rate_Amount.Time_Period = 'Day' and dbo.RT_Rate_Amount.Time_Period_Start = 1)
				then dbo.RT_Rate_Amount.Amount  
				else 0.0
		end),
		Addnl_Daily_rate = sum(case when (dbo.RT_Rate_Amount.Time_Period = 'Day' and dbo.RT_Rate_Amount.Time_Period_Start != 1) --or RTP.Time_Period = 'Day'
				then dbo.RT_Rate_Amount.Amount  
				else 0.0
		end),
		Weekly_rate = sum(case dbo.RT_Rate_Amount.Time_Period
				when 'Week'
				then dbo.RT_Rate_Amount.Amount
				else 0.0
		end),
		Hourly_rate = sum(case dbo.RT_Rate_Amount.Time_Period
				when 'Hour'
				then dbo.RT_Rate_Amount.Amount
				else 0.0
		end),
		Monthly_rate = sum(case dbo.RT_Rate_Amount.Time_Period 
				when 'Month'
				then dbo.RT_Rate_Amount.Amount
				else 0.0
		end)
	   
FROM       dbo.Reservation INNER JOIN
                      dbo.RT_Rate_Amount ON dbo.Reservation.Rate_ID = dbo.RT_Rate_Amount.Rate_ID AND dbo.Reservation.Rate_Level = dbo.RT_Rate_Amount.Rate_Level
where  
   dbo.Reservation.Date_Rate_Assigned between dbo.RT_Rate_Amount.VREffectiveDate and dbo.RT_Rate_Amount.VRTerminationDate and  
  dbo.Reservation.Date_Rate_Assigned between  dbo.RT_Rate_Amount.RCAEffectiveDate and dbo.RT_Rate_Amount.RCATerminationDate and 
  dbo.Reservation.Date_Rate_Assigned between   dbo.RT_Rate_Amount.RTPEffectiveDate and  dbo.RT_Rate_Amount.RTPTerminationDate and  
  dbo.Reservation.Date_Rate_Assigned between dbo.RT_Rate_Amount.RVCEffectiveDate and dbo.RT_Rate_Amount.RVCTerminationDate  
  and dbo.Reservation.Pick_Up_On>'2007-03-01'

group by dbo.Reservation.Confirmation_Number,dbo.RT_Rate_Amount.Rate_Name


union

SELECT     dbo.Reservation.Confirmation_Number, dbo.Quoted_Vehicle_Rate.Rate_Name, 
	        Daily_rate = sum(case when (dbo.Quoted_Time_Period_Rate.Time_Period = 'Day' and dbo.Quoted_Time_Period_Rate.Time_Period_Start = 1)
				then dbo.Quoted_Time_Period_Rate.Amount  
				else 0.0
		end),
		Addnl_Daily_rate = sum(case when (dbo.Quoted_Time_Period_Rate.Time_Period = 'Day' and dbo.Quoted_Time_Period_Rate.Time_Period_Start != 1) --or RTP.Time_Period = 'Day'
				then dbo.Quoted_Time_Period_Rate.Amount  
				else 0.0
		end),
		Weekly_rate = sum(case dbo.Quoted_Time_Period_Rate.Time_Period
				when 'Week'
				then dbo.Quoted_Time_Period_Rate.Amount
				else 0.0
		end),
		Hourly_rate = sum(case dbo.Quoted_Time_Period_Rate.Time_Period
				when 'Hour'
				then dbo.Quoted_Time_Period_Rate.Amount
				else 0.0
		end),
		Monthly_rate = sum(case dbo.Quoted_Time_Period_Rate.Time_Period 
				when 'Month'
				then dbo.Quoted_Time_Period_Rate.Amount
				else 0.0
		end)


FROM         dbo.Reservation INNER JOIN
                      dbo.Quoted_Vehicle_Rate ON dbo.Reservation.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID INNER JOIN
                      dbo.Quoted_Time_Period_Rate ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Quoted_Time_Period_Rate.Quoted_Rate_ID
where dbo.Reservation.Pick_Up_On>'2007-03-01'

group by  dbo.Reservation.Confirmation_Number, dbo.Quoted_Vehicle_Rate.Rate_Name


GO
