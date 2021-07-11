USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResSalesAccessories]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--SELECT * FROM Location_Sales_Accessory




/****** Object:  Stored Procedure dbo.GetResSalesAccessories    Script Date: 2/18/99 12:12:04 PM ******/
/****** Object:  Stored Procedure dbo.GetResSalesAccessories    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResSalesAccessories    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetResSalesAccessories    Script Date: 11/23/98 3:55:34 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
-- Roy He MSQL 2008 upgrade

CREATE PROCEDURE [dbo].[GetResSalesAccessories] -- 201, '2012-10-15'
	@LocId    Varchar(10),
	@CurrDate Varchar(24)
AS
	DECLARE @dCurrDate Datetime
	DECLARe @dLastDatetime Datetime
	DECLARE @nLocId Integer

	SELECT @nLocId = Convert(Int, NULLIF(@LocId, ""))
	SELECT @dCurrDate = Convert(Datetime, NULLIF(@CurrDate, ""))
	SELECT @dLastDatetime = Convert(Datetime, "31 Dec 2078 11:59PM")
	SELECT	A.Sales_Accessory + " - " + A.Unit_Description Sales_Accessory,
		    A.Sales_Accessory_ID, 
		    A.Unit_Description, -- Added
		   ISNULL(B.Price, C.Price) Price,		   
		   C.GST_Exempt,  -- Added
		   C.PST_Exempt   -- Added
	FROM
		Sales_Accessory A
	 INNER JOIN 	Location_Sales_Accessory B
	 ON A.Sales_Accessory_ID = B.Sales_Accessory_ID
     LEFT JOIN 	Sales_Accessory_Price C
		ON A.Sales_Accessory_ID = C.Sales_Accessory_ID
		And @dCurrDate BETWEEN C.Sales_Accessory_Valid_From AND
			ISNULL(C.Valid_To, @dLastDatetime)

	WHERE	
--     A.Sales_Accessory_ID *= C.Sales_Accessory_ID
--	AND	A.Sales_Accessory_ID = B.Sales_Accessory_ID
	A.Delete_Flag = 0  and A.sell_on_contract=1
--	AND	@dCurrDate BETWEEN C.Sales_Accessory_Valid_From AND
--			ISNULL(C.Valid_To, @dLastDatetime)
	AND	@dCurrDate BETWEEN B.Valid_From AND
			ISNULL(B.Valid_To, @dLastDatetime)
	--AND	@dCurrDate BETWEEN C.Sales_Accessory_Valid_From AND
	--		ISNULL(C.Valid_To, @dLastDatetime)

	AND	B.Location_ID = @nLocId and (B.Price is not null or  C.Price is not null)
	ORDER BY A.Sales_Accessory
	RETURN @@ROWCOUNT
GO
