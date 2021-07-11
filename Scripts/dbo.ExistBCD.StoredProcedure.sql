USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ExistBCD]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.ExistBCD    Script Date: 2/18/99 12:11:43 PM ******/
/****** Object:  Stored Procedure dbo.ExistBCD    Script Date: 2/16/99 2:05:40 PM ******/
/*
PURPOSE: To retrieve BCD Number for other organization.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[ExistBCD]
	@BCDNumber Varchar(35),
	@OrgID Varchar(35)
AS
	/* 5/12/99 - cpy bug fix - apply nullif check to @BCDNumber and @OrgId
				- insert default value if @OrgId is null */
	/* 10/10/99 - do type conversion and nullif outside of sql statement */
DECLARE @iOrgId Int

	SELECT	@iOrgId = ISNULL(Convert(int, NULLIF(@OrgID, '')), '-1'),
		@BCDNumber = NULLIF(@BCDNumber,'')

Select
	BCD_Number
From
	Organization
Where
	BCD_Number = @BCDNumber
	And Organization_ID <> @iOrgId

Return 1
















GO
