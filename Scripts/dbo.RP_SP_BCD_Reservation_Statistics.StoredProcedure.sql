USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_BCD_Reservation_Statistics]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

				
--drop procedure  RP_SP_Adhoc_MaestroRes_WithBCD_Revenue_Sum
--go

CREATE procedure  [dbo].[RP_SP_BCD_Reservation_Statistics]  -- '2009-01-01', '2009-06-30'
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


SELECT   dbo.BCD_Reservation_Statistics_vw.BCD_Number, 
				dbo.Organization.Organization,
				dbo.Organization.Tour_Rate_Account,
                 SUM(dbo.BCD_Reservation_Statistics_vw.Rental_Day),            

				 SUM(Case when  dbo.BCD_Reservation_Statistics_vw.Status='O' then 1
						 Else 0
				End) Opened,

				 SUM(Case when  dbo.BCD_Reservation_Statistics_vw.Status='C' then 1
						 Else 0
				End) Canclled,


				 SUM(Case when  dbo.BCD_Reservation_Statistics_vw.Status='N' then 1
						 Else 0
				End) NoShows,

				 SUM(Case when  dbo.BCD_Reservation_Statistics_vw.Status='O' then 1
						 Else 0
				End) +

				 SUM(Case when  dbo.BCD_Reservation_Statistics_vw.Status='N' then 1
						 Else 0
				End) [Show+NS],
				SUM(dbo.BCD_Reservation_Statistics_vw.TnK) TnM, 	
				SUM(dbo.BCD_Reservation_Statistics_vw.Upgrade) as Upgrade,
               Count(*) TotalCount
				
FROM         dbo.BCD_Reservation_Statistics_vw LEFT OUTER JOIN
					dbo.Organization ON dbo.BCD_Reservation_Statistics_vw.BCD_Number=dbo.Organization.BCD_Number
				    where dbo.BCD_Reservation_Statistics_vw.Pick_Up_On>=@startDate and  dbo.BCD_Reservation_Statistics_vw.Pick_Up_On<=@endDate
Group by dbo.BCD_Reservation_Statistics_vw.BCD_Number, 
			  dbo.Organization.Organization, 
			  dbo.Organization.Tour_Rate_Account

GO
