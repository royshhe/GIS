USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResAllOptExtra]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetResAllOptExtra    Script Date: 2/18/99 12:12:03 PM ******/
/****** Object:  Stored Procedure dbo.GetResAllOptExtra    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResAllOptExtra    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResAllOptExtra    Script Date: 11/23/98 3:55:33 PM ******/
/****** Object:  Stored Procedure dbo.GetResAllOptExtra    Script Date: 7/31/98 2:10:09 PM ******/
-- looks like it is obsolete  
-- Modified by Roy He MS SQL 2008 upgrade

CREATE PROCEDURE [dbo].[GetResAllOptExtra]
AS
DECLARE @CurrDatetime Datetime
DECLARE @LastDatetime Datetime
	SELECT @CurrDatetime = GetDate()
	SELECT @LastDatetime = Convert(Datetime, "31 Dec 2078 11:59PM")
	SELECT	distinct A.Optional_Extra, A.Optional_Extra_ID,
		B.Daily_Rate, B.Weekly_Rate, "1", "",
		CONVERT(Varchar(10), C.LDW_Deductible) as Deductible, A.Type,
		A.Maximum_Quantity
	FROM	
		Optional_Extra A
	Inner Join 	Optional_Extra_Price B
		  On A.Optional_Extra_ID = B.Optional_Extra_ID
	Left Join 	LDW_Deductible C
		 On A.Optional_Extra_ID = C.Optional_Extra_ID

--        LDW_Deductible C,
--		Optional_Extra_Price B,
--		Optional_Extra A
	WHERE	
--	A.Optional_Extra_ID *= C.Optional_Extra_ID
--	AND	A.Optional_Extra_ID = B.Optional_Extra_ID 	AND	
	A.Delete_Flag = 0
	AND	@CurrDatetime BETWEEN B.Optional_Extra_Valid_From
		    AND ISNULL(B.Valid_To, @LastDatetime)
--	ORDER BY C.LDW_Deductible
	RETURN @@ROWCOUNT
GO
