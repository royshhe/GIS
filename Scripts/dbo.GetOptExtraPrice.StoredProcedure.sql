USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOptExtraPrice]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetOptExtraPrice    Script Date: 2/18/99 12:11:55 PM ******/
/****** Object:  Stored Procedure dbo.GetOptExtraPrice    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetOptExtraPrice    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetOptExtraPrice    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetOptExtraPrice]
	@OptionalExtraID	VarChar(10),
	@ValidFrom		VarChar(24)
AS
	SELECT	CONVERT(VarChar, Optional_Extra_Valid_From, 111),
		CONVERT(VarChar, Valid_To, 111),
		Daily_Rate,
		Weekly_Rate,
		Rental_Calendar_Day,
		CONVERT(VarChar, GST_Exempt),
		CONVERT(VarChar, HST2_Exempt),
		CONVERT(VarChar, PST_Exempt),
		Last_Changed_By,
		CONVERT(VarChar, Last_Changed_On, 111)
	FROM	Optional_Extra_Price
	WHERE	Optional_Extra_ID = CONVERT(SmallInt, @OptionalExtraID)
	AND	CONVERT(DateTime, CONVERT(VarChar, Optional_Extra_Valid_From, 111))
		= CONVERT(DateTime, @ValidFrom)
RETURN 1
GO
