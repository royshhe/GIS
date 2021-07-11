USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetContractCurrency]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetContractCurrency    Script Date: 2/18/99 12:12:07 PM ******/
/****** Object:  Stored Procedure dbo.GetContractCurrency    Script Date: 2/16/99 2:05:40 PM ******/
/*
PURPOSE: 	To retrieve the currency id for the given contract.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetContractCurrency]
	@ContractNum Varchar(11)
AS	
	/* 10/21/99 - do type conversion and nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = CONVERT(int, NULLIF(@ContractNum,''))

SELECT
	Contract_Currency_ID
FROM
	Contract WITH(NOLOCK)
WHERE
	Contract_Number = @iCtrctNum
RETURN @@ROWCOUNT














GO
