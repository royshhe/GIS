USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdCtrctDoNotReplaceVehFlag]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdCtrctDoNotReplaceVehFlag    Script Date: 2/18/99 12:12:11 PM ******/
/****** Object:  Stored Procedure dbo.UpdCtrctDoNotReplaceVehFlag    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdCtrctDoNotReplaceVehFlag    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdCtrctDoNotReplaceVehFlag    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in Contract table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 27 - Moved data conversion code out of the where clause */ 

CREATE PROCEDURE [dbo].[UpdCtrctDoNotReplaceVehFlag]
	@ContractNumber			VarChar(10),
	@DoNotReplaceVehicleFlag	VarChar(1)
AS
	Declare	@nContractNumber Integer
	Select		@nContractNumber = CONVERT(Int, NULLIF(@ContractNumber, ''))

	If @DoNotReplaceVehicleFlag = ''
		SELECT @DoNotReplaceVehicleFlag = '1'	
	UPDATE	Contract
	SET	Do_Not_Replace_Vehicle = CONVERT(Bit, @DoNotReplaceVehicleFlag)

	WHERE	Contract_Number	= @nContractNumber
Return 1














GO
