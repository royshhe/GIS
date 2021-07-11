USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_4_CSR_Detail_Activity_Main]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Acc_4_CSR_Detail_Activity_Main
PURPOSE: Select all the information needed for CSR Detail Activity Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/15
USED BY: CSR Detail Activity Report
MOD HISTORY:
Name 		Date		Comments

*/
CREATE PROCEDURE [dbo].[RP_SP_Acc_4_CSR_Detail_Activity_Main]
(
	@paramStartBusDate varchar(20) = '22 Apr 1999',
	@paramEndBusDate varchar(20) = '24 Apr 1999',
	@paramVehicleTypeID varchar(18) = '*',
	@paramLocationID varchar(20) = '259',
	@paramCSRName varchar(50) = 'Cindy Yee'
)
AS
-- convert strings to datetime
DECLARE 	@startBusDate datetime,
		@endBusDate datetime

SELECT	@startBusDate	= CONVERT(datetime, '00:00:00 ' + @paramStartBusDate),
		@endBusDate	= CONVERT(datetime, '23:59:59 ' + @paramEndBusDate)	

-- fix upgrading problem (SQL7->SQL2000)

DECLARE  @tmpLocID varchar(20)

if @paramLocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramLocationID
	END 

-- end of fixing the problem

SELECT 	
	RBR_Date,
	Location_ID,
   	Location_Name,
   	CSR_Name,
   	Vehicle_Type_ID

FROM   RP_Acc_4_CSR_Detail_Activity_L1_Main with(nolock)

WHERE
	CSR_Name = @paramCSRName
	AND
	(@paramVehicleTypeID = "*" OR Vehicle_Type_ID = @paramVehicleTypeID)
	AND
	(@paramLocationID = "*" OR CONVERT(INT, @tmpLocID) = Location_ID)
	AND
	RBR_Date BETWEEN @startBusDate AND @endBusDate

GO
