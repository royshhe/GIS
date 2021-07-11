USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateAcctgRbrFailures]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To set check for RBR_Date records that haven't been successfully 
	exported, except for the requested RBR date.
AUTHOR: Don Kirkby
DATE CREATED: Nov 2, 1999
CALLED BY: Accounting
MOD HISTORY:
Name    Date        Comments
Don K	May 12 2000 Clear export_failed flag for requested rbr_date.
*/
CREATE PROCEDURE [dbo].[UpdateAcctgRbrFailures]
	@RBRDate varchar(24)
AS
	DECLARE @dRBRDate datetime
	SELECT	@dRBRDate = CAST(@RBRDate AS datetime)

	-- set the flag for any days that haven't been exported.
	UPDATE	rbr_date
	   SET	export_failed = 1
	 WHERE	(  date_gl_generated IS NULL
		OR date_ar_generated IS NULL
		)
	   AND	budget_close_datetime IS NOT NULL
	   AND	rbr_date != @dRBRDate

	UPDATE	rbr_date
	   SET	export_failed = 0
	 WHERE	rbr_date = @dRBRDate


GO
