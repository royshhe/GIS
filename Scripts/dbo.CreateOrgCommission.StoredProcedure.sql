USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateOrgCommission]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO














/****** Object:  Stored Procedure dbo.CreateOrgCommission    Script Date: 2/18/99 12:11:50 PM ******/
/****** Object:  Stored Procedure dbo.CreateOrgCommission    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateOrgCommission    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateOrgCommission    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Commission_Rate table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateOrgCommission]
	@OrgId Varchar(10),
	@ValidFrom Varchar(11),
	@ValidTo Varchar(11),
	@FlatRate Varchar(11),
	@PerDay Varchar(11),
	@Percentage Varchar(7),
	@Remarks Varchar(255),
	@UserName varchar(20)
AS
DECLARE @dFlatRate Decimal(9,2)
DECLARE @dPerDay Decimal(9,2)
DECLARE @dPercentage Decimal(5,2)
	SELECT 	@dFlatRate = Convert(Decimal(9,2), NULLIF(@FlatRate,'')),
		@dPerDay = Convert(Decimal(9,2), NULLIF(@PerDay,'')),
		@dPercentage = Convert(Decimal(5,2), NULLIF(@Percentage,''))
	INSERT INTO Commission_Rate
		(Organization_ID, Valid_From,
		 Valid_To, Flat_Rate,
		 Per_Day, Percentage, Remarks)
	VALUES	(Convert(Int, @OrgId), Convert(Smalldatetime, @ValidFrom),
		 Convert(Smalldatetime, @ValidTo), @dFlatRate, @dPerDay,
		 @dPercentage, @Remarks)
/* Update Audit Info */
Update

	Organization
Set
	Last_Changed_By=@UserName,
	Last_Changed_On=getDate()
Where
	Organization_ID = Convert(int,@OrgID)
	RETURN 1

GO
