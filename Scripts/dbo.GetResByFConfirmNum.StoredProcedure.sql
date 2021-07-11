USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResByFConfirmNum]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetResByFConfirmNum    Script Date: 2/18/99 12:12:03 PM ******/
/****** Object:  Stored Procedure dbo.GetResByFConfirmNum    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResByFConfirmNum    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResByFConfirmNum    Script Date: 11/23/98 3:55:34 PM ******/
/*
PROCEDURE NAME: GetResByFConfirmNum
PURPOSE: To retrieve a reservation
AUTHOR: Don Kirkby
DATE CREATED: Sep 30, 1998
CALLED BY: MaestroBatch
REQUIRES: foreign confirmation number
ENSURES: the record is returned.
MOD HISTORY:
Name    Date        Comments
CPY     Jan 12 99   Renamed phone number columns
*/
CREATE PROCEDURE [dbo].[GetResByFConfirmNum]
	@FConfirmNum Varchar(20)
AS
	/* 981029 - cpy - removed Rate_Selection_Date from Reservation,
			  but return "" after Rate_Id as a placeholder */
	/* 9/30/99 - do nullif outside of select */
	SELECT  @FConfirmNum = NULLIF(@FConfirmNum, '')

	SELECT	Confirmation_Number,status,Special_Comments  		
	FROM	Reservation
	WHERE Confirmation_Number=(SELECT	max(Confirmation_Number) FROM Reservation
	WHERE Foreign_Confirm_Number = @FConfirmNum)

RETURN @@ROWCOUNT
GO
