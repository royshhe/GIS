USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrintCopy]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctPrintCopy    Script Date: 2/18/99 12:11:45 PM ******/
/*  PURPOSE:		To retrieve the current print copy number.
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctPrintCopy]
	@ContractNum Varchar(10)
AS
	/* 2/17/99 - cpy - created
			 - return current print copy num */
	/* 10/18/99 - do type conversion and nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = Convert(Int, NULLIF(@ContractNum,''))

	SET ROWCOUNT 1

	SELECT	Contract_Number, Print_Seq, Printed_By, Printed_On
	FROM	Contract_Print WITH(NOLOCK)
	WHERE	Contract_Number = @iCtrctNum
	ORDER BY Print_Seq DESC

	RETURN @@ROWCOUNT
















GO
