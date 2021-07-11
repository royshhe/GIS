USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ManualEigenImportStart]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
PURPOSE: Set up to manually redo the eigen totals.
AUTHOR: Don Kirkby
DATE CREATED: Oct 25, 1999
CALLED BY:
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[ManualEigenImportStart]
	@RBRDate varchar(24)
AS
DECLARE @dtImportRBR datetime

SELECT	@dtImportRBR = CAST(@RBRDate AS datetime)

DELETE
  FROM	terminal_daily_total
 WHERE	rbr_date = @dtImportRBR






GO
