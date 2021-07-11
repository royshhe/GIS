USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_12_WalkUpRevenue]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[RP_SP_Acc_12_WalkUpRevenue]
(
	@paramStartBusDate varchar(20) = '01 Apr 2006',
	@paramEndBusDate varchar(20) = '30 Apr 2006'
)
AS
-- convert strings to datetime
DECLARE 	@startBusDate datetime,
		@endBusDate datetime

SELECT	@startBusDate	= CONVERT(datetime, '00:00:00 ' + @paramStartBusDate),
	@endBusDate	= CONVERT(datetime, '23:59:59 ' + @paramEndBusDate)	

select location.location, 
	Rev.CSR_Name, 
	Rev.Contract_Rental_Days, 
	Rev.Rental_Time_Revenue,
	Rev.Rental_KM_Revenue,
	Rev.Contract_TnKm_Revenue,
	Rev.Contract_Revenue
from RP_Acc_12_CSR_Walkup_TnK Rev
join location on location.location_Id = Rev.Pick_Up_Location_ID
where rev.RBR_Date between @startBusDate and @endBusDate

GO
