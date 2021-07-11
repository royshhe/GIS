USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResSalesAccById]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--
--SELECT * FROM Sales_Accessory
--
--SELECT * FROM Location_Sales_Accessory
--



/****** Object:  Stored Procedure dbo.GetResSalesAccById    Script Date: 2/18/99 12:12:04 PM ******/
/****** Object:  Stored Procedure dbo.GetResSalesAccById    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResSalesAccById    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetResSalesAccById    Script Date: 11/23/98 3:55:34 PM ******/
-- ROY HE MS SQL 2008 UPGRADE
CREATE PROCEDURE [dbo].[GetResSalesAccById] --115, '2011-03-24'
	@SalesAccId Varchar(5),
	@CurrDate Varchar(24)
AS
DECLARE @dCurrDate Datetime
DECLARE @dLastDatetime Datetime
	SELECT @dCurrDate = ISNULL( Convert(Datetime,
					NULLIF(@CurrDate, "")), GETDATE())
	SELECT @dLastDatetime = Convert(Datetime, "31 Dec 2078 11:59PM")
	SET ROWCOUNT 1   -- ONLY SELCT THE FIRST ROW?
	SELECT	A.Sales_Accessory + " - " + A.Unit_Description Sales_Accessory,
		A.Sales_Accessory_ID, 
		A.Unit_Description, -- Added
		ISNULL(B.Price, C.Price) Price,		
		C.GST_Exempt,  -- Added
		C.PST_Exempt   -- Added
		 
		   
	FROM	Sales_Accessory A
		LEFT JOIN 	Location_Sales_Accessory B
		ON A.Sales_Accessory_ID = B.Sales_Accessory_ID
	LEFT JOIN 	Sales_Accessory_Price C
		 ON A.Sales_Accessory_ID = C.Sales_Accessory_ID
			  AND	@dCurrDate BETWEEN C.Sales_Accessory_Valid_From AND
			ISNULL(C.Valid_To, @dLastDatetime)
		
		
	WHERE	
--	A.Sales_Accessory_ID *= C.Sales_Accessory_ID
--	AND	A.Sales_Accessory_ID *= B.Sales_Accessory_ID	AND	
	A.Sales_Accessory_ID = Convert(SmallInt, @SalesAccId)
--  AND	@dCurrDate BETWEEN C.Sales_Accessory_Valid_From AND
--			ISNULL(C.Valid_To, @dLastDatetime)

	RETURN @@ROWCOUNT
GO
