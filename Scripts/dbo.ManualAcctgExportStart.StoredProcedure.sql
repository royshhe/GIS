USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ManualAcctgExportStart]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
PURPOSE: Set up to manually redo an export.
AUTHOR: Don Kirkby
DATE CREATED: Apr 30, 1999
CALLED BY:
MOD HISTORY:
Name    Date        Comments
Don K	Aug 3 1999  Added business_transaction_export table
Don K	Oct 25 1999 Renamed
Don K	Nov 2 1999  Leave the current rbr date alone. Clear export_failed flag.
*/
CREATE PROCEDURE [dbo].[ManualAcctgExportStart]
	@RBRDate varchar(24)
AS
DECLARE @dtExportRBR datetime

SELECT	@dtExportRBR = CAST(@RBRDate AS datetime)

DELETE
  FROM	ar_export
 WHERE	rbr_date = @dtExportRBR

DELETE
  FROM	journal_voucher_account_detail
 WHERE	rbr_date = @dtExportRBR

DELETE
  FROM	business_transaction_export
 WHERE	rbr_date = @dtExportRBR

UPDATE	rbr_date
   SET	date_gl_generated = NULL,
	date_ar_generated = NULL,
	export_failed = 0
 WHERE	rbr_date = @dtExportRBR





GO
