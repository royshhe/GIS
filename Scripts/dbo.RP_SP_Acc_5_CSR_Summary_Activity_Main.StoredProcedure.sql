USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_5_CSR_Summary_Activity_Main]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Acc_5_CSR_Summary_Activity_Main
PURPOSE: Select all the information needed for CSR Summary Activity Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/15
USED BY: CSR Summary Activity Report
MOD HISTORY:
Name 		Date		Comments

*/
CREATE PROCEDURE [dbo].[RP_SP_Acc_5_CSR_Summary_Activity_Main]
(
	@paramStartBusDate varchar(20) = '22 Apr 1999',
	@paramEndBusDate varchar(20) = '23 Apr 1999',
	@paramVehicleTypeID varchar(18) = 'Car',
	@paramLocationID varchar(20) = '259'
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

FROM 	RP_Acc_5_CSR_Summary_Activity_Main_L1 with(nolock)

WHERE
	(@paramVehicleTypeID = "*" OR Vehicle_Type_ID = @paramVehicleTypeID)
	AND
	(@paramLocationID = "*" or CONVERT(INT, @tmpLocID) = Location_ID)
	AND
	RBR_Date BETWEEN @startBusDate AND @endBusDate

GO
