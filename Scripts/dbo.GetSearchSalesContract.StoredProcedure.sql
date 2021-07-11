USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSearchSalesContract]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--SELECT * FROM Sales_Accessory_Sale_Contract



/****** Object:  Stored Procedure dbo.GetSearchSalesContract    Script Date: 2/18/99 12:12:09 PM ******/
/****** Object:  Stored Procedure dbo.GetSearchSalesContract    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetSearchSalesContract    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetSearchSalesContract    Script Date: 11/23/98 3:55:34 PM ******/
-- ROY HE MSSQL 2008 UPGRADE

CREATE PROCEDURE [dbo].[GetSearchSalesContract] -- '2010-12-21', 20,'Severyn', 'Chelsey'
	@SaleDate varchar(20),
	@LocationID varchar(35),
	@LastName varchar(25),
	@FirstName varchar(25)
AS
	/* 5/03/99 - cpy bug fix - simplified substring part */
	/* 5/04/99 - cpy bug fix - add search for time if @SaleDate is provided */
	/* 9/27/99 - do type conversion outside of select */

Set RowCount 100

DECLARE	@sSaleDate Varchar(20),
	@iLocId Int,
	@sLastName Varchar(35),
	@sFirstName Varchar(35)
	
	-- convert @SaleDate into YYYY-MM-DD format for comparison using like
	-- if @SaleDate contains date and time, convert whole string;
	-- otherwise, just convert date only
	SELECT	@sSaleDate = CASE
			WHEN LEN(@SaleDate) > 11
				THEN CONVERT(Varchar(16), CONVERT(DATETIME, NULLIF(@SaleDate,'')), 20)
			ELSE
				CONVERT(Varchar(10), CONVERT(DATETIME, NULLIF(@SaleDate,'')), 20)
			END,
		@iLocId = Convert(int,NULLIF(@LocationID,'')),
		@sLastName = LTrim(@LastName) + '%',
		@sFirstname = LTrim(@FirstName) + '%'

	SELECT @sSaleDate = @sSaleDate + '%'

SELECT DISTINCT
	SASC.Sales_Contract_Number,

	Convert(Varchar(11), SASC.Sales_Date_Time),
	Convert(Varchar(5), SASC.Sales_Date_Time, 114),
	L.Location,
	SASC.Last_Name,
	SASC.First_Name,
	'$' + Convert(varchar,SASP.Amount)
FROM
	Sales_Accessory_Sale_Contract SASC
	INNER JOIN Location L 
	ON SASC.Sold_At_Location_ID = L.Location_ID
	Left Join     Sales_Accessory_Sale_Payment SASP
	On SASC.Sales_Contract_Number = SASP.Sales_Contract_Number
	
WHERE
--	SASC.Sales_Contract_Number *= SASP.Sales_Contract_Number
	--And DateDiff(day, SASC.Sales_Date_Time, CONVERT(datetime, ISNULL(NULLIF(@SaleDate,''),SASC.Sales_Date_Time))) = 0	And 
	CONVERT(Varchar(16), SASC.Sales_Date_Time, 20) LIKE @sSaleDate
	And SASC.Sold_At_Location_ID = ISNULL(@iLocId, SASC.Sold_At_Location_ID)
	And SASC.Last_Name Like @sLastName
	And SASC.First_Name Like @sFirstname
--	And SASC.Sold_At_Location_ID = L.Location_ID
RETURN @@ROWCOUNT
GO
