USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptRatePurpose]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/*
PURPOSE: To get a list of rate purposes
AUTHOR: Don Kirkby
DATE CREATED: Nov 19 1999
CALLED BY: ReportParam
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetRptRatePurpose]
AS
	SELECT	rate_purpose,
		rate_purpose_id
	  FROM	rate_purpose
	 ORDER
	    BY	rate_purpose




GO
