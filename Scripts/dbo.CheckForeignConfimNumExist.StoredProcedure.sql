USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckForeignConfimNumExist]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO















/****** Object:  Stored Procedure dbo.CheckRateAvailability    Script Date: 2/18/99 12:11:40 PM ******/
/****** Object:  Stored Procedure dbo.CheckRateAvailability    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CheckRateAvailability    Script Date: 1/11/99 1:03:13 PM ******/
/****** Object:  Stored Procedure dbo.CheckRateAvailability    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To check whether or not the given ValidFrom and ValidTo dates are within the Rate Availability's ValidFrom and ValidTo.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CheckForeignConfimNumExist]
	@ForeignConfirmNum Varchar(20)
AS
DECLARE @RowFound Int
SELECT @RowFound = (
	SELECT
		COUNT(Confirmation_Number)
	FROM
		Reservation
	WHERE
		Foreign_Confirm_Number =@ForeignConfirmNum)
IF @RowFound >= 1
	RETURN 1		
ELSE
	RETURN 0
















GO
