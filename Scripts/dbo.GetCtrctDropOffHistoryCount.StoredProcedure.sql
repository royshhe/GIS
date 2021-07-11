USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctDropOffHistoryCount]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctDropOffHistoryCount    Script Date: 2/18/99 12:12:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctDropOffHistoryCount    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctDropOffHistoryCount    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctDropOffHistoryCount    Script Date: 11/23/98 3:55:33 PM ******/
/*
PURPOSE: 	To retrieve the count of number of vehicle drop off  for the given contract 
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctDropOffHistoryCount]
	@CtrctNum	varchar(10)
AS
	/* 10/22/99 - do nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = CONVERT(Int, NULLIF(@CtrctNum, ''))

	SELECT	Count(*)
	FROM		Drop_Off_History
	WHERE	Contract_Number = @iCtrctNum
	RETURN @@ROWCOUNT














GO
