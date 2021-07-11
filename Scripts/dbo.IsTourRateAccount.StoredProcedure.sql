USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[IsTourRateAccount]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
PURPOSE: To check if the given  Org is Tour Rate Account. If so return 1and 0 otherwise.
MOD HISTORY:
Name    Date        Comments
Roy He	 2008-06-06
*/

CREATE PROCEDURE [dbo].[IsTourRateAccount]
	@BCDNumber  VarChar(12)
AS


	Declare @ret int


	SELECT     Tour_Rate_Account
	FROM         dbo.Organization
	where BCD_Number=@BCDNumber and Tour_Rate_Account=1 And	 inactive=0 


	If @@ROWCOUNT = 0
		Select @ret = 0
	Else
		Select @ret = 1

	RETURN @ret














GO
