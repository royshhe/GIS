USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateConRenterDriving]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateConRenterDriving    Script Date: 2/18/99 12:12:12 PM ******/
/****** Object:  Stored Procedure dbo.CreateConRenterDriving    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateConRenterDriving    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateConRenterDriving    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Renter_Driver_Licence table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateConRenterDriving]
	@ContractNumber	VarChar(10),
	@LicenceNumber 	VarChar(25),
	@Jurisdiction 	VarChar(20),
	@ExpiryDate 	VarChar(24),
	@Class 		VarChar(1)
AS
	/* 3/12/99 - cpy bug fix - apply nullif on all fields before saving */
	/* 10/05/99 - @LicenceNumber varchar(10) -> varchar(25) */

	INSERT INTO Renter_Driver_Licence
		(
		Contract_Number,
		Licence_Number,
		Jurisdiction,
		Expiry,
		Class
		)
	VALUES
		(
		CONVERT(Int, NULLIF(@ContractNumber,'')),
		NULLIF(@LicenceNumber,''),
		NULLIF(@Jurisdiction,''),
		CONVERT(DateTime, NULLIF(@ExpiryDate,'')),
		NULLIF(@Class,'')
		)
RETURN 1















GO
