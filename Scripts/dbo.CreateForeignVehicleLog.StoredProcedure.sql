USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateForeignVehicleLog]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/****** Object:  Stored Procedure dbo.CreateForeignVehicleLog    Script Date: 2/18/99 12:11:42 PM ******/
/****** Object:  Stored Procedure dbo.CreateForeignVehicleLog    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateForeignVehicleLog    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateForeignVehicleLog    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Owning_Company table.
MOD HISTORY:
Name    Date        Comments
*/

 
	

CREATE PROCEDURE [dbo].[CreateForeignVehicleLog]
   	@UserID			VarChar(20),
	@UnitNumber		VarChar(20),
	@LicensePlate	VarChar(50),
	@Model			VarChar(30),
	@OwningCompany	VarChar(50),
	@TimeIn			VarChar(24),
	@KMIn			Varchar(10),
	@LocationIn     VarChar(25),
	@TankLevel		Char(6),
	@Condition		VarChar(30)
	 
AS
	 
	
	Declare @UserName char(50)
	
	SELECT 	@UserID = NULLIF(@UserID, ''),
		@UnitNumber	= NULLIF(@UnitNumber, ''),
		@LicensePlate = NULLIF(@LicensePlate, ''),
		@Model = NULLIF(@Model, ''),
		@OwningCompany 	= NULLIF(@OwningCompany, ''),
		@TimeIn = NULLIF(@TimeIn, ''),
		@KMIn = NULLIF(@KMIn, ''),
		@LocationIn 	= NULLIF(@LocationIn, ''),
		@TankLevel 	= NULLIF(@TankLevel, ''),
		@Condition 	=  NULLIF(@Condition, '') 
		 
	
	Select @UserName=user_name from dbo.GISUsers where user_id=@UserID
	
 
	INSERT INTO Foreign_Vehicle_CI_Log

	(	Foreign_Unit_Number,
		Licence_Plate,
		Model,
		Owning_Company,
		Time_In,
		KM_In,
		Location_IN,
		Tank_Level,
		Condition_Status,
		User_Name,
		Last_Updated_On
		 
	)
	VALUES
	(
	@UnitNumber,
	@LicensePlate,
	@Model,
	@OwningCompany,
	Convert(Datetime,@TimeIn),
	Convert(Int,@KMIn),
	@LocationIn,
	@TankLevel,	
	@Condition,
	@UserName,
	Getdate()
	)




GO
