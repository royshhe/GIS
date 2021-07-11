USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateSalesAccessory]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













/****** Object:  Stored Procedure dbo.CreateSalesAccessory    Script Date: 2/18/99 12:11:42 PM ******/
/****** Object:  Stored Procedure dbo.CreateSalesAccessory    Script Date: 2/16/99 2:05:39 PM ******/
/*
PURPOSE: To insert a record into Sales_Accessory table.
MOD HISTORY:
Name    Date        	Comments
NP	Jan/12/2000	Add audit info.
 */

CREATE PROCEDURE [dbo].[CreateSalesAccessory]
	@SalesAccessory		VarChar(25),
	@UnitDescription	VarChar(25),
	@GLRevenueAccount	VarChar(32),
	@LastUpdatedBy		VarChar(20)
AS
	If @SalesAccessory = ''
		Select @SalesAccessory = NULL
	If @UnitDescription = ''
		Select @UnitDescription = NULL
	
	INSERT INTO Sales_Accessory
		(
		Sales_Accessory,
		Unit_Description,
		GL_Revenue_Account,
		Last_Updated_By,
		Last_Updated_On
		)
	VALUES
		(
		@SalesAccessory,
		@UnitDescription,
		NULLIF(@GLRevenueAccount, ''),
		@LastUpdatedBy,
		GetDate()
		)
RETURN @@IDENTITY















GO
