USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOrgCorpRate]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetOrgCorpRate    Script Date: 2/18/99 12:11:55 PM ******/
/****** Object:  Stored Procedure dbo.GetOrgCorpRate    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetOrgCorpRate    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetOrgCorpRate    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetOrgCorpRate]
	@OrgId Varchar(10)
AS
	/* return org corp rates that have not been terminated as of now */
	SELECT	B.Organization_Id, A.Rate_Id,
		A.Rate_Name,B.Rate_Level,
		B.Maestro_Rate,
		Convert(Varchar(20), B.Valid_From, 113),
		Convert(Varchar(20), B.Valid_To, 113),
		C.Rate_Purpose, A.Contract_Remarks,convert(Varchar,B.Effective_Date,20)
	FROM	Rate_Purpose C,
		Vehicle_Rate A,
		Organization_Rate B
	WHERE	A.Rate_Purpose_Id = C.Rate_Purpose_ID
	AND	A.Termination_Date = 'Dec 31 2078 11:59PM'
	AND	B.Rate_ID = A.Rate_ID
	AND	B.Organization_ID = Convert(Int, @OrgId)
	AND	B.Termination_Date = 'Dec 31 2078 11:59PM'
	ORDER BY  B.Valid_From, B.Valid_To,A.Rate_Name
	
	RETURN 1
GO
