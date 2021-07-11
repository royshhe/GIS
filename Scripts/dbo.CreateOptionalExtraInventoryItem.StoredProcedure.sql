USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateOptionalExtraInventoryItem]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CreateOptExtra    Script Date: 2/18/99 12:11:41 PM ******/
/****** Object:  Stored Procedure dbo.CreateOptExtra    Script Date: 2/16/99 2:05:39 PM ******/
/*
PROCEDURE NAME: CreateOptExtra
PURPOSE: To create a record in the Optional_Extra table
AUTHOR: ?
DATE CREATED: ?
CALLED BY: OptExtra
MOD HISTORY:
Name    Date        	Comments
Don K	Feb 8 1999 	Expanded @OptionalExtra to 35
NP	Jan/12/2000 	Add audit info
*/
create PROCEDURE [dbo].[CreateOptionalExtraInventoryItem]
	@Unit_Number varchar(12),
	@Serial_Number varchar(12),
	@OwningLocation	varchar(5),
	@OptExtraType varchar(20)
AS
	

	INSERT INTO Optional_Extra_Inventory
		(
		Unit_Number, 
		Serial_Number, 
		Owning_Location, 
		Optional_Extra_Type, 
		Deleted_Flag
		)
	VALUES
		(
		@Unit_Number,
		@Serial_Number,
		@OwningLocation,
		@OptExtraType,
		0
		)
GO
