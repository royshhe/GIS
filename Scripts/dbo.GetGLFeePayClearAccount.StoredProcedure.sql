USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetGLFeePayClearAccount]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetGLFeePayClearAccount    Script Date: 2/18/99 12:11:53 PM ******/
/****** Object:  Stored Procedure dbo.GetGLFeePayClearAccount    Script Date: 2/16/99 2:05:41 PM ******/
/*  PURPOSE:		To retrieve the GL_Fees_Payable_Clear_Account for the given location id.
     MOD HISTORY:
     Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[GetGLFeePayClearAccount]
	@LocationID	VarChar(10)
AS
Set Rowcount 1
SELECT
	GL_Fees_Payable_Clear_Account
FROM
	Location
WHERE
	Location_Id = Convert(smallint,@LocationID)
	And Delete_Flag = 0
RETURN 1













GO
