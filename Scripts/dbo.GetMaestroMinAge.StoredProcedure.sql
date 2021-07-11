USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetMaestroMinAge]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
PURPOSE: 	To retrieve a list of override minimum age for vehicle class.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetMaestroMinAge]

AS
	SELECT 	OMAO.Vehicle_Class_Code, 
			OMAO.Minimum_Age

	FROM		LookUp_Table LT,
			Organization ORG,
			Organization_Min_Age_Override OMAO

	WHERE	LT.Category = 'Minimum Age Org'
	AND		LT.Code = ORG.BCD_Number
	AND		ORG.Organization_Id = OMAO.Organization_Id

	RETURN @@ROWCOUNT




GO
