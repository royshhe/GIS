USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateVehicleClassData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRateVehicleClassData    Script Date: 2/18/99 12:12:03 PM ******/
/****** Object:  Stored Procedure dbo.GetRateVehicleClassData    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRateVehicleClassData    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetRateVehicleClassData    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetRateVehicleClassData]
@RateID varchar(20),
@VehicleClassID varchar(20)
AS
Set Rowcount 2000
Select
	@VehicleClassID, VC.Vehicle_Class_Name, RVC.Per_Km_Charge
From
	Rate_Vehicle_Class RVC, Vehicle_Class VC
Where
	RVC.Rate_ID = Convert(int,@RateID)
	And RVC.Rate_Vehicle_Class_ID = Convert(int,@VehicleClassID)
	And RVC.Termination_Date = 'Dec 31 2078 11:59PM'
	And RVC.Vehicle_Class_Code = VC.Vehicle_Class_Code
Return 1












GO
