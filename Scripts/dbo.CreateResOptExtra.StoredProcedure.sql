USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateResOptExtra]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.CreateResOptExtra    Script Date: 2/18/99 12:12:06 PM ******/
/****** Object:  Stored Procedure dbo.CreateResOptExtra    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateResOptExtra    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateResOptExtra    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Reserved_Rental_Accessory table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateResOptExtra]
	@ConfirmNum Varchar(20),
	@OptExtraId Varchar(5),
	@Qty	Varchar(5),
	@Coupon Varchar(25)='',
	@Description varchar(25)='',
	@Flat_rate Varchar(12)=''
AS
DECLARE @iConfirmNum Int
DECLARE @iOptExtraId SmallInt
	IF LTRIM(@ConfirmNum) <> ''
		SELECT @iConfirmNum = Convert(Int, @ConfirmNum)
	IF LTRIM(@OptExtraId) <> ''
		SELECT @iOptExtraId = Convert(SmallInt, @OptExtraId)
	INSERT INTO Reserved_Rental_Accessory
		(Confirmation_Number, Optional_Extra_ID, Quantity,Coupon,Description,Flat_rate)
	VALUES	(@iConfirmNum,
		 @iOptExtraId,
		 Convert(SmallInt, @Qty),
		 nullif(@Coupon, ''),
		 nullif(@Description,''),
		 nullif(@Flat_rate, '')	
			)
	RETURN @@ROWCOUNT
GO
