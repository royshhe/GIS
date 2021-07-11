USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteResOptExtra]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DeleteResOptExtra    Script Date: 2/18/99 12:12:07 PM ******/
/****** Object:  Stored Procedure dbo.DeleteResOptExtra    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteResOptExtra    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.DeleteResOptExtra    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To delete record(s) from Reserved_Rental_Accessory table.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[DeleteResOptExtra]
	@ConfirmNum Varchar(20),
	@OldOptExtraId Varchar(5)
AS
	IF @ConfirmNum = ""
		SELECT @ConfirmNum = NULL
	IF @OldOptExtraId = ""
		SELECT @OldOptExtraId = NULL
	DELETE 	Reserved_Rental_Accessory
	WHERE	Confirmation_Number = Convert(Int, @ConfirmNum)
	AND	Optional_Extra_ID = Convert(SmallInt, @OldOptExtraId)
	RETURN @@ROWCOUNT













GO
