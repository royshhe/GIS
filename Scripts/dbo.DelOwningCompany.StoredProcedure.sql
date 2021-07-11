USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DelOwningCompany]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
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

CREATE PROCEDURE [dbo].[DelOwningCompany]
	@OwningCompanyID	VarChar(10),
	@User			VarChar(20)
AS
   	UPDATE	Owning_Company
	SET	Delete_Flag 	= 1,
		Last_Update_By	= @User,
		Last_Update_On	= GetDate()
	WHERE	Owning_Company_ID = CONVERT(SmallInt, @OwningCompanyID)
   	RETURN 1













GO
