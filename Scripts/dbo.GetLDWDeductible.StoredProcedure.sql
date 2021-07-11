USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLDWDeductible]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetLDWDeductible    Script Date: 2/18/99 12:12:02 PM ******/
/****** Object:  Stored Procedure dbo.GetLDWDeductible    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetLDWDeductible    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLDWDeductible    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetLDWDeductible]
	@OptionalExtraID		VarChar(10)
AS
	Set Rowcount 2000
	SELECT	DISTINCT
		CONVERT(VarChar, LDW.Optional_Extra_ID),
		VC.Vehicle_Class_Name,
		LDW.Vehicle_Class_Code,
		CONVERT(VarChar,LDW.LDW_Deductible)
	FROM	LDW_Deductible LDW,
		Vehicle_Class VC
	WHERE	VC.Vehicle_Class_Code = LDW.Vehicle_Class_Code
	AND	LDW.Optional_Extra_ID = CONVERT(SmallInt, @OptionalExtraID)
	UNION
	SELECT	DISTINCT
		'',
		Vehicle_Class_Name,
		Vehicle_Class_Code,
		''
	
	FROM	Vehicle_Class
	WHERE	Vehicle_Class_Code NOT IN
		(
			SELECT	DISTINCT
				Vehicle_Class_Code
			FROM	LDW_Deductible
	
			WHERE	Optional_Extra_ID = CONVERT(SmallInt, @OptionalExtraID)
		)
	ORDER BY
		Vehicle_Class_Name
RETURN 1












GO
