USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckResRateAvail]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CheckResRateAvail    Script Date: 2/18/99 12:11:41 PM ******/
/****** Object:  Stored Procedure dbo.CheckResRateAvail    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CheckResRateAvail    Script Date: 1/11/99 1:03:13 PM ******/
/****** Object:  Stored Procedure dbo.CheckResRateAvail    Script Date: 11/23/98 3:55:31 PM ******/
CREATE PROCEDURE [dbo].[CheckResRateAvail]
	@RateId Varchar(10),
	@ResDate Varchar(24),
	@PUDate Varchar(24)
AS
DECLARE @dLastDatetime Datetime
	SELECT @dLastDatetime = Convert(Datetime, "31 Dec 2078 23:59")
	SELECT 	"1"
	FROM	Rate_Availability
	WHERE	Rate_ID = Convert(Int, @RateId)
	AND	Convert(Datetime, @ResDate) BETWEEN Effective_Date AND Termination_Date
	AND	Convert(Datetime, @PUDate) BETWEEN Valid_From AND
			ISNULL(Valid_To, @dLastDatetime)
	RETURN @@ROWCOUNT












GO
