USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResOptExtraById]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetResOptExtraById    Script Date: 2/18/99 12:12:03 PM ******/
/****** Object:  Stored Procedure dbo.GetResOptExtraById    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResOptExtraById    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResOptExtraById    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetResOptExtraById]  --22, '2011-03-25'
	@OptExtraId Varchar(5),
	@CurrDate Varchar(24)
AS
DECLARE @dCurrDatetime Datetime
DECLARE @dLastDatetime Datetime
	SELECT @dCurrDatetime = ISNULL( Convert(Datetime,
					NULLIF(@CurrDate, "")), GETDATE())
	SELECT @dLastDatetime = Convert(Datetime, "31 Dec 2078 11:59PM")
	SET ROWCOUNT 1
	
	SELECT	A.Optional_Extra, A.Optional_Extra_ID,
		B.Daily_Rate, B.Weekly_Rate, "1", "",
		CONVERT(Varchar(10), C.LDW_Deductible), A.Type,
		A.Maximum_Quantity,
		CONVERT(int, B.gst_exempt) HST_Exempt,
		CONVERT(int, B.HST2_exempt)HST2_Exempt,
		CONVERT(int, B.pst_exempt) PST_exempt


--	FROM	LDW_Deductible C,
--		Optional_Extra_Price B,
--		Optional_Extra A


FROM	
		Optional_Extra A
	Left Join 	Optional_Extra_Price B
		  On A.Optional_Extra_ID = B.Optional_Extra_ID 
				AND	(@dCurrDatetime BETWEEN B.Optional_Extra_Valid_From AND ISNULL(B.Valid_To, @dLastDatetime))
	Left Join 	LDW_Deductible C
		 On A.Optional_Extra_ID = C.Optional_Extra_ID

	WHERE	
--     A.Optional_Extra_ID *= C.Optional_Extra_ID
--	AND	A.Optional_Extra_ID *= B.Optional_Extra_ID	AND	
A.Optional_Extra_ID = Convert(Smallint, @OptExtraId)
	
	
	RETURN @@ROWCOUNT
GO
