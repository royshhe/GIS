USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteQTPR]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteQTPR    Script Date: 2/18/99 12:11:51 PM ******/
/****** Object:  Stored Procedure dbo.DeleteQTPR    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteQTPR    Script Date: 1/11/99 1:03:15 PM ******/
/*
PURPOSE: To delete record(s) from quoted_time_period_rate table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[DeleteQTPR]
	@QRateId	varchar(11),
	@Type		varchar(7),
	@TimePeriod	varchar(10),
	@Start		varchar(6)
AS
	DELETE FROM
	  	quoted_time_period_rate
	WHERE
		quoted_rate_id = CONVERT(int, @QRateId)
		And rate_type = @Type
		And time_period = @TimePeriod
		And time_period_start = CONVERT(smallint, @Start)













GO
