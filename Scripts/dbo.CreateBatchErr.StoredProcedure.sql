USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateBatchErr]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateBatchErr    Script Date: 2/18/99 12:12:12 PM ******/
/****** Object:  Stored Procedure dbo.CreateBatchErr    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateBatchErr    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateBatchErr    Script Date: 11/23/98 3:55:31 PM ******/
/*
PROCEDURE NAME: CreateBatchErr
PURPOSE: To log an error during a batch process
AUTHOR: Don Kirkby
DATE CREATED: Sep 21, 1998
CALLED BY: Contract
REQUIRES:
ENSURES: a record is created in the Batch_Error_Log

MOD HISTORY:
Name    Date        	Comments
NP	Mar. 16, 1999	Added @Data3 as optional parameter
*/
CREATE PROCEDURE [dbo].[CreateBatchErr]
	@ProcessCode varchar(10),
	@BatchStartDate varchar(24),
	@RecordId varchar(11),
	@ErrNum varchar(11),
	@Data1 varchar(255),
	@Data2 varchar(255),
	@Data3 varchar(255) = Null
AS
	INSERT
	  INTO	batch_error_log
		(
		process_code,
		process_date,
		batch_start_date,
		maestro_id,
		error_number,
		data_1,
		data_2,
		data_3
		)
	VALUES	(
		@ProcessCode,
		GETDATE(),
		CONVERT(datetime, NULLIF(@BatchStartDate, '')),
		CONVERT(int, NULLIF(@RecordId, '')),
		CONVERT(int, NULLIF(@ErrNum, '')),
		NULLIF(@Data1, ''),
		NULLIF(@Data2, ''),
		NULLIF(@Data3, '')
		)
	
	RETURN @@ROWCOUNT













GO
