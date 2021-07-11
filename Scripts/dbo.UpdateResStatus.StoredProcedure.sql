USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateResStatus]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateResStatus    Script Date: 2/18/99 12:12:05 PM ******/
/****** Object:  Stored Procedure dbo.UpdateResStatus    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateResStatus    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateResStatus    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Reservation table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 28 - Moved data conversion code out of the where clause */ 

CREATE PROCEDURE [dbo].[UpdateResStatus]
	@ConfirmNum 	Varchar(10),
	@Status 	Varchar(1),
	@ChangedBy	varchar(20),
	@ChangedOn	varchar(24)
AS
	Declare	@nConfirmNum Integer
	Select		@nConfirmNum = Convert(Int, NULLIF(@ConfirmNum,""))

	UPDATE	Reservation
	SET	Status = NULLIF(@Status,""),
		last_changed_by = NULLIF(@ChangedBy, ''),
		last_changed_on = CONVERT(datetime, NULLIF(@ChangedOn, ''))

	WHERE	Confirmation_Number = @nConfirmNum

	RETURN @@ROWCOUNT















GO
