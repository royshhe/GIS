USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOrgCommission]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO














/****** Object:  Stored Procedure dbo.GetOrgCommission    Script Date: 2/18/99 12:11:55 PM ******/
/****** Object:  Stored Procedure dbo.GetOrgCommission    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetOrgCommission    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetOrgCommission    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetOrgCommission]
	@OrgId Varchar(10)
AS
	SELECT	Commission_Rate_ID,
		Convert(Varchar(20), Valid_From, 113),
		Convert(Varchar(20), Valid_To, 113),
		Flat_Rate, Per_day, Percentage, Remarks
	FROM 	Commission_Rate
	WHERE	Organization_ID = Convert(Int, @OrgId)
	ORDER BY Valid_From, Valid_To
	
	RETURN 1

GO
