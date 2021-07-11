USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrevDOInfo]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctPrevDOInfo    Script Date: 2/18/99 12:12:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctPrevDOInfo    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctPrevDOInfo    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctPrevDOInfo    Script Date: 11/23/98 3:55:33 PM ******/
/*  PURPOSE:		To retrieve the lprevious drop off info for the given contract number
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctPrevDOInfo]
	@ContractNum Varchar(10)
AS
	/* 5/11/99 - cpy modified - specified cursor as Fast_foward; close cursor */
	/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */

DECLARE	@iDOLocId SmallInt
DECLARE	@dDODatetime Datetime
DECLARE	@nContractNum Integer

SELECT	@nContractNum = Convert(Int, NULLIF(@ContractNum,""))

DECLARE DOCur CURSOR FAST_FORWARD FOR
	SELECT	Drop_Off_Location, Drop_Off_On
	FROM	Drop_Off_History
	WHERE	Contract_Number = @nContractNum
	ORDER BY Changed_On DESC

	OPEN DOCur
	FETCH NEXT FROM DOCur INTO @iDOLocId, @dDODatetime
	/* get 2nd last record from DO history table */
	/* the last record is the currently saved DO info, so the
	   2nd last is the previous DO info */
	IF @@FETCH_STATUS = 0
	BEGIN
		FETCH NEXT FROM DOCur INTO @iDOLocId, @dDODatetime
	END
	CLOSE DOCur
	DEALLOCATE DOCur
	SELECT 	@iDOLocId,
		Convert(Char(11), @dDODatetime, 109),
		Convert(Char(5), @dDODatetime, 108)
	WHERE	@iDOLocId IS NOT NULL
	RETURN @@ROWCOUNT
















GO
