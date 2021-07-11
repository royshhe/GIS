USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateVehOnContractAdjust]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateVehOnContractAdjust    Script Date: 2/18/99 12:12:21 PM ******/
/****** Object:  Stored Procedure dbo.UpdateVehOnContractAdjust    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateVehOnContractAdjust    Script Date: 1/11/99 1:03:18 PM ******/
/*
PURPOSE: To update a record in Vehicle_On_Contract table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 27 - Moved data conversion code out of the where clause */ 

CREATE PROCEDURE [dbo].[UpdateVehOnContractAdjust]
	@ContractNum 	Varchar(10),
	@UnitNum 	Varchar(10),
	@OrgCheckedOut 	Varchar(24),
	@CheckedOut 	Varchar(24),
	@ActualCheckIn 	Varchar(24),
	@PULocId 	Varchar(5),
	@ActualDOLocId 	Varchar(5),
	@KMOut 		Varchar(10),
	@KMIn 		Varchar(10)
AS
	Declare	@nContractNum Integer
	Declare	@nUnitNum Integer
	Declare	@dOrgCheckedOut DateTime

	Select		@nContractNum = Convert(Int, NULLIF(@ContractNum, ''))
	Select		@nUnitNum = Convert(Int, NULLIF(@UnitNum, ''))
	Select		@dOrgCheckedOut = Convert(Datetime, NULLIF(@OrgCheckedOut, ''))
	
	SELECT 	
--		@ContractNum = NULLIF(@ContractNum,""),
--		@UnitNum = NULLIF(@UnitNum,""),
--		@OrgCheckedOut = NULLIF(@OrgCheckedOut,""),
		@CheckedOut = NULLIF(@CheckedOut,""),
		@ActualCheckIn = NULLIF(@ActualCheckIn,""),
		@PULocId = NULLIF(@PULocId,""),
		@ActualDOLocId = NULLIF(@ActualDOLocId,""),
		@KMOut = NULLIF(@KMOut,""),
		@KMIn = NULLIF(@KMIn,"")

	UPDATE 	Vehicle_On_Contract
	SET 	Checked_Out = Convert(Datetime, @CheckedOut),
		Actual_Check_In = Convert(Datetime, @ActualCheckIn),
		Pick_Up_Location_ID = ISNULL(Convert(SmallInt, @PULocId), Pick_Up_Location_ID),
		Actual_Drop_Off_Location_ID = Convert(SmallInt, @ActualDOLocId),
		Km_Out = ISNULL(Convert(Int, @KMOut), Km_Out),
		Km_In = Convert(Int, @KMIn)

	WHERE	Contract_Number	= @nContractNum
	AND		Unit_Number		= @nUnitNum
	AND		Checked_Out		= @dOrgCheckedOut

	/* update child tables */
	UPDATE	Vehicle_Support_Incident
	SET	Checked_Out = Convert(Datetime, @CheckedOut)

	WHERE	Contract_Number 	= @nContractNum
	AND		Unit_Number 		= @nUnitNum
	AND		Checked_Out		= @dOrgCheckedOut
			
	RETURN @@ROWCOUNT














GO
