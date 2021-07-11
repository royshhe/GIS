USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[NewCheckRateAvailability]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.NewCheckRateAvailability    Script Date: 2/18/99 12:11:48 PM ******/
/****** Object:  Stored Procedure dbo.NewCheckRateAvailability    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.NewCheckRateAvailability    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.NewCheckRateAvailability    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: 	To check whether or not the given ValidFrom and ValidTo dates
	  	are within the Rate Availability's ValidFrom and ValidTo. 
		
		if ValidFrom and ValidTo fall outside of an effective
		Rate Availability's valid range, return 0, else return 1.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[NewCheckRateAvailability]
	@RateId Varchar(10),
	@ValidFrom Varchar(24),
	@ValidTo Varchar(24)
AS
	/* check whether or not the given ValidFrom and ValidTo dates
	   are within the Rate Availability's ValidFrom and ValidTo */
DECLARE @RowFound Int
DECLARE @ValidFromDatetime DateTime
DECLARE @ValidToDatetime DateTime
declare @tmp Varchar(24)
	/* if ValidFrom or ValidTo = today's date, use current datetime */
	IF SUBSTRING(@ValidFrom, 1, 11) = CONVERT(Varchar(11), GetDate())
	   BEGIN
		SELECT @ValidFromDatetime = GetDate()
	   END
	ELSE
	   BEGIN
		SELECT @ValidFromDatetime = CONVERT(Datetime, @ValidFrom)
	   END
	select @tmp = Convert(Varchar(24), @ValidFromDatetime, 113)
	print @tmp
	IF SUBSTRING(@ValidTo, 1, 11) = CONVERT(Varchar(11), GetDate())
	   BEGIN
		SELECT @ValidToDatetime = GetDate()
	   END
	ELSE
	   BEGIN
		SELECT @ValidToDatetime = CONVERT(Datetime, @ValidTo)
	   END
	select @tmp = Convert(Varchar(24), @ValidToDatetime, 113)
	print @tmp
	
	/* if ValidFrom and ValidTo fall outside of an effective
	   Rate Availability's valid range, return 0, else return 1 */
	SELECT @RowFound = (
		SELECT 	COUNT(Rate_Id)
		FROM	Rate_Availability
		WHERE	Rate_Id = Convert(int, @RateId)
		AND	Termination_Date =
				Convert(Datetime, 'Dec 31 2078 11:59PM')
		AND	@ValidFromDatetime BETWEEN Valid_From AND Valid_To
		AND	@ValidToDatetime BETWEEN Valid_From AND Valid_To )
	IF @RowFound >= 1
		BEGIN
			print "1"
			RETURN 1
		END
	ELSE
		BEGIN
			print "0"
			RETURN 0
		END













GO
