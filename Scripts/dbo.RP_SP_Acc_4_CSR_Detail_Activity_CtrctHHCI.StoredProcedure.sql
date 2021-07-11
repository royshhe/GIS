USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_4_CSR_Detail_Activity_CtrctHHCI]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
PURPOSE: Retrieve the contracts for a CSR on a business day that were 
	checked in by hand held.
MOD HISTORY:
Name	Date		Comments
Don K	Feb 7 2000	Created
*/
CREATE PROCEDURE [dbo].[RP_SP_Acc_4_CSR_Detail_Activity_CtrctHHCI]
	@LocationID varchar(6) = '259',
	@CSRName varchar(20) = 'Cindy Yee',
	@VehicleTypeID varchar(18) = '*',
	@StartBusDate varchar(24) = '22 Apr 1999',
	@EndBusDate varchar(24) = '24 Apr 1999'
AS
DECLARE @dtStartBus datetime,
	@dtEndBus datetime

SELECT	@dtStartBus = CAST(@StartBusDate as datetime),
	@dtEndBus = CAST(@EndBusDate as datetime)


-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpLocID varchar(6)

if @LocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @LocationID
	END 
-- end of fixing the problem

SELECT	RBR_Date,
	Location_ID,
	CSR_Name,
	Vehicle_Type_ID, 
	Contract_Number,
	Fuel_Charge
FROM	RP_Acc_4_CSR_Detail_Hand_Held_Check_In_L1_SB_Base_1 with(nolock)
WHERE	(@LocationID = "*" OR CONVERT(INT, @tmpLocID) = Location_ID) 
AND	CSR_Name = @CSRName
AND	(  Vehicle_Type_ID = @VehicleTypeID 
	OR @VehicleTypeID = '*'
	)
AND	RBR_Date BETWEEN @dtStartBus AND @dtEndBus
ORDER 
BY	Location_ID,
	Contract_Number

-- Dummy result if previous result is empty
IF @@ROWCOUNT = 0
	SELECT	''

GO
