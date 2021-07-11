USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctFreqFlyMemberLong]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.GetCtrctFreqFlyMemberLong    Script Date: 2/18/99 12:12:08 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChangeFreqFlyMember    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChangeFreqFlyMember    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChangeFreqFlyMember    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve a list of frequent flyer plans for the given contract 
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctFreqFlyMemberLong]
	@ContractNumber	varchar(10)
AS
	/* 10/22/99 - do nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = CONVERT(Int, NULLIF(@ContractNumber, ''))

	SELECT	FFP.Frequent_Flyer_Plan,
		Con.FF_Member_Number
	FROM	Contract Con,
		Frequent_Flyer_Plan FFP
	WHERE	CON.Contract_Number = @iCtrctNum
	AND	Con.Frequent_Flyer_Plan_ID = FFP.Frequent_Flyer_Plan_ID

	RETURN @@ROWCOUNT



GO
