USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllSalesAccessories]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetAllSalesAccessories    Script Date: 2/18/99 12:11:52 PM ******/
/****** Object:  Stored Procedure dbo.GetAllSalesAccessories    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetAllSalesAccessories    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetAllSalesAccessories    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve a list of sales accessory name and id mappings.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllSalesAccessories]
AS
	/* 5/05/99 - cpy modified - removed @CurrDate param
				- return all sales accessory name and id mappings  */

	SELECT	Sales_Accessory + " - " + Unit_Description,
		Sales_Accessory_ID
	FROM	Sales_Accessory
	ORDER BY 1

	RETURN @@ROWCOUNT















GO
