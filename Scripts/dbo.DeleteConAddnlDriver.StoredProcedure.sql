USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteConAddnlDriver]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/****** Object:  Stored Procedure dbo.DeleteConAddnlDriver    Script Date: 2/18/99 12:12:13 PM ******/
/****** Object:  Stored Procedure dbo.DeleteConAddnlDriver    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteConAddnlDriver    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.DeleteConAddnlDriver    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To delete record(s) from Contract_Additional_Driver table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[DeleteConAddnlDriver]
	@ContractNum Varchar(10),
	@AddDriverId Varchar(10)
AS
	/* 10/08/99 - do type conversion and nullif outside of select */

DECLARE @iCtrctNum Int,
	@iAddDriverId Int

	SELECT	@iCtrctNum = CONVERT(Int, NULLIF(@ContractNum,'')),
		@iAddDriverId = Convert(Int, NULLIF(@AddDriverId,""))

	/* delete all records related to this additional driver and contract */
	DELETE FROM Contract_Additional_Driver
	WHERE 	Contract_Number = @iCtrctNum
	AND	Additional_Driver_Id = @iAddDriverId
	RETURN @@ROWCOUNT














GO
