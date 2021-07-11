USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptOrganization]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
PROCEDURE NAME: GetRptOrganization
PURPOSE: To retrieve a list of Organization name and id
AUTHOR: Niem Phan
DATE CREATED: Aug 25, 1999
CALLED BY: ReportParams
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetRptOrganization]
	@OrgTypeId	varchar(25),
	@StartDate	varchar(25),
	@EndDate	varchar(25)
AS
Declare	@dStartDate	DateTime,
	@dEndDate	DateTime

	Select	@dStartDate = Convert(DateTime, NULLIF(@StartDate, ''))
	Select	@dEndDate = Convert(DateTime, NULLIF(@EndDate, ''))
	Select	@OrgTypeId = NULLIF(@OrgTypeId, '')

	Select	Distinct
		Org.Organization,
		Org.Organization_id

	From	Organization Org,
		Commission_Rate CR

	Where	Org_Type = @OrgTypeId
	And	Org.Organization_Id = CR.Organization_Id

	And	(	CR.Valid_From Between @dStartDate And @dEndDate
		Or	CR.Valid_To Between @dStartDate And @dEndDate
		Or	(CR.Valid_From <= @dStartDate And ISNULL(CR.Valid_To, Convert(DateTime, 'Dec 31 2078')) >= @dEndDate)
		)
	Order By
		Org.Organization











GO
