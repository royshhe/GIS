USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Vehicle_Quoted_Rate_Detail_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create View [dbo].[Contract_Vehicle_Quoted_Rate_Detail_vw]
as
SELECT 
		dbo.Contract.Contract_Number,
		dbo.Quoted_Vehicle_Rate.Rate_Name, --20
		'' Rate_Level,  --21	
		sum(case when dbo.Quoted_Time_Period_Rate.Time_Period='Day' and dbo.Quoted_Time_Period_Rate.Time_Period_Start=1  
			then dbo.Quoted_Time_Period_Rate.Amount
			else	0
		end) as Daily_Rate,

		max(case when (dbo.Quoted_Time_Period_Rate.Time_Period = 'Day' and dbo.Quoted_Time_Period_Rate.Time_Period_Start != 1) 
			then dbo.Quoted_Time_Period_Rate.Amount  
			else 0.0
		end) as Addnl_Daily_rate,

		sum(case when dbo.Quoted_Time_Period_Rate.Time_Period='Week' then
			dbo.Quoted_Time_Period_Rate.Amount
			else
			0
		end) as Weekly_Rate,

		sum(case when dbo.Quoted_Time_Period_Rate.Time_Period='Hour' then
			dbo.Quoted_Time_Period_Rate.Amount
		else
			0
		end) as Hourly_Rate,		    
		sum(case when dbo.Quoted_Time_Period_Rate.Time_Period='Month' then
			dbo.Quoted_Time_Period_Rate.Amount
		else
			0
		end) as Monthly_Rate,
		'Quoted' As Rate_Type

FROM         
      dbo.Contract 
      INNER JOIN
      dbo.Quoted_Vehicle_Rate 
      INNER JOIN
      dbo.Quoted_Time_Period_Rate ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Quoted_Time_Period_Rate.Quoted_Rate_ID ON 
      dbo.Contract.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID
Where dbo.Contract.Rate_ID is null and dbo.Contract.Quoted_Rate_ID is not null
      

 
group by 
   dbo.Contract.Contract_Number,   
   dbo.Quoted_Vehicle_Rate.Rate_Name
GO
