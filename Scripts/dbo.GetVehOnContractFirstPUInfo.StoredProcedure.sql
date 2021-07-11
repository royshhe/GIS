USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehOnContractFirstPUInfo]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









CREATE PROCEDURE [dbo].[GetVehOnContractFirstPUInfo]
	@ContractNum Varchar(10)
AS
	/* 4/29/99 - cpy created - retrieve the initial PULocId and PUDatetime.
				- initial PU info will come from 1st VOC record if its
				  VOC record has different CODatetime and ActualCIDatetime
				- if CODatetime and ActualCIDatetime is the same on the
				  1st VOC record, return the CODatetime/ActualCIDatetime from
				  the 2nd VOC record. */
				
DECLARE @dCODatetime Datetime,
	@iContractNum Int,
	@iUnitNum Int

	SELECT 	@iContractNum = Convert(Int, NULLIF(@ContractNum,''))

	SET ROWCOUNT 1

	SELECT	Contract_Number,
		Unit_Number,
		Checked_Out,
		Pick_Up_Location_ID,
		Actual_Check_In,
		Actual_Drop_Off_Location_ID
	FROM	Vehicle_On_Contract
	WHERE	Contract_Number = @iContractNum
	AND	Checked_Out <> Actual_Check_In
	ORDER BY Checked_Out

	RETURN @@ROWCOUNT
























GO
