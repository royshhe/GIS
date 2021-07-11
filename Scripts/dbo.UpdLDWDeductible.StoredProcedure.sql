USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdLDWDeductible]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdLDWDeductible    Script Date: 2/18/99 12:12:05 PM ******/
/****** Object:  Stored Procedure dbo.UpdLDWDeductible    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdLDWDeductible    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdLDWDeductible    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in LDW_Deductible table .
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 27 - Moved data conversion code out of the where clause */

CREATE PROCEDURE [dbo].[UpdLDWDeductible]
	@OptionalExtraID	VarChar(10),
	@VehicleClassCode	VarChar(1),
	@LDWDeductible		VarChar(10)
AS
	Declare	@nOptionalExtraID SmallInt
	Select		@nOptionalExtraID = CONVERT(SmallInt, NULLIF(@OptionalExtraID, ''))

	UPDATE LDW_Deductible
		
	SET	LDW_Deductible = CONVERT(Decimal(9, 2), @LDWDeductible)
	
	WHERE	Optional_Extra_ID	= @nOptionalExtraID
	AND		Vehicle_Class_Code	= @VehicleClassCode
RETURN 1














GO
