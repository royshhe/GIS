USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DelOptExtra]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DelOptExtra    Script Date: 2/18/99 12:11:42 PM ******/
/****** Object:  Stored Procedure dbo.DelOptExtra    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DelOptExtra    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.DelOptExtra    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To logical delete record(s) from Optional_Extra table by setting the delete flag.
MOD HISTORY:
Name    Date        	Comments
NP	Jan/12/2000 	Add audit info
*/

CREATE PROCEDURE [dbo].[DelOptExtra]
	@OptionalExtraID	VarChar(10),
	@LastUpdatedBy	VarChar(20)
AS
	
   	UPDATE	Optional_Extra
		
	Set	Delete_Flag	= 1,
		Last_Updated_By = @LastUpdatedBy,
		Last_Updated_On = GetDate()

	WHERE	Optional_Extra_ID = CONVERT(SmallInt, @OptionalExtraID)

   	RETURN 1














GO
