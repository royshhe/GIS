USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetActiveReservation]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.GetActiveReservation    Script Date: 2/18/99 12:12:01 PM ******/
/****** Object:  Stored Procedure dbo.GetActiveReservation    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetActiveReservation    Script Date: 1/11/99 1:03:15 PM ******/
/*
PURPOSE: 	To retrieve all active reservations with pickup date which has passed by NoShowTimeLimit.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetActiveReservation]
	@NoShowTimeLimit Varchar(11)
AS
	Set RowCount 2000

	DECLARE @Hour Integer
	SELECT @Hour = CONVERT(Int, NULLIF(@NoShowTimeLimit, ''))
	SELECT	
		Confirmation_Number,
		Vehicle_Class_Code,
		Pick_Up_On,
		Status,
		Guarantee_Deposit_Amount,
		CONVERT(Varchar(1), Deposit_Waived) Deposit_Waived,
		CONVERT(Varchar(1), Maestro_Guarantee) Maestro_Guarantee,
		Guarantee_Credit_Card_Key,
		CONVERT(VarChar(1), Swiped_Flag) Swiped_Flag
	FROM	Reservation
	WHERE	Status = 'a'
	AND	DATEADD(Hour, @Hour, Pick_Up_On) < Getdate()
	
	RETURN @@ROWCOUNT

GO
