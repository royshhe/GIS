USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetContractInfo]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO








/*
PURPOSE: retrieve misc. contract info for Vehicle Support screen.
MOD HISTORY:
Name	Date	    Comment
Don K	Aug 10 1999 Added Quoted_Vehicle_Rate table and selected
		Corporate_Responsibility
*/
CREATE PROCEDURE [dbo].[GetContractInfo]
	@ContractNum Varchar(11)
AS
	/* 10/22/99 - do nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = CONVERT(int, NULLIF(@ContractNum, ''))

	SELECT		ctrct.Customer_ID,
			ctrct.Do_Not_Extend_Reason,
			ctrct.Status,
			qrate.Corporate_Responsibility
	FROM		Contract ctrct
	LEFT
	JOIN		Quoted_Vehicle_Rate qrate
	  ON		qrate.quoted_rate_id = ctrct.quoted_rate_id
	WHERE	Contract_Number = @iCtrctNum
	RETURN @@ROWCOUNT

















GO
