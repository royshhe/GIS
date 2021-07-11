USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Rate_Amount]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE View [dbo].[Contract_Rate_Amount]

as

SELECT     dbo.Contract.Contract_Number,  dbo.RT_Rate_Amount.Rate_Name,            
	   --dbo.RT_Rate_Amount.Time_Period
	   --dbo.RT_Rate_Amount.Amount, 	




	        Daily_rate = max(case when (dbo.RT_Rate_Amount.Time_Period = 'Day' and dbo.RT_Rate_Amount.Time_Period_Start = 1)
				then dbo.RT_Rate_Amount.Amount  
				else 0.0
		end),
		Addnl_Daily_rate = sum(case when (dbo.RT_Rate_Amount.Time_Period = 'Day' and dbo.RT_Rate_Amount.Time_Period_Start != 1) --or RTP.Time_Period = 'Day'
				then dbo.RT_Rate_Amount.Amount  
				else 0.0
		end),
		Weekly_rate = max(case dbo.RT_Rate_Amount.Time_Period
				when 'Week'
				then dbo.RT_Rate_Amount.Amount
				else 0.0
		end),
		Hourly_rate =max(case dbo.RT_Rate_Amount.Time_Period
				when 'Hour'
				then dbo.RT_Rate_Amount.Amount
				else 0.0
		end),
		Monthly_rate = max(case dbo.RT_Rate_Amount.Time_Period 
				when 'Month'
				then dbo.RT_Rate_Amount.Amount
				else 0.0
		end)
	   
FROM       dbo.Contract INNER JOIN
                      dbo.RT_Rate_Amount ON  dbo.Contract.Vehicle_Class_Code = dbo.RT_Rate_Amount.Vehicle_Class_Code AND dbo.Contract.Rate_ID = dbo.RT_Rate_Amount.Rate_ID AND dbo.Contract.Rate_Level = dbo.RT_Rate_Amount.Rate_Level

where  
   dbo.Contract.Rate_Assigned_Date between dbo.RT_Rate_Amount.VREffectiveDate and dbo.RT_Rate_Amount.VRTerminationDate and  
  dbo.Contract.Rate_Assigned_Date between  dbo.RT_Rate_Amount.RCAEffectiveDate and dbo.RT_Rate_Amount.RCATerminationDate and 
  dbo.Contract.Rate_Assigned_Date between   dbo.RT_Rate_Amount.RTPEffectiveDate and  dbo.RT_Rate_Amount.RTPTerminationDate and  
  dbo.Contract.Rate_Assigned_Date between dbo.RT_Rate_Amount.RVCEffectiveDate and dbo.RT_Rate_Amount.RVCTerminationDate  
  --and dbo.Contract.Pick_Up_On>'2007-03-01'

group by dbo.Contract.Contract_Number,dbo.RT_Rate_Amount.Rate_Name

union

SELECT     dbo.Contract.Contract_Number, dbo.Quoted_Vehicle_Rate.Rate_Name, 
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


FROM         dbo.Contract INNER JOIN
                      dbo.Quoted_Vehicle_Rate ON dbo.Contract.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID INNER JOIN
                      dbo.Quoted_Time_Period_Rate ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Quoted_Time_Period_Rate.Quoted_Rate_ID

--where dbo.Contract.Pick_Up_On>'2007-03-01'

group by dbo.Contract.Contract_Number, dbo.Quoted_Vehicle_Rate.Rate_Name












GO
