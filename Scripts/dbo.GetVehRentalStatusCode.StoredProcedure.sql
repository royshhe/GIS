USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehRentalStatusCode]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetVehRentalStatusCode    Script Date: 2/18/99 12:11:48 PM ******/
/****** Object:  Stored Procedure dbo.GetVehRentalStatusCode    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehRentalStatusCode    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehRentalStatusCode    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetVehRentalStatusCode]
	@Category	VarChar(25)
AS
	Set Rowcount 2000
	Select	Code
	From	Lookup_Table
	Where	Category=@Category
	And	Value = 'Rental'
Return 1












GO
