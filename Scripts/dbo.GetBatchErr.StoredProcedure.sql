USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetBatchErr]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetBatchErr    Script Date: 2/18/99 12:12:14 PM ******/
/****** Object:  Stored Procedure dbo.GetBatchErr    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetBatchErr    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetBatchErr    Script Date: 11/23/98 3:55:32 PM ******/
/*
PROCEDURE NAME: GetBatchErr
PURPOSE: To list the errors that occurred during a batch run
AUTHOR: Don Kirkby
DATE CREATED: Sep 21, 1998
CALLED BY: Maestro
REQUIRES:
ENSURES: returns the list of errors
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetBatchErr]
	@ProcessCode varchar(10),
	@BatchStartDate varchar(24) = ''
AS
	DECLARE @dStart datetime
	IF @BatchStartDate = ''
		SELECT @dStart =
			(SELECT MAX(batch_start_date)
			   FROM	batch_error_log
			  WHERE	process_code = @ProcessCode
			)
	ELSE
		SELECT @dStart = CONVERT(datetime, @BatchStartDate)
	SELECT	bel.process_date,
		bel.maestro_id,
		bel.error_number,
		message = message1 + data_1 + message2 + data_2 + message3 + data_3 + message4
	  FROM	batch_error_log bel,
		batch_error_message bem
	 WHERE	bel.process_code = @ProcessCode
	   AND	bel.error_number = bem.error_number
	   AND	bel.batch_start_date = @dStart
	 ORDER
	    BY	bel.process_date
			
	
	RETURN @@ROWCOUNT














GO
