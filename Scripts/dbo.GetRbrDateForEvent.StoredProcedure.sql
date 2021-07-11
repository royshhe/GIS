USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRbrDateForEvent]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
PROCEDURE NAME: GetRbrDateForEvent
PURPOSE: To retrieve the RBR date that was current when an event occurred
AUTHOR: Don Kirkby
DATE CREATED: Apr 14, 1999
CALLED BY: Contract
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetRbrDateForEvent]
	@EventDate	varchar(24)
AS
	DECLARE	@dtEvent datetime
	SELECT	@dtEvent = CAST(@EventDate AS datetime)

	SELECT	rbr_date
	  FROM	rbr_date
	 WHERE	@dtEvent
		BETWEEN budget_start_datetime
		AND ISNULL(budget_close_datetime, @dtEvent)









GO
