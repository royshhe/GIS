USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteAllQTPR]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteAllQTPR    Script Date: 2/18/99 12:11:50 PM ******/
/****** Object:  Stored Procedure dbo.DeleteAllQTPR    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteAllQTPR    Script Date: 1/11/99 1:03:14 PM ******/
/*
PURPOSE: To delete record(s) from quoted_time_period_rate table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[DeleteAllQTPR]
	@QRateId	varchar(11),
	@Type		varchar(7)
AS
	DELETE FROM
	  	quoted_time_period_rate
	WHERE
		quoted_rate_id = CONVERT(int, @QRateId)
		And rate_type = @Type













GO
