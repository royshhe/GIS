USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_MRI_4_Maestro_Sequence]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/*
PROCEDURE NAME: RP_SP_MRI_1_Reservation_Error
PURPOSE: Select all the information needed for Maestro Reservation Error Report

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Maestro Reservation Error Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	Sep 24 1999	Add more filtering to improve performance
*/
/* add Rate_Name and BCD on Feb 18, 2005 , simon gong*/

CREATE PROCEDURE [dbo].[RP_SP_MRI_4_Maestro_Sequence]
(	
	@FromDate varchar(24) = '1999/01/12 09:36',
	@ToDate varchar(24) = '1999/01/12 09:37'
)
AS

DECLARE @dFrom datetime,
	@dTo datetime

SELECT 	@dFrom = CONVERT(datetime, @FromDate)
SELECT 	@dTo = CONVERT(datetime, @ToDate)


select 
	Transaction_Date,        
	Sequence_Number ,
	Confirmation_Number, 
	Foreign_Confirm_Number,
	GIS_Process_Date,
	Update_Gis_Indicator
from maestro
where transaction_date between @dFrom and @dTo 
--and update_gis_indicator=1
order by transaction_date,sequence_number
	
	
RETURN @@ROWCOUNT
GO
