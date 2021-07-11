USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctCoverages]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--=================================
/****** Object:  Stored Procedure dbo.GetCtrctCoverages    Script Date: 2/18/99 12:12:01 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctCoverages    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctCoverages    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctCoverages    Script Date: 11/23/98 3:55:33 PM ******/
/*
PURPOSE: 	To retrieve a list of optional extras, which are not in the restricted list,  for the given vehicle class code.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctCoverages]-- 'A','10 feb 2016'
	@VehicleClassCode	VarChar(1),
	@ValidOn		VarChar(24)
AS
	/* 3/31/99 - cpy comment - Return list of all valid coverage related
			optional extras and their prices; coverage-related
			means all opt extra of type LDW, PAI, PEC, Cargo, Buydown

		   - SP GetCtrctOptExtras returns list of all valid non-coverage
			related optional extras */

	/* 4/01/99 - cpy modified - added optional extra type */
	/* 5/26/99 - np modified - to return two more fields, GST_Exempt and PST_Exempt */
	DECLARE @dValidOn DateTime
	SELECT @dValidOn = CONVERT(DateTime, NULLIF(@ValidOn, ''))

	SELECT	Distinct
		OE.Optional_Extra,
		OE.Optional_Extra_ID,
		OEP.Daily_Rate,
		OEP.Weekly_Rate,
		LDW.LDW_Deductible,
		OE.Type,
		CONVERT(Char(1), OEP.GST_Exempt),
		CONVERT(Char(1), OEP.HST2_Exempt),
		CONVERT(Char(1), OEP.PST_Exempt)
	
	FROM	      Optional_Extra OE WITH(NOLOCK)
Inner Join 	Optional_Extra_Price OEP WITH(NOLOCK)
			On OE.Optional_Extra_ID = OEP.Optional_Extra_ID
Left Join 	LDW_Deductible LDW WITH(NOLOCK)
			On OE.Optional_Extra_ID= LDW.Optional_Extra_ID
				And LDW.Vehicle_Class_Code = @VehicleClassCode
--
--
--Optional_Extra OE WITH(NOLOCK),
--		Optional_Extra_Price OEP WITH(NOLOCK),
--		LDW_Deductible LDW WITH(NOLOCK)


	WHERE	--OE.Optional_Extra_ID = OEP.Optional_Extra_ID	AND	
					--OE.Optional_Extra_ID *= LDW.Optional_Extra_ID	AND	
					--LDW.Vehicle_Class_Code = @VehicleClassCode 	AND	
			    OE.Type IN ('LDW', 'Buydown',  'Cargo','ELI','PAE','RSN')--'PAI', 'PEC',
	AND	@dValidOn BETWEEN OEP.Optional_Extra_Valid_From AND ISNULL(OEP.Valid_To, CONVERT(DateTime, '2078 Dec 31'))
    AND OE.Delete_Flag=0

	
	AND	OE.Optional_Extra_ID NOT IN (	SELECT	Optional_Extra_ID
						FROM	Optional_Extra_Restriction
						WHERE	Vehicle_Class_Code = @VehicleClassCode
					    )
	ORDER BY
		OE.Optional_Extra
	
RETURN @@ROWCOUNT

GO
