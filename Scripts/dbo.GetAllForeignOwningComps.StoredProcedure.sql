USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllForeignOwningComps]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
PURPOSE: 	To retrieve a list of owning companies which are not belong to BudgetBC.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllForeignOwningComps]
AS
	/* 4/20/99 - cpy created - return all non-brac owning companies */
DECLARE @BracOwningCompId Int

	SELECT	@BracOwningCompId = Convert(Int, Code)
	FROM	Lookup_Table
	WHERE	Category = 'BudgetBC Company'

   	SELECT	Name,
		Owning_Company_ID
   	FROM   	Owning_Company
	WHERE	Delete_Flag = 0
	AND	Owning_Company_ID <> @BracOwningCompId
   	ORDER BY Name

   	RETURN 1












GO
