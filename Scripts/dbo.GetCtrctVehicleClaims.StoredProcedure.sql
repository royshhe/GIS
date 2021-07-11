USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctVehicleClaims]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*  PURPOSE:		To retrieve all claims related to any vehicles on contract for the given contract number.
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctVehicleClaims]
	@ContractNum Varchar(10)
AS
	/* 2/26/99 - cpy created - used for contract print
			- return all claims related to any vehicles on contract
			- add more fields if necessary */
	/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */

	DECLARE	@nContractNum Integer
	SELECT	@nContractNum = Convert(Int, NULLIF(@ContractNum,''))

	SELECT	VC.Claim_Number, VC.Unit_Number
	FROM		Vehicle_Claim VC,
			Vehicle_On_Contract VOC
	WHERE	VC.Contract_Number = VOC.Contract_Number
	AND	VC.Unit_Number = VOC.Unit_Number
	AND	VC.Contract_Number = @nContractNum

	RETURN @@ROWCOUNT














GO
