USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateAcctgRbrAR]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateAcctgRbrAR    Script Date: 2/18/99 12:11:48 PM ******/
/****** Object:  Stored Procedure dbo.UpdateAcctgRbrAR    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdateAcctgRbrAR    Script Date: 1/11/99 1:03:17 PM ******/
/*
PROCEDURE NAME: UpdateAcctgRbrAR
PURPOSE: To record the date that the AR was generated.
AUTHOR: Don Kirkby
DATE CREATED: Jan 6, 1999
CALLED BY: Accounting
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 28 - Moved data conversion code out of the where clause */

CREATE PROCEDURE [dbo].[UpdateAcctgRbrAR]
	@RBRDate varchar(24)
AS
	Declare	@dRBRDate DateTime	
	Select		@dRBRDate = CONVERT(datetime, NULLIF(@RBRDate,''))
	UPDATE	rbr_date
	   SET	date_ar_generated = GETDATE()
	 WHERE	rbr_date = @dRBRDate













GO
