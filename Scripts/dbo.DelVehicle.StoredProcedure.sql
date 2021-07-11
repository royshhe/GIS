USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DelVehicle]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.DelVehicle    Script Date: 2/18/99 12:12:07 PM ******/
/****** Object:  Stored Procedure dbo.DelVehicle    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DelVehicle    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.DelVehicle    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To logical delete record(s) from Vehicle table by setting the delete flag.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[DelVehicle]
	@UnitNumber	VarChar(10),
	@LastUpdateBy	VarChar(20)
AS
	UPDATE	Vehicle
	
	SET	Deleted 	= CONVERT(Bit, 1),
		Deleted_On 	= GetDate(),
		Last_Update_By	= @LastUpdateBy,
		Last_Update_On	= GetDate()
	
	WHERE	Unit_Number = CONVERT(Int, @UnitNumber)
RETURN 1













GO
