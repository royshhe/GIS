USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetGLSalesAccessoryRevenueAcct]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetGLSalesAccessoryRevenueAcct    Script Date: 2/18/99 12:11:45 PM ******/
/****** Object:  Stored Procedure dbo.GetGLSalesAccessoryRevenueAcct    Script Date: 2/16/99 2:05:41 PM ******/
CREATE PROCEDURE [dbo].[GetGLSalesAccessoryRevenueAcct] --'101', '1'
	@SalesAccessoryId	Varchar(10),
	@LocationID	VarChar(10)='0'
AS


	Declare @LocatonAcctgSeg VarChar(15)
 


 
 SELECT	@LocatonAcctgSeg =	 (	SELECT	DISTINCT Acctg_Segment
					FROM	Location 
					WHERE	Location_ID = convert(smallint, @LocationID)
				) 

If @LocatonAcctgSeg is not null
		SELECT
			Replace(GL_Revenue_Account, 'XX', @LocatonAcctgSeg)
		FROM
			Sales_Accessory
		WHERE
			Sales_Accessory_ID = Convert(smallint, @SalesAccessoryID)
Else
		SELECT
			GL_Revenue_Account
		FROM
			Sales_Accessory
		WHERE
			Sales_Accessory_ID = Convert(smallint, @SalesAccessoryID)

RETURN 1
GO
