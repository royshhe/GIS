USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateConNonRenterDriving]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateConNonRenterDriving    Script Date: 2/18/99 12:12:12 PM ******/
/****** Object:  Stored Procedure dbo.CreateConNonRenterDriving    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateConNonRenterDriving    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateConNonRenterDriving    Script Date: 11/23/98 3:55:31 PM ******/

/*
PURPOSE: To insert a record into Non_Driving_Renter_ID table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateConNonRenterDriving]
	@ContractNumber	VarChar(10),
	@IdType 	VarChar(20),
	@IdNumber 	VarChar(20),
	@ExpiryDate 	VarChar(24)
AS
	/* 3/12/99 - cpy bug fix - apply nullif on all fields before saving */

	INSERT INTO Non_Driving_Renter_ID
		(
		Contract_Number,
		Type,
		Number,
		Expiry
		)
	VALUES
		(
		CONVERT(Int, NULLIF(@ContractNumber,'')),
		NULLIF(@IdType,''),
		NULLIF(@IdNumber,''),
		CONVERT(DateTime, NULLIF(@ExpiryDate,''))
		)
RETURN 1














GO
