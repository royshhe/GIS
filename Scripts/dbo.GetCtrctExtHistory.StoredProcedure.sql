USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctExtHistory]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctExtHistory    Script Date: 2/18/99 12:12:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctExtHistory    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctExtHistory    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctExtHistory    Script Date: 11/23/98 3:55:33 PM ******/
/*
PURPOSE: 	To retrieve a list of drop off history for the given contract 
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctExtHistory]
	@CtrctNum	VarChar(10)
AS
	/* 2/20/99 - cpy modified - added placeholder */
	/* 10/22/99 - do nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = CONVERT(int, NULLIF(@CtrctNum, ''))

	SELECT	Distinct
		LOC.Location,
		CONVERT(VarChar, DOH.Drop_Off_On, 111),
		CONVERT(VarChar, DOH.Drop_Off_On, 108),
		DOH.Reason,
		DOH.Changed_By,
		DOH.Changed_On,
		''	-- added placeholder for OverrideTruckAvailCheck
				
	FROM	Drop_Off_History DOH,
		Location LOC
	WHERE	DOH.Contract_Number = @iCtrctNum
	AND	DOH.Drop_Off_Location = LOC.Location_ID
	ORDER BY
		DOH.Changed_On Desc
RETURN @@ROWCOUNT















GO
