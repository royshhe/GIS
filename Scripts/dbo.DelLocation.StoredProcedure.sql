USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DelLocation]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DelLocation    Script Date: 2/18/99 12:11:51 PM ******/
/****** Object:  Stored Procedure dbo.DelLocation    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DelLocation    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.DelLocation    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To logical delete record(s) from Location table by setting the delete flag
MOD HISTORY:
Name    Date        	Comments
NP	Jan/11/2000	Add Last_Updated_By and Last_Updated_On
*/
CREATE PROCEDURE [dbo].[DelLocation]
	@LocationID		VarChar(10),
	@LastUpdatedBy	VarChar(20)
AS
	
   	UPDATE	Location
		
	Set		Delete_Flag	= 1,
			Last_Updated_By = @LastUpdatedBy,
			Last_Updated_On = GetDate()

	WHERE	Location_ID = CONVERT(SmallInt, @LocationID)

   	RETURN 1














GO
