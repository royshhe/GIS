USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSalesAccessorySearchData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetSalesAccessorySearchData    Script Date: 2/18/99 12:11:57 PM ******/
/****** Object:  Stored Procedure dbo.GetSalesAccessorySearchData    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetSalesAccessorySearchData    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetSalesAccessorySearchData    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetSalesAccessorySearchData]
	@SalesAccesory		VarChar(20),
	@UnitDescription	VarChar(20),
	@ValidFrom		VarChar(24),
	@ValidTo		VarChar(24)
AS
		
	Set Rowcount 2000
	SELECT	SA.Sales_Accessory_ID,
		SA.Sales_Accessory,
		SA.Unit_Description,
		SAP.Price,
		CONVERT(VarChar, SAP.Sales_Accessory_Valid_From, 111),
		CONVERT(VarChar, SAP.Valid_To, 111)
	FROM	Sales_Accessory SA,
		Sales_Accessory_Price SAP
	WHERE	SA.Sales_Accessory Like LTRIM(@SalesAccesory) + '%'
	AND	SA.Unit_Description Like LTRIM(@UnitDescription) + '%'
	AND	SA.Sales_Accessory_ID = SAP.Sales_Accessory_ID
	AND	SA.Delete_Flag = 0
	AND	(
			(
			CONVERT(DateTime, CONVERT(VarChar, SAP.Sales_Accessory_Valid_From, 111))
			>= CONVERT(DateTime, @ValidFrom)
		  AND	CONVERT(DateTime, CONVERT(VarChar, SAP.Sales_Accessory_Valid_From, 111))
			<= CONVERT(DateTime, @ValidTo)
			)
		OR	
			(
			CONVERT(DateTime, CONVERT(VarChar, SAP.Valid_To, 111))
			>= CONVERT(DateTime, @ValidFrom)
		  AND	CONVERT(DateTime, CONVERT(VarChar, SAP.Valid_To, 111))
			<= CONVERT(DateTime, @ValidTo)
			)
		OR
			(
			CONVERT(DateTime, CONVERT(VarChar, SAP.Sales_Accessory_Valid_From, 111))
			<= CONVERT(DateTime, @ValidFrom)
		  AND	CONVERT(DateTime, CONVERT(VarChar, SAP.Valid_To, 111))
			>= CONVERT(DateTime, @ValidTo)
			)
		OR
			(
			CONVERT(DateTime, CONVERT(VarChar, SAP.Sales_Accessory_Valid_From, 111))
			<= CONVERT(DateTime, @ValidFrom)
		  AND	SAP.Valid_To Is Null
			)
		)
RETURN 1












GO
