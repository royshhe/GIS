USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckRateAvailability]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
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

CREATE PROCEDURE [dbo].[CheckRateAvailability]
	@RateId Varchar(10),
	@ValidFrom Varchar(24),
	@ValidTo Varchar(24)
AS
DECLARE @RowFound Int
DECLARE @dLastDatetime Datetime
	SELECT @dLastDatetime = Convert(Datetime, "31 Dec 2078 23:59")
SELECT @RowFound = (
	SELECT
		COUNT(Rate_Id)
	FROM
		Rate_Availability
	WHERE
		Rate_Id = Convert(int, @RateId)
		AND	Termination_Date = 'Dec 31 2078 23:59'
		AND	Convert(Datetime, @ValidFrom) between Valid_From and
				ISNULL(Valid_To, @dLastDatetime)
		AND	Convert(Datetime, @ValidTo) between Valid_From and
				ISNULL(Valid_To, @dLastDatetime) )
IF @RowFound >= 1
	RETURN 1		
ELSE
	RETURN 0













GO
