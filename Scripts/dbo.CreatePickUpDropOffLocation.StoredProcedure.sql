USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreatePickUpDropOffLocation]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.CreatePickUpDropOffLocation    Script Date: 2/18/99 12:12:00 PM ******/
/****** Object:  Stored Procedure dbo.CreatePickUpDropOffLocation    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreatePickUpDropOffLocation    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreatePickUpDropOffLocation    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Pick_Up_Drop_Off_Location table.
MOD HISTORY:
Name    Date        Comments
Don K	24 Mar 2000 Truncate @ValidFrom and @ValidTo to midnight
*/

CREATE PROCEDURE [dbo].[CreatePickUpDropOffLocation]
	@PickUpLocationID	VarChar(10),
	@DropOffLocationID	VarChar(10),
	@ValidFrom		VarChar(24),
	@ValidTo		VarChar(24),
	@Authorized		VarChar(1),
	@AuthorizedCharge	VarChar(10),
    @UnAuthorizedCharge	VarChar(10),
	@LocType            varchar(10)
AS
	Declare @NewID			SmallInt
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
		  INSERT INTO Pick_Up_Drop_Off_Location
		  (	Pick_Up_Location_ID,
			Drop_Off_Location_ID,
			Valid_From,
			Valid_To,
			Authorized,
			Authorized_Charge,
			UnAuthorized_Charge
		  )
		  VALUES
		  (	CONVERT(SmallInt, @PickUpLocationID),
			CONVERT(SmallInt, @DropOffLocationID),
			--Truncate @ValidFrom to midnight
			CAST(FLOOR(CAST(CAST(@ValidFrom AS datetime) AS float)) AS datetime),
			--Truncate @ValidTo to midnight
			CAST(FLOOR(CAST(CAST(@ValidTo AS datetime) AS float)) AS datetime),
			CONVERT(Bit, @Authorized),
			CONVERT(Decimal(7, 2), @AuthorizedCharge),
			CONVERT(Decimal(7, 2), @UnAuthorizedCharge)
		   )

	ELSE IF @LocType = 'Tour'
		INSERT INTO Tour_Drop_Off_Charge
		  (	Pick_Up_Location_ID,
			Drop_Off_Location_ID,
			Valid_From,
			Valid_To,
			Authorized,
			Authorized_Charge,
			UnAuthorized_Charge
		  )
		VALUES
		  (	CONVERT(SmallInt, @PickUpLocationID),
			CONVERT(SmallInt, @DropOffLocationID),
			--Truncate @ValidFrom to midnight
			CAST(FLOOR(CAST(CAST(@ValidFrom AS datetime) AS float)) AS datetime),
			--Truncate @ValidTo to midnight
			CAST(FLOOR(CAST(CAST(@ValidTo AS datetime) AS float)) AS datetime),
			CONVERT(Bit, @Authorized),
			CONVERT(Decimal(7, 2), @AuthorizedCharge),
			CONVERT(Decimal(7, 2), @UnAuthorizedCharge)
		  )

Select @NewID = @@IDENTITY
Return @NewID
GO
