USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctChangeSTDComment]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctChangeSTDComment    Script Date: 2/18/99 12:12:08 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChangeSTDComment    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChangeSTDComment    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChangeSTDComment    Script Date: 11/23/98 3:55:33 PM ******/
/*
PURPOSE: 	To retrieve the reservarion comment for the given contract number.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctChangeSTDComment]
	@ContractNumber Varchar(10)
AS
	/* 10/22/99 - do nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = Convert(Int, NULLIF(@ContractNumber, ''))

	SELECT	RSC.Reservation_Comment
	FROM	Contract CON,
		Reservation_Comment RC,
		Reservation_Standard_Comment RSC
	WHERE 	CON.Contract_Number = @iCtrctNum
	AND	CON.Confirmation_Number = RC.Confirmation_Number
	AND	RC.Reservation_Comment_ID = RSC.Reservation_Comment_ID
	
	RETURN @@ROWCOUNT














GO
