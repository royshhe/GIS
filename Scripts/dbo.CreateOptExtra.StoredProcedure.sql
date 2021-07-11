USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateOptExtra]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
CREATE PROCEDURE [dbo].[CreateOptExtra]
	@OptionalExtra		VarChar(35),
	@Type			VarChar(20),
	@MaximumQuantity	VarChar(10),
	@UnitRequired char(1),
	@LastUpdatedBy	VarChar(20)
AS
	
Declare @OptionalExtraID smallint

	INSERT INTO Optional_Extra
		(
		Optional_Extra,
		Maximum_Quantity,
		Type,
		Unit_Required,
		Last_Updated_By,
		Last_Updated_On
		)
	VALUES
		(
		@OptionalExtra,
		CONVERT(SmallInt, @MaximumQuantity),
		@Type,
		convert(bit,@UnitRequired),
		@LastUpdatedBy,
		GetDate()
		)

         select @OptionalExtraID=@@IDENTITY

         Insert Into Optional_Extra_Restriction SELECT  Vehicle_Class_Code,@OptionalExtraID FROM dbo.Vehicle_Class

RETURN @OptionalExtraID
 


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
