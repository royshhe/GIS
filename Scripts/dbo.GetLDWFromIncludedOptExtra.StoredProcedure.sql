USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLDWFromIncludedOptExtra]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetLDWFromIncludedOptExtra    Script Date: 2/18/99 12:12:08 PM ******/
/****** Object:  Stored Procedure dbo.GetLDWFromIncludedOptExtra    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetLDWFromIncludedOptExtra    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLDWFromIncludedOptExtra    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetLDWFromIncludedOptExtra]
	@ContractNum Varchar(10)
AS
	/* 10/14/99 - do type conversion and nullif outside of SQL statements */
DECLARE	@iCtrctNum Int

	SELECT @iCtrctNum = Convert(Int, NULLIF(@ContractNum,''))

	SELECT	LDW.LDW_Deductible

	FROM		Contract CON,
			Included_Optional_Extra IOE,
			LDW_Deductible LDW

	WHERE	CON.Contract_Number = @iCtrctNum
	AND		CON.Rate_ID = IOE.Rate_ID
	AND		IOE.Termination_Date >= CONVERT(DateTime, 'Dec 31 2078 23:59:00')
	AND		IOE.Optional_Extra_ID = LDW.Optional_Extra_ID
	AND		LDW.Vehicle_Class_Code = CON.Vehicle_Class_Code

	RETURN @@ROWCOUNT









GO
