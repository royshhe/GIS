USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSalesAccessoryLocation]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetSalesAccessoryLocation    Script Date: 2/18/99 12:12:04 PM ******/
/****** Object:  Stored Procedure dbo.GetSalesAccessoryLocation    Script Date: 2/16/99 2:05:42 PM ******/
CREATE PROCEDURE [dbo].[GetSalesAccessoryLocation]
	@SalesAccessoryID	VarChar(10),
	@ValidFrom		VarChar(24),
	@ValidTo		VarChar(24),
	@MaxSmallDateTime	VarChar(24)
AS
	/* 4/16/99 - cpy bug fix - previously only returning rows that were effective after
				@ValidFrom ie. have Valid_To >= @ValidFrom; now returning
				additionally any rows that currently valid TODAY */
	/* 4/23/99 - cpy bug fix - return all location specific rows for this sales accessory,
				order by location and valid from date */

DECLARE	@dMaxSmallDateTime Datetime

	SELECT	@dMaxSmallDateTime = CONVERT(DateTime, ISNULL(NULLIF(@MaxSmallDateTime,''), 'Dec 31 2078 23:59')),
		@ValidFrom = NULLIF(@ValidFrom,'')


	SELECT	lsa.Location_ID,
		CONVERT(VarChar, lsa.Valid_From, 111),
		lsa.Location_ID,
		CONVERT(VarChar, lsa.Valid_From, 111),
		CONVERT(VarChar, lsa.Valid_To, 111),
		lsa.Price,
		lsa.Last_Changed_By,
		CONVERT(VarChar, lsa.Last_Changed_On, 111)
	FROM	Location_Sales_Accessory lsa
		JOIN location loc
	  	  ON loc.location_id = lsa.location_id
	WHERE	Sales_Accessory_ID	= CONVERT(SmallInt, @SalesAccessoryID)
	ORDER
	BY	loc.location asc, lsa.Valid_From desc
RETURN 1














GO
