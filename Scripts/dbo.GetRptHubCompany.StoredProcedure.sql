USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptHubCompany]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRptHubCompany    Script Date: 2/18/99 12:11:56 PM ******/
/****** Object:  Stored Procedure dbo.GetRptHubCompany    Script Date: 2/16/99 2:05:42 PM ******/
/*
PROCEDURE NAME: GetRptHubCompany
PURPOSE: To retrieve a list of owning companies that have locations within
	a hub.
AUTHOR: Don Kirkby
DATE CREATED: Jan 15, 1999
CALLED BY: ReportParams
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetRptHubCompany]
	@HubId varchar(25)
AS
	SELECT	@HubId = NULLIF(@HubId, '')

	SELECT	name,
		owning_company_id
	  FROM	owning_company
	 WHERE	delete_flag = 0
	   AND	owning_company_id IN
		(
		SELECT	owning_company_id
		  FROM	location
		 WHERE	hub_id = @HubId
		   AND	delete_flag = 0
		)
	 ORDER
	    BY	name













GO
