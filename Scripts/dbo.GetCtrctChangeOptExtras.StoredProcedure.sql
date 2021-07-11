USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctChangeOptExtras]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetCtrctChangeOptExtras    Script Date: 2/18/99 12:12:01 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChangeOptExtras    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChangeOptExtras    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChangeOptExtras    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve a list of non-restricted optional extra for the valid date.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctChangeOptExtras]
	@VehicleClassCode	varchar(1),
	@ValidOn 		varchar(24)
AS
	DECLARE @dValidOn datetime
	SELECT	@dValidOn = CONVERT(datetime, NULLIF(@ValidOn, ''))
	SELECT	OE.Optional_Extra,
		OE.Optional_Extra_ID,
		OEP.Daily_Rate,
		OEP.Weekly_Rate,
		LDW.LDW_Deductible,
		CONVERT(VarChar, OEP.GST_Exempt),
		CONVERT(VarChar, OEP.HST2_Exempt),
		CONVERT(VarChar, OEP.PST_Exempt)
	  FROM	Optional_Extra OE,
		Optional_Extra_Price OEP,
		LDW_Deductible LDW
	 WHERE	OE.Type IN ('LDW', 'LDWB', 'PAI', 'PEC', 'CARGO','ELI','PAE','RSN')
	   AND	OE.Delete_Flag = 0
	   AND	OEP.Optional_Extra_ID = OE.Optional_Extra_ID
	   AND	@dValidOn
		BETWEEN OEP.Optional_Extra_Valid_From
		    AND ISNULL(OEP.Valid_To, @dValidOn)
	   AND	OE.Optional_Extra_ID NOT IN
			(
			SELECT	Optional_Extra_ID
			  FROM	Optional_Extra_Restriction
			 WHERE	Vehicle_Class_Code = @VehicleClassCode
			)
	 ORDER
	    BY	OE.Optional_Extra
	RETURN @@ROWCOUNT
GO
