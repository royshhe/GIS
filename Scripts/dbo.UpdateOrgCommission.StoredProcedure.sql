USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateOrgCommission]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO














/****** Object:  Stored Procedure dbo.UpdateOrgCommission    Script Date: 2/18/99 12:11:58 PM ******/
/****** Object:  Stored Procedure dbo.UpdateOrgCommission    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateOrgCommission    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdateOrgCommission    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Commission_Rate table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 28 - Moved data conversion code out of the where clause */

CREATE PROCEDURE [dbo].[UpdateOrgCommission]
	@OrgId Varchar(10),
	@CommRateId Varchar(10),
	@ValidFrom Varchar(11),
	@ValidTo Varchar(11),
	@FlatRate Varchar(11),
	@PerDay Varchar(11),
	@Percentage Varchar(7),
	@Remarks Varchar(255),
	@UserName varchar(20)
AS

	DECLARE 	@dFlatRate Decimal(9,2)
	DECLARE	@dPerDay Decimal(9,2)
	DECLARE 	@dPercentage Decimal(5,2)
	Declare	@nOrgId Integer
	Declare	@nCommRateId Integer

	Select		@nOrgId = Convert(Int, NULLIF(@OrgId, ''))
	Select		@nCommRateId = Convert(Int, NULLIF(@CommRateId, ''))

	SELECT 	@dFlatRate = Convert(Decimal(9,2), NULLIF(@FlatRate,'')),
		@dPerDay = Convert(Decimal(9,2), NULLIF(@PerDay,'')),
		@dPercentage = Convert(Decimal(5,2), NULLIF(@Percentage,''))

	UPDATE 	Commission_Rate
	SET	Valid_From = Convert(Smalldatetime, @ValidFrom),
		Valid_To = Convert(Smalldatetime, @ValidTo),
 		Flat_Rate = @dFlatRate,
		Per_day = @dPerDay,
		Percentage = @dPercentage,
		Remarks = @Remarks
	WHERE	Organization_ID = @nOrgId
	AND	Commission_Rate_ID = @nCommRateId

/* Update Audit Info */
Update
	Organization
Set
	Last_Changed_By=@UserName,
	Last_Changed_On=getDate()
Where
	Organization_ID = @nOrgId
RETURN 1

GO
