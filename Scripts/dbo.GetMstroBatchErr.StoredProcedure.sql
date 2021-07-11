USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetMstroBatchErr]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetMstroBatchErr    Script Date: 2/18/99 12:12:16 PM ******/
/****** Object:  Stored Procedure dbo.GetMstroBatchErr    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetMstroBatchErr    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetMstroBatchErr    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetMstroBatchErr
PURPOSE: To list the errors that occurred during a batch run
AUTHOR: Don Kirkby
DATE CREATED: Sep 25, 1998
CALLED BY: Maestro
REQUIRES:
ENSURES: returns the list of errors
MOD HISTORY:
Name    Date        Comments
Don K	Nov 24 1998 Changed record_id to maestro_id and confirmation
		_number to foreign_confirm_number
Don K	Dec 11 1998 Changed order of the columns
Don K	Jan 21 1999 Made params optional
Roy He	 2011-03-16 MS SQL 2008
*/
CREATE PROCEDURE [dbo].[GetMstroBatchErr]
	@FromDate varchar(24) = '',
	@ToDate varchar(24) = ''
AS
	DECLARE @dFrom datetime,
		@dTo datetime
	IF @FromDate = ''
		SELECT @dFrom =
			(SELECT MAX(batch_start_date)
			   FROM	batch_error_log
			  WHERE process_code = 'Maestro'
			)
	ELSE
		SELECT @dFrom = CONVERT(datetime, @FromDate)
	IF @ToDate = ''
		SELECT @dTo = GETDATE()
	ELSE
		SELECT @dTo = CONVERT(datetime, @ToDate)
	SELECT	CONVERT(varchar(20), mst.transaction_date) tx_date,
		mst.sequence_number seq,
		CONVERT(varchar(12), mst.foreign_confirm_number) Fconfirm,
		bem.error_level lev,
		message1 + data_1 + message2 +
			data_2 + message3 message ,
		CONVERT(varchar(20), process_date, 113),
		mst.maestro_id,
		data_1,
		data_2
	  FROM	batch_error_log bel
		Inner Join	batch_error_message bem
		On bel.error_number = bem.error_number
        Left Join 	maestro mst
        On bel.maestro_id= mst.maestro_id  
	 WHERE	bel.process_code = 'Maestro'
	   --AND	bel.error_number = bem.error_number
	   AND	bel.batch_start_date
		BETWEEN	@dFrom
		    AND	@dTo
	   --AND	mst.maestro_id =* bel.maestro_id
	 ORDER
	    BY	bel.batch_start_date, bel.process_date
	
	RETURN @@ROWCOUNT
GO
