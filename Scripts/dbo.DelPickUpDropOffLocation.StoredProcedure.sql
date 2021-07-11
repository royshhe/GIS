USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DelPickUpDropOffLocation]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.DelPickUpDropOffLocation    Script Date: 2/18/99 12:12:01 PM ******/
/****** Object:  Stored Procedure dbo.DelPickUpDropOffLocation    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DelPickUpDropOffLocation    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.DelPickUpDropOffLocation    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To delete record(s) from Pick_Up_Drop_Off_Location table.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[DelPickUpDropOffLocation]
	@ID	VarChar(10),
	@LocType varchar(10)
AS
	
	IF @LocType = 'Regular'

   		Delete	Pick_Up_Drop_Off_Location
		WHERE	ID = CONVERT(SmallInt, @ID)

    ELSE IF @LocType = 'Tour'

		Delete	Tour_Drop_Off_Charge
		WHERE	ID = CONVERT(SmallInt, @ID)

RETURN 1
GO
