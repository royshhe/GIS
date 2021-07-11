USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateCtrctResvnRevenue]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/*
PURPOSE: To update a record in Contract table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[UpdateCtrctResvnRevenue]
	@CtrctNum 	Varchar(10),
	@ResRevenue 	Varchar(10)
AS
	/* 6/28/99 - created - update the reservation revenue at contract check in */

	Declare	@nCtrctNum Integer
	Select		@nCtrctNum = Convert(Int, NULLIF(@CtrctNum,''))

	UPDATE	Contract
	SET	Reservation_Revenue = Convert(decimal(9,2), NULLIF(@ResRevenue,''))

	WHERE	Contract_Number = @nCtrctNum

	RETURN @@ROWCOUNT



GO
