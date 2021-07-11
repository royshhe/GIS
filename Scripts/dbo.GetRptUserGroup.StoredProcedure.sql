USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptUserGroup]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.GetRptOperator    Script Date: 2/18/99 12:12:09 PM ******/
/****** Object:  Stored Procedure dbo.GetRptOperator    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRptOperator    Script Date: 1/11/99 1:03:17 PM ******/
/*
PROCEDURE NAME: GetRptOperator
PURPOSE: To retrieve a list of operators (users)
AUTHOR: Don Kirkby
DATE CREATED: Jan 5, 1999
CALLED BY: ReportParams
MOD HISTORY:
Name    Date        Comments
Don K	Jun 29 1999 Get names from business_transaction instead of
		reservation history. Add flags to include reservations,
		contracts, or sales contracts
Sli	Aug 17 2005 Add one more parameter for filtering terminated operators		
*/
CREATE PROCEDURE [dbo].[GetRptUserGroup] 
AS
	

	SELECT
      DISTINCT	Group_Name
--select *
FROM  dbo.GISUserGroup
WHERE (group_name IN ('Executive', 'QTA', 'Accounting', 'Operation Manager', 'Location Manager', 'Location CSR', 'Fleet Control', 'Reservation Manager', 
               'Reservation Agent', 'Claims', 'Mechanic', 'Rate', 'Payroll', 'Leadhand', 'Auditor', 'Auction', 'Rev Assistant', 'Fleet Accounting', 'IT Support Staff', 'Night Auditor', 
               'Foreign Control'))
GROUP BY Group_Name


















GO
