USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehOwningCompanies]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO














/****** Object:  Stored Procedure dbo.GetVehOwningCompanies    Script Date: 2/18/99 12:11:44 PM ******/
/****** Object:  Stored Procedure dbo.GetVehOwningCompanies    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetVehOwningCompanies    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetVehOwningCompanies    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve a list of active owning companies.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetVehOwningCompanies]
	
AS
	Set Rowcount 2000

	
   	SELECT Owning_Company_ID,	right(Name, len(name)-2) 
		
   	FROM   	Owning_Company
	WHERE	Delete_Flag = 0 and Owning_Company_ID in (  7376, 7437, 7293, 7440, 8410, 8673, 3333, 2222)
	 
   	ORDER BY 	
		(Case 
		When Owning_Company_ID=7376 Then 1
		When Owning_Company_ID=8410 Then 2
		When Owning_Company_ID=7440 Then 3
		When Owning_Company_ID=7437 Then 4
		When Owning_Company_ID=7293 Then 5
		When Owning_Company_ID=2222 Then 6
		When Owning_Company_ID=3333 Then 7
		When Owning_Company_ID=8673 Then 8
		End)
		
   	RETURN 1















GO
