USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetBracLocation]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetBracLocation    Script Date: 2/18/99 12:11:52 PM ******/
/****** Object:  Stored Procedure dbo.GetBracLocation    Script Date: 2/16/99 2:05:40 PM ******/
/*
PURPOSE: 	To retrieve a list of locations that belong to BudgetBC.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetBracLocation]
	@LocID VarChar(10)
AS
	/* return all locations that are rental locations */
	SELECT 	L.Location,
		L.Location_ID
	FROM	Location L WITH(NOLOCK)
	WHERE	L.Delete_Flag = 0
	AND	L.Owning_Company_ID IN 	(	SELECT	CONVERT(SmallInt, Code)
						FROM	Lookup_Table
						WHERE	Category = 'BudgetBC Company'
					)
	AND	L.Location_Id = CONVERT(SmallInt, NULLIF(@LocID, ''))
	ORDER BY L.Location
	RETURN @@ROWCOUNT














GO
