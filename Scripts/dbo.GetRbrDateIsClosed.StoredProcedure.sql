USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRbrDateIsClosed]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*
PURPOSE: To check that an RBR date exists and is closed.
AUTHOR: Don Kirkby
DATE CREATED: Nov 8 1999
CALLED BY: Acctg export and Eigen import
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetRbrDateIsClosed]-- '06 may 2016'
	@RBRDate	varchar(24)
AS
	DECLARE	@dRBRDate AS datetime

	SELECT	@dRBRDate = CAST(NULLIF(@RBRDate, '') AS datetime)
	
		SELECT	CASE WHEN budget_close_datetime IS NULL THEN
				'Open'
			ELSE
				'Closed'
			END AS Status
		  FROM	rbr_date
		 WHERE	rbr_date = @dRBRDate





GO
