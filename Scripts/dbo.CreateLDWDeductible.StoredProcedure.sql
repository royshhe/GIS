USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateLDWDeductible]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateLDWDeductible    Script Date: 2/18/99 12:11:59 PM ******/
/****** Object:  Stored Procedure dbo.CreateLDWDeductible    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateLDWDeductible    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateLDWDeductible    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into LDW_Deductible table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateLDWDeductible]
	@OptionalExtraID	VarChar(10),
	@VehicleClassCode	VarChar(1),
	@LDWDeductible		VarChar(10)
AS
	INSERT INTO LDW_Deductible
		(
		Optional_Extra_ID,
		Vehicle_Class_Code,
		LDW_Deductible
		)
	VALUES	
		(
		CONVERT(SmallInt, @OptionalExtraID),
		@VehicleClassCode,
		CONVERT(Decimal(9, 2), @LDWDeductible)
		)
RETURN 1













GO
