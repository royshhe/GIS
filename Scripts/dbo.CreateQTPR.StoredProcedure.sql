USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateQTPR]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateQTPR    Script Date: 2/18/99 12:11:50 PM ******/
/****** Object:  Stored Procedure dbo.CreateQTPR    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateQTPR    Script Date: 1/11/99 1:03:14 PM ******/
/*
PROCEDURE NAME: CreateQTPR
PURPOSE: To add a Time Period to a Quoted Vehicle Rate
AUTHOR: Don Kirkby
DATE CREATED: Dec 3, 1998
CALLED BY: Maestro
REQUIRES:
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[CreateQTPR]
	@QRateId	varchar(11),
	@Type		varchar(7),
	@TimePeriod	varchar(10),
	@Start		varchar(6),
	@End		varchar(6),
	@Amount		varchar(11),
	@KmCap		varchar(6)
AS
	INSERT
	  INTO	quoted_time_period_rate
		(
		quoted_rate_id,
		rate_type,
		time_period,
		time_period_start,
		time_period_end,
		amount,
		km_cap
		)
	VALUES	(
		CONVERT(int, NULLIF(@QRateId, '')),
		NULLIF(@Type, ''),
		NULLIF(@TimePeriod, ''),
		CONVERT(smallint, NULLIF(@Start, '')),
		CONVERT(smallint, NULLIF(@End, '')),
		CONVERT(decimal(9,2), NULLIF(@Amount, '')),
		CONVERT(smallint, NULLIF(@KmCap, ''))
		)












GO
