USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptProcessCode]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRptProcessCode    Script Date: 2/18/99 12:12:16 PM ******/
/*
PROCEDURE NAME: GetRptProcessCode
PURPOSE: To retrieve a list of process codes from the batch error log.
AUTHOR: Don Kirkby
DATE CREATED: Feb 16, 1999
CALLED BY: ReportParams
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetRptProcessCode]
AS
	SELECT
      DISTINCT	process_code
	  FROM	batch_error_log
	 ORDER
	    BY	process_code













GO
