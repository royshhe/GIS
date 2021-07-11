USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctChangeAddDriverHist]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctChangeAddDriverHist    Script Date: 2/18/99 12:12:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChangeAddDriverHist    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChangeAddDriverHist    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChangeAddDriverHist    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve the additional driver information for the given parameters.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctChangeAddDriverHist]
	@ContractNum Varchar(10),
	@AddDriverId Varchar(10)
AS
	/* 3/30/99 - cpy bug fix - format dates returned */
	/* 10/18/99 - do type conversion and nullif outside of SQL statements */

DECLARE	@iCtrctNum Int,
	@iAddDriverId Int

	SELECT 	@iCtrctNum = Convert(Int, NULLIF(@ContractNum,'')),
		@iAddDriverId = Convert(Int, NULLIF(@AddDriverId,''))

	SELECT	Convert(Varchar(17), Valid_From, 13),
		Convert(Varchar(17), Valid_To, 13),
		Last_Changed_By,
		Convert(Varchar(20), Effective_Date, 13)
	FROM	Contract_Additional_Driver
	WHERE	Contract_Number = @iCtrctNum
	AND	Additional_Driver_Id = @iAddDriverId
	AND	Termination_Date < '31 Dec 2078'
	ORDER BY Last_Changed_By DESC

	RETURN @@ROWCOUNT















GO
