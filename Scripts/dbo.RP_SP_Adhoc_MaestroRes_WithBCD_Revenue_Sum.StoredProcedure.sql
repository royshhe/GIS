USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Adhoc_MaestroRes_WithBCD_Revenue_Sum]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

				
--drop procedure  RP_SP_Adhoc_MaestroRes_WithBCD_Revenue_Sum
--go

Create procedure  [dbo].[RP_SP_Adhoc_MaestroRes_WithBCD_Revenue_Sum]   --'2008-01-01', '2008-06-30'
(
	
	@PUD_Start_Date varchar(10) 	= '01 JUL 2007',
	@PUD_End_Date 	varchar(10) 	= '01 JUL 2007'
)
AS


-- convert strings to datetime
DECLARE @startDate datetime,
	@endDate datetime

SELECT	@startDate	= CONVERT(datetime, '00:00:00 ' + @PUD_Start_Date),
	@endDate	= CONVERT(datetime, '23:59:59 ' + @PUD_End_Date)	


SELECT     dbo.Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw.Maestro_BCD, 

				(Case when dbo.BCDs.CompanyName  is not null  Then dbo.BCDs.CompanyName 
						When dbo.Organization.Organization is not null  Then dbo.Organization.Organization 
						When  dbo.BCDBusiness.Organization is not null Then dbo.BCDBusiness.Organization
						When  dbo.BCDRevenue2008.Organization is not null Then dbo.BCDRevenue2008.Organization
						Else NULL
				End) Organization,   

				dbo.Organization.Tour_Rate_Account,
                 SUM(dbo.Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw.Contract_Rental_Days),            

				 SUM(Case when  dbo.Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw.Status='O' then 1
						 Else 0
				End) Opened,

				 SUM(Case when  dbo.Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw.Status='C' then 1
						 Else 0
				End) Canclled,


				 SUM(Case when  dbo.Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw.Status='N' then 1
						 Else 0
				End) NoShows,

				 SUM(Case when  dbo.Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw.Status='O' then 1
						 Else 0
				End) +

				 SUM(Case when  dbo.Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw.Status='N' then 1
						 Else 0
				End) [Show+NS],
				SUM(dbo.Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw.TimeKmCharge) TnM, 
				SUM(dbo.Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw.FPO) FPO, 
				SUM(dbo.Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw.All_Level_LDW) AllLDW, 
				SUM(dbo.Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw.Driver_Under_Age) UnderAge, 
				SUM(dbo.Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw.PAI) PAI,
				SUM( dbo.Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw.PEC) PEC, 
				SUM(dbo.Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw.KmDriven) KMDriven,
				dbo.BCDBusiness.TRAC, dbo.BCDBusiness.[Old_Vol_ Comm], dbo.BCDBusiness.New_Vol_com, dbo.BCDBusiness.Type, dbo.BCDRevenue2008.Jan_07, 
				dbo.BCDRevenue2008.Feb_07, dbo.BCDRevenue2008.Mar_07, dbo.BCDRevenue2008.Apr_07, dbo.BCDRevenue2008.May_07, dbo.BCDRevenue2008.Jun_07, 
				dbo.BCDRevenue2008.[07_Total], dbo.BCDRevenue2008.Jan_08, dbo.BCDRevenue2008.Feb_08, dbo.BCDRevenue2008.Mar_08, dbo.BCDRevenue2008.Apr_08, 
				dbo.BCDRevenue2008.May_08, dbo.BCDRevenue2008.Jun_08, dbo.BCDRevenue2008.[08_Total ], dbo.BCDRevenue2008.F18

FROM         dbo.Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw LEFT OUTER JOIN
					dbo.BCDRevenue2008 ON substring(dbo.Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw.Maestro_BCD,1,7) = substring(dbo.BCDRevenue2008.BCD_Number,1,7) LEFT OUTER JOIN
					dbo.BCDBusiness ON substring(dbo.Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw.Maestro_BCD,1,7) =  substring(dbo.BCDBusiness.BCD_Number,1,7) LEFT OUTER JOIN
					dbo.BCDs ON dbo.Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw.Maestro_BCD = dbo.BCDs.BCD# LEFT OUTER JOIN
					dbo.Organization ON substring(dbo.Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw.Maestro_BCD,1,7) = substring(dbo.Organization.BCD_Number,1,7)
				    where dbo.Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw.Pick_Up_On>=@startDate and  dbo.Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw.Pick_Up_On<=@endDate
Group by dbo.Adhoc_MaestroRes_WithBCD_Revenue_Sum_vw.Maestro_BCD, 
				dbo.BCDs.CompanyName,  dbo.BCDBusiness.Organization,	dbo.BCDRevenue2008.Organization,dbo.Organization.Organization, 
				dbo.Organization.Tour_Rate_Account,dbo.BCDBusiness.TRAC, dbo.BCDBusiness.[Old_Vol_ Comm], dbo.BCDBusiness.New_Vol_com, dbo.BCDBusiness.Type, dbo.BCDRevenue2008.Jan_07, 
				dbo.BCDRevenue2008.Feb_07, dbo.BCDRevenue2008.Mar_07, dbo.BCDRevenue2008.Apr_07, dbo.BCDRevenue2008.May_07, dbo.BCDRevenue2008.Jun_07, 
				dbo.BCDRevenue2008.[07_Total], dbo.BCDRevenue2008.Jan_08, dbo.BCDRevenue2008.Feb_08, dbo.BCDRevenue2008.Mar_08, dbo.BCDRevenue2008.Apr_08, 
				dbo.BCDRevenue2008.May_08, dbo.BCDRevenue2008.Jun_08, dbo.BCDRevenue2008.[08_Total ], dbo.BCDRevenue2008.F18

--
--
--select  count(*)  from reservation where Pick_Up_On>='2008-01-01' and Pick_Up_On<'2008-07-01' 
--and  bcd_Number is not null
-- and status in ('O', 'N')





GO
