USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRentalLocationFlag]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRentalLocationFlag    Script Date: 2/18/99 12:11:56 PM ******/
/****** Object:  Stored Procedure dbo.GetRentalLocationFlag    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRentalLocationFlag    Script Date: 1/11/99 1:03:16 PM ******/
CREATE PROCEDURE [dbo].[GetRentalLocationFlag]
	@LocName	VarChar(25)
AS
Select	Distinct
	CONVERT(VarChar(1), Rental_Location)
From
	Location
Where
	Location = @LocName
Return 1












GO
