USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdPickUpDropOffLocation]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.UpdPickUpDropOffLocation    Script Date: 2/18/99 12:12:05 PM ******/
/****** Object:  Stored Procedure dbo.UpdPickUpDropOffLocation    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdPickUpDropOffLocation    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdPickUpDropOffLocation    Script Date: 11/23/98 3:55:34 PM ******/
/*
PURPOSE: To update a record in Pick_Up_Drop_Off_Location table .
MOD HISTORY:
Name    Date        Comments
Don K	Mar 27 2000 Force @ValidFrom and @ValidTo to midnight
*/
/* Oct 26 - Moved data conversion out of the where clause */
CREATE PROCEDURE [dbo].[UpdPickUpDropOffLocation]
	@ID			Varchar(10),
	@PickUpLocationID	VarChar(10),
	@DropOffLocationID	VarChar(10),
	@ValidFrom		VarChar(24),
	@ValidTo		VarChar(24),
	@Authorized		VarChar(1),
	@AuthorizedCharge	VarChar(10),
    @UnAuthorizedCharge	VarChar(10),
	@LocType            varchar(10)
AS
	Declare @nID	SmallInt
	
	Select	@nID = CONVERT(SmallInt, NULLIF(@ID, ''))

	/*
	Set blank to Null for the values will be converted to numeric
	*/	
	If @ValidFrom = ''
		Select @ValidFrom = NULL
	If @ValidTo = ''
		Select @ValidTo = NULL
	If @AuthorizedCharge = ''
		Select @AuthorizedCharge = NULL
	If @UnAuthorizedCharge = ''
		Select @UnAuthorizedCharge = NULL
	
   IF @LocType = 'Regular'

	UPDATE	Pick_Up_Drop_Off_Location
	SET	Drop_Off_Location_ID	= CONVERT(SmallInt, @DropOffLocationID),
		Valid_From 		= CAST(FLOOR(CAST(CAST(@ValidFrom AS datetime) AS float)) AS datetime),
		Valid_To 		= CAST(FLOOR(CAST(CAST(@ValidTo AS datetime) AS float)) AS datetime),
		Authorized 			= CONVERT(Bit, @Authorized),
		Authorized_Charge 		= CONVERT(Decimal(7, 2), @AuthorizedCharge),
		UnAuthorized_Charge 	= CONVERT(Decimal(7, 2), @UnAuthorizedCharge)

	 WHERE	ID = @nID

   ELSE IF @LocType = 'Tour'

	 UPDATE	Tour_Drop_Off_Charge
	SET	Drop_Off_Location_ID	= CONVERT(SmallInt, @DropOffLocationID),
		Valid_From 		= CAST(FLOOR(CAST(CAST(@ValidFrom AS datetime) AS float)) AS datetime),
		Valid_To 		= CAST(FLOOR(CAST(CAST(@ValidTo AS datetime) AS float)) AS datetime),
		Authorized 			= CONVERT(Bit, @Authorized),
		Authorized_Charge 		= CONVERT(Decimal(7, 2), @AuthorizedCharge),
		UnAuthorized_Charge 	= CONVERT(Decimal(7, 2), @UnAuthorizedCharge)

	 WHERE	ID = @nID
    
Return 1
GO
