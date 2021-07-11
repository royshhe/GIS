USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehicleModelYearData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetVehicleModelYearData    Script Date: 2/18/99 12:12:10 PM ******/
/****** Object:  Stored Procedure dbo.GetVehicleModelYearData    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehicleModelYearData    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehicleModelYearData    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetVehicleModelYearData]
@Vehicle_Model_ID varchar(7)
AS
Set Rowcount 2000
Declare @ClassName varchar(255)
Declare @ClassCode char(1)
Declare @ICBCClassName varchar(255)
Declare @ICBCClassCode char(1)
Select @ClassCode = (Select Distinct Vehicle_Class_Code
			From Vehicle_Class_Vehicle_Model_Yr
			Where Vehicle_Model_ID=Convert(smallint,@Vehicle_Model_ID))
Select @ClassName = (Select Distinct Vehicle_Class_Name
			From Vehicle_Class
			Where Vehicle_Class_Code=@ClassCode)
Select @ICBCClassCode = (Select ICBC_Class
			From Vehicle_Model_Year
			Where Vehicle_Model_ID=Convert(smallint,@Vehicle_Model_ID))
Select @ICBCClassName = (Select Vehicle_Class_Name
			From Vehicle_Class
			Where Vehicle_Class_Code=@ICBCClassCode)
Select Distinct
	Convert(smallint,@Vehicle_Model_ID),Model_Name,
	Model_Year,@ClassName,@ICBCClassName,Manufacturer_ID,Km_Per_Litre,
	Fuel_Tank_Size,PST_Rate,Convert(char(1),Foreign_Model_Only),Convert(char(1),Diesel),Convert(char(1),Passenger_Vehicle),PM_Schedule_ID
--select *
From
	Vehicle_Model_Year
Where
	Vehicle_Model_ID=Convert(smallint,@Vehicle_Model_ID)
Return 1


GO
