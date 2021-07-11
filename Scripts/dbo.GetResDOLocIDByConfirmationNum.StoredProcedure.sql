USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResDOLocIDByConfirmationNum]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









CREATE PROCEDURE [dbo].[GetResDOLocIDByConfirmationNum]
	@ConfirmationNumber	VarChar(10)
AS
	/* 10/13/99 - do type conversion and nullif outside of SQL statements */
DECLARE	@iConfirmNum Int

	SELECT @iConfirmNum = Convert(Int, NULLIF(@ConfirmationNumber,''))

	SELECT	Drop_Off_Location_Id

	FROM		Reservation

	WHERE	Confirmation_Number = @iConfirmNum

RETURN 1











GO
