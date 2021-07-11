USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateConAddnlDriverTermDate]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateConAddnlDriverTermDate    Script Date: 2/18/99 12:12:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateConAddnlDriverTermDate    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdateConAddnlDriverTermDate    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdateConAddnlDriverTermDate    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in Contract_Additional_Driver table .
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[UpdateConAddnlDriverTermDate]
	@ContractNum 	Varchar(10),
	@AddDriverId	Varchar(10)
AS
	/* 10/18/99 - do type conversion and nullif outside of SQL statements */

DECLARE @dCurrDate Datetime, 
	@iCtrctNum Int, 
	@iAddDriverId Int

	SELECT 	@dCurrDate = GetDate(), 
		@iCtrctNum = Convert(Int, NULLIF(@ContractNum,'')),
		@iAddDriverId = Convert(Int, NULLIF(@AddDriverId,''))

	UPDATE	Contract_Additional_Driver
	SET	Termination_Date = @dCurrDate
	WHERE	Contract_Number = @iCtrctNum
	AND	Additional_Driver_Id = @iAddDriverId
	AND	Termination_Date >= '31 Dec 2078 23:59'
	RETURN @@ROWCOUNT















GO
