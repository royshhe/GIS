USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateResForfeitDeposit]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateResForfeitDeposit    Script Date: 2/18/99 12:12:10 PM ******/
/****** Object:  Stored Procedure dbo.UpdateResForfeitDeposit    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateResForfeitDeposit    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateResForfeitDeposit    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Reservation_Dep_Payment table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 28 - Moved data conversion code out of the where clause */

CREATE PROCEDURE [dbo].[UpdateResForfeitDeposit]

	@ConfirmNum Varchar(10)
AS
	Declare	@nConfirmNum Integer

	Select		@nConfirmNum = Convert(Int, NULLIF(@ConfirmNum,""))

	UPDATE 	Reservation_Dep_Payment
	SET	Forfeited = 1

	WHERE	Confirmation_Number = @nConfirmNum
	AND	Amount >= 0
	AND	Forfeited = 0
	AND 	Refunded = 0

	RETURN @@ROWCOUNT














GO
