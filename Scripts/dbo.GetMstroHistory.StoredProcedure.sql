USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetMstroHistory]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PROCEDURE NAME: GetMstroHistory
PURPOSE: To retrieve the most recent update to a Maestro reservation
AUTHOR: Don Kirkby
DATE CREATED: Sep 24, 1998
CALLED BY: MaestroBatch
REQUIRES:
ENSURES: returns the most recent transaction_date and sequence_number
MOD HISTORY:
Name    Date        Comments
Don K	Nov 24 1998 Changed Confirmation_Number to foreign_confirm_number
Don K	Jan 4 2000  Check update_gis_indicator to avoid problem with NULL 
		sequence numbers.
*/
CREATE PROCEDURE [dbo].[GetMstroHistory]
	@ConfirmNum varchar(20)
AS
	/* 10/25/99 - do nullif outside of Sql statements */

	SELECT	@ConfirmNum = NULLIF(@ConfirmNum, '')
	SELECT  transaction_date, sequence_number = MAX(sequence_number)
	  FROM	maestro
	 WHERE  foreign_confirm_number = @ConfirmNum
	   AND	update_gis_indicator = 1
	   AND  transaction_date =
		(SELECT	MAX(transaction_date)
		   FROM	maestro
		  WHERE	foreign_confirm_number = @ConfirmNum
		)
 GROUP
    BY	transaction_date


GO
