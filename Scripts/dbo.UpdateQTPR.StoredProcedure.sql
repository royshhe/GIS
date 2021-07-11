USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateQTPR]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateQTPR    Script Date: 2/18/99 12:11:58 PM ******/
/****** Object:  Stored Procedure dbo.UpdateQTPR    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateQTPR    Script Date: 1/11/99 1:03:17 PM ******/
/*
PURPOSE: To update a record in quoted_time_period_rate table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 28 - Moved data conversion code out of the where clause */

CREATE PROCEDURE [dbo].[UpdateQTPR]
	@QRateId	varchar(11),
	@Type		varchar(7),
	@NewTimePeriod	varchar(10),
	@NewTimePeriodStart	varchar(6),
	@End		varchar(6),
	@Amount		varchar(11),
	@KmCap		varchar(6),
	@OldTimePeriod	varchar(10),
	@OldTimePeriodStart	varchar(6)
AS
	Declare	@nQRateId Integer
	Declare	@nNewTimePeriodStart SmallInt

	Select		@nQRateId = CONVERT(int, NULLIF(@QRateId, ''))
	Select		@nNewTimePeriodStart = CONVERT(smallint, NULLIF(@NewTimePeriodStart, ''))
	Select		@Type = NULLIF(@Type, '')

	UPDATE
	  	quoted_time_period_rate
	Set
		time_period = @NewTimePeriod,
		time_period_start = Convert(smallint, NULLIF(@NewTimePeriodStart, "")),
		time_period_end = CONVERT(smallint, NULLIF(@End, '')),
		amount = CONVERT(decimal(9,2), NULLIF(@Amount, '')),
		km_cap = CONVERT(smallint, NULLIF(@KmCap, ''))
	Where
		quoted_rate_id = @nQRateId
	And 	rate_type = @Type
	And 	time_period = @OldTimePeriod
	And 	time_period_start = @nNewTimePeriodStart





GO
