USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateResTurndown]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateResTurndown    Script Date: 2/18/99 12:11:42 PM ******/
/****** Object:  Stored Procedure dbo.CreateResTurndown    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateResTurndown    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateResTurndown    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Reservation_Turndown table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateResTurndown]
	@UserName 	Varchar(20),
	@CurrDatetime	Varchar(24),
	@TurndownId	Varchar(10),
	@TurndownDesc	Varchar(255)
AS
	INSERT INTO Reservation_Turndown
		(Created_By, Created_On,
		 Turndown_Reason_ID,
		 Description)
	VALUES
		(@UserName, Convert(Datetime, @CurrDatetime),
		 Convert(Int, @TurndownId),
		 @TurndownDesc)
	RETURN @@ROWCOUNT













GO
