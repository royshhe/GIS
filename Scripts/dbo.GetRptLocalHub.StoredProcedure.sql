USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptLocalHub]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
PURPOSE: To retrieve data from the lookup table.
MOD HISTORY:
Name	Date		Comment
Roy he	Jun 06 2003	Get a List of local hub
*/
CREATE PROCEDURE [dbo].[GetRptLocalHub]
AS

Declare @owningCompanyID smallint

Select @owningCompanyID=Convert(smallint,Code)	From Lookup_Table
Where	Category = 'BudgetBC Company'


SELECT distinct dbo.Lookup_Table.[Value],dbo.Lookup_Table.Code 
FROM         dbo.Location INNER JOIN
                      dbo.Lookup_Table ON dbo.Location.Hub_ID = dbo.Lookup_Table.Code
WHERE     (dbo.Lookup_Table.Category = 'hub') and dbo.Location.Owning_Company_ID=@owningCompanyID
Order By dbo.Lookup_Table.[Value]
Return 1




GO
