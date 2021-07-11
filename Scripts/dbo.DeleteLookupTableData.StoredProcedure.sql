USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteLookupTableData]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.DelOwningCompany    Script Date: 2/18/99 12:11:42 PM ******/
/****** Object:  Stored Procedure dbo.DelOwningCompany    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DelOwningCompany    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.DelOwningCompany    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To logical delete record(s) from Owning_Company table by setting the delete flag.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[DeleteLookupTableData]
	@Category	VarChar(30),
	@Code char(25)
AS
if @Category='Reservation Standard Comment'
	Begin
   		DELETE	FROM Reservation_Standard_Comment
		WHERE	Reservation_Comment_ID = @Code
	End
else
	Begin
   		DELETE	FROM Lookup_Table
		WHERE	Category = @Category
		AND Code = @Code
	End
   	RETURN 1
GO
