USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateQRateRestriction]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateQRateRestriction    Script Date: 2/18/99 12:11:50 PM ******/
/****** Object:  Stored Procedure dbo.CreateQRateRestriction    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateQRateRestriction    Script Date: 1/11/99 1:03:14 PM ******/
/*
PROCEDURE NAME: CreateQRateRestriction
PURPOSE: To add a restriction to a Quoted Vehicle Rate
AUTHOR: Don Kirkby
DATE CREATED: Dec 4, 1998
CALLED BY: Maestro
REQUIRES:
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[CreateQRateRestriction]
	@QRateId	varchar(11),
	@RestrictId	varchar(6),
	@TimeOfDay	varchar(5),
	@NumDays	varchar(4),
	@NumHours	varchar(4)
AS
	INSERT
	  INTO	quoted_rate_restriction
		(
		quoted_rate_id,
		restriction_id,
		time_of_day,
		number_of_days,
		number_of_hours
		)
	VALUES	(
		CONVERT(int, NULLIF(@QRateId, '')),
		CONVERT(smallint, NULLIF(@RestrictId, '')),
		NULLIF(@TimeOfDay, ''),

		CONVERT(tinyint, NULLIF(@NumDays, '')),
		CONVERT(tinyint, NULLIF(@NumHours, ''))
		)












GO
