USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptStaff]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
PROCEDURE NAME: GetRptStaff
PURPOSE: To retrieve a list of employee names
AUTHOR: Niem Phan
DATE CREATED: Aug 25, 1999
CALLED BY: ReportParams
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetRptStaff]
	@OrgId	varchar(25)
AS
	DECLARE	@nOrgId Integer
	SELECT	@nOrgId = CONVERT(Int, NULLIF(@OrgId, ''))

	Select	Last_Name + ', ' + First_Name Employee_Name

	From	Referring_Employee

	Where	Organization_Id = @nOrgId

	Order By
		Employee_Name









GO
