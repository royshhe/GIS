USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctCurrDOInfo]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctCurrDOInfo    Script Date: 2/18/99 12:12:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctCurrDOInfo    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctCurrDOInfo    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctCurrDOInfo    Script Date: 11/23/98 3:55:33 PM ******/
/*
PURPOSE: 	To retrieve a list of drop off information for the given contract number.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctCurrDOInfo]
	@ContractNum Varchar(10)
AS
	/* 10/22/99 - do nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = Convert(Int, NULLIF(@ContractNum,''))

	SET ROWCOUNT 1
	SELECT	Drop_Off_Location,
		Convert(Char(11), Drop_Off_On, 109),
		Convert(Char(5), Drop_Off_On, 108)
	FROM	Drop_Off_History
	WHERE	Contract_Number = @iCtrctNum
	ORDER BY Changed_On DESC

	RETURN @@ROWCOUNT














GO
