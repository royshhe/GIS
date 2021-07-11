USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLookupTableData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetLookupTableData] --'Owning Company'
@Category varchar(25), @Code varchar(25)   = ''-- NULL
AS
	/* 9/27/99 - do type conversion outside of select */
DECLARE @sCode Varchar(25)

SELECT @sCode = @Code + '%'

Set Rowcount 2000
If @Category<>'Owning Company'
	IF @Category<>'Province'
		Select Distinct
			Value,Code
		From
			Lookup_Table
		Where
			Category=@Category
			And Code Like @sCode
		Order By Value
	ELSE
		Select Distinct
			Value,Code
		From
			Lookup_Table
		Where
			Category=@Category
			And Code =@Code
		Order By Value
Else
		Select Distinct
			Value,Code
		From
			Lookup_Table
		Where
			Category=@Category
			And Code Like @sCode
        Union
			select Name Value,Convert(varchar(12), Owning_Company_ID) Code from owning_company
			where owning_company_ID =(select code from lookup_table where category='BudgetBC Company')

	
		Order By Value

Return 1


GO
