USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateResOptExtra]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













/****** Object:  Stored Procedure dbo.UpdateResOptExtra    Script Date: 2/18/99 12:12:11 PM ******/
/****** Object:  Stored Procedure dbo.UpdateResOptExtra    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateResOptExtra    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateResOptExtra    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Reserved_Rental_Accessory table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 28 - Moved data conversion code out of the where clause */

CREATE PROCEDURE [dbo].[UpdateResOptExtra]
	@ConfirmNum Varchar(20),
	@OldOptExtraId Varchar(5),
	@NewOptExtraId Varchar(5),
	@Qty	Varchar(5),
	@Coupon Varchar(25)='',
	@Description Varchar(25)='',
	@Flat_rate Varchar(12)=''
AS
	Declare	@nConfirmNum Integer
	Declare	@nOldOptExtraId SmallInt

	Select		@nConfirmNum = Convert(Int, NULLIF(@ConfirmNum, ''))
	Select		@nOldOptExtraId = Convert(SmallInt, NULLIF(@OldOptExtraId, ''))

	UPDATE 	Reserved_Rental_Accessory

	SET	Optional_Extra_ID = Convert(SmallInt, @NewOptExtraId),
		Quantity = Convert(SmallInt, @Qty),
		Coupon=nullif(@Coupon,''),
		Description=nullif(@Description,''),
		Flat_Rate=nullif(@Flat_rate,'')

	WHERE	Confirmation_Number = @nConfirmNum
	AND		Optional_Extra_ID = @nOldOptExtraId

	RETURN @@ROWCOUNT



set ANSI_NULLS on
GO
