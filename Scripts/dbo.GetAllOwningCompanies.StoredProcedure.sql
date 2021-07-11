USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllOwningCompanies]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO













/****** Object:  Stored Procedure dbo.GetAllOwningCompanies    Script Date: 2/18/99 12:11:44 PM ******/
/****** Object:  Stored Procedure dbo.GetAllOwningCompanies    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetAllOwningCompanies    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetAllOwningCompanies    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve a list of active owning companies.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllOwningCompanies]
	@Except	VarChar(50) = NULL
AS
	Set Rowcount 2000

	if @Except="Budget BC"
	   begin
		select @Except=(select owning_company.name 
		from owning_company inner join
			lookup_table on owning_company.Owning_Company_ID=lookup_table.code
		where lookup_table.category='BudgetBC Company')
	    end

   	SELECT	Name,
		Owning_Company_ID
   	FROM   	Owning_Company
	WHERE	Delete_Flag = 0
	AND	Name <> ISNULL(@Except, '')
   	ORDER BY 	
		Name
   	RETURN 1














GO
