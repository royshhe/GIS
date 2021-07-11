USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOptExtraSearchData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetOptExtraSearchData    Script Date: 2/18/99 12:11:55 PM ******/
/****** Object:  Stored Procedure dbo.GetOptExtraSearchData    Script Date: 2/16/99 2:05:42 PM ******/
/*
PROCEDURE NAME: GetOptExtraSearchData
PURPOSE: To search the Optional_Extra table
AUTHOR: ?
DATE CREATED: ?
CALLED BY: OptExtra
MOD HISTORY:

Name    Date        Comments
Don K	Feb 8 1999  Expanded @OptionalExtra to 35, look up type names instead
			of codes. Added @Type param.
*/
CREATE PROCEDURE [dbo].[GetOptExtraSearchData]
	@OptionalExtra		VarChar(35),
	@ValidFrom		VarChar(24),
	@ValidTo		VarChar(24),
	@Type			VarChar(25)
AS
	
	Set Rowcount 2000
	SELECT	OE.Optional_Extra_ID,
		OE.Optional_Extra,
		lt.value type_name,
		CONVERT(VarChar, OEP.Optional_Extra_Valid_From, 111),
		CONVERT(VarChar, OEP.Valid_To, 111),
		OE.Delete_Flag
	FROM	Optional_Extra OE,
		Optional_Extra_Price OEP,
		Lookup_Table lt
	WHERE	oe.type = lt.code
	AND	lt.category = 'OptionalExtra'
	AND	OE.Optional_Extra Like LTRIM(@OptionalExtra) + '%'
	AND	OE.Optional_Extra_ID = OEP.Optional_Extra_ID
	AND	OE.Delete_Flag = 0
	AND	(  lt.code = @Type
		OR @Type = ''
		)
	AND	(
			(
			CONVERT(DateTime, CONVERT(VarChar, OEP.Optional_Extra_Valid_From, 111))
			>= CONVERT(DateTime, @ValidFrom)
		  AND	CONVERT(DateTime, CONVERT(VarChar, OEP.Optional_Extra_Valid_From, 111))
			<= CONVERT(DateTime, @ValidTo)
			)
		OR	
			(
			CONVERT(DateTime, CONVERT(VarChar, OEP.Valid_To, 111))
			>= CONVERT(DateTime, @ValidFrom)
		  AND	CONVERT(DateTime, CONVERT(VarChar, OEP.Valid_To, 111))
			<= CONVERT(DateTime, @ValidTo)
			)
		OR
			(
			CONVERT(DateTime, CONVERT(VarChar, OEP.Optional_Extra_Valid_From, 111))
			<= CONVERT(DateTime, @ValidFrom)
		  AND	CONVERT(DateTime, CONVERT(VarChar, OEP.Valid_To, 111))
			>= CONVERT(DateTime, @ValidTo)
			)
		OR
			(
			CONVERT(DateTime, CONVERT(VarChar, OEP.Optional_Extra_Valid_From, 111))
			<= CONVERT(DateTime, @ValidFrom)
		  AND	OEP.Valid_To Is Null
			)
		)
	ORDER
	BY	OE.Optional_Extra
RETURN 1












GO
