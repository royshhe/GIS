USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSSASalesAccessories]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetSSASalesAccessories    Script Date: 2/18/99 12:12:04 PM ******/
/****** Object:  Stored Procedure dbo.GetSSASalesAccessories    Script Date: 2/16/99 2:05:42 PM ******/
-- ROY HE MSSQL SERVER 2008 UPGRADE
CREATE PROCEDURE [dbo].[GetSSASalesAccessories] -- 'b-03 DOWNTOWN', '2011-03-22'
	@Location	Varchar(35),
	@CurrDate	Varchar(24)
AS
	/* 5/03/99 - cpy bug fix - convert GST/PST_Exempt to varchar to return 0/1 */

DECLARE @thisLocID int
DECLARE @dCurrDate Datetime
DECLARE @dLastDatetime Datetime

	SELECT 	@thisLocID = (	Select	Location_ID
		 		From	Location
				Where	Location= @Location )

	SELECT 	@dCurrDate = Convert(Datetime, NULLIF(@CurrDate, "")),
		@dLastDatetime = Convert(Datetime, "31 Dec 2078 11:59PM")

	SELECT
		SA.Sales_Accessory + " - " + SA.Unit_Description,
		SA.Sales_Accessory_ID,
		ISNULL(LSA.Price, SAP.Price),
		Convert(Char(1), SAP.GST_Exempt),
		Convert(Char(1), SAP.PST_Exempt),
		LSA.Valid_From
--	FROM
--		Sales_Accessory_Price SAP,
--		Location_Sales_Accessory LSA,
--		Sales_Accessory SA
FROM
		Sales_Accessory SA	
INNER JOIN 	Location_Sales_Accessory LSA
ON SA.Sales_Accessory_ID = LSA.Sales_Accessory_ID
LEFT JOIN 	Sales_Accessory_Price SAP
ON SA.Sales_Accessory_ID = SAP.Sales_Accessory_ID AND 	@dCurrDate BETWEEN SAP.Sales_Accessory_Valid_From AND ISNULL(SAP.Valid_To, @dLastDatetime)
		
		

	WHERE
--		SA.Sales_Accessory_ID *= SAP.Sales_Accessory_ID
--	AND 	SA.Sales_Accessory_ID = LSA.Sales_Accessory_ID	AND 	
	SA.Delete_Flag = 0	
	AND 	@dCurrDate BETWEEN LSA.Valid_From AND ISNULL(LSA.Valid_To, @dLastDatetime)
	AND 	LSA.Location_ID = @thisLocId
	ORDER BY

		SA.Sales_Accessory

	RETURN @@ROWCOUNT
--
--select * from Location_Sales_Accessory
GO
