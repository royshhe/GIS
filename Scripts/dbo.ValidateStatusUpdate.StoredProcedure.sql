USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ValidateStatusUpdate]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.ValidateStatusUpdate    Script Date: 2/18/99 12:12:11 PM ******/
/****** Object:  Stored Procedure dbo.ValidateStatusUpdate    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.ValidateStatusUpdate    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.ValidateStatusUpdate    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To validate if the new status is one of 'Signed Off', .'Sold' or 'Written Off and if so the vehicle should not have a licence plate attached on
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[ValidateStatusUpdate]
@UnitNumber varchar(30),
@NewStatusCode char(1)
AS
Declare @thisStatusString varchar(30)
Declare @ret int
Declare @nUnitNumber Int

Select @ret = 0

SELECT	@nUnitNumber = CONVERT(int, NULLIF(@UnitNumber, ''))

Select @thisStatusString =
	(Select
		Value
	From
		Lookup_Table
	Where
		Category='Vehicle Status'
		And Code=@NewStatusCode)

If (@thisStatusString='Signed Off') Or (@thisStatusString='Sold') Or
	(@thisStatusString='Written Off')
	Begin
		Select @ret =
			(Select
				Count(*)
			From
				Vehicle
			Where
				Unit_Number=@nUnitNumber
				And Current_Licence_Plate<>'')
	End
Return @ret














GO
