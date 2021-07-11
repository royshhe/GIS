USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocationListByOwningCompany]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.GetLocationListByOwningCompany    Script Date: 2/18/99 12:11:52 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationListByOwningCompany    Script Date: 2/16/99 2:05:40 PM ******/
/*
PURPOSE: 	To retrieve a list of locations that belong to BudgetBC.
MOD HISTORY:
Name    Date        Comments
Roy     2002-02-14
*/
CREATE PROCEDURE [dbo].[GetLocationListByOwningCompany]
@OwingCompany int	
AS
	/* return all locations that are rental locations */
          
	SELECT 	L.Location, L.Location_ID
	FROM	Location L, Lookup_table
	WHERE L.Delete_Flag = 0  
	AND	L.Owning_Company_ID =Lookup_table.Code And  Lookup_table.Category='BudgetBC Company'
	ORDER BY L.Location
	RETURN @@ROWCOUNT







GO
