USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetUpsellRateLevel]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetUpsellRateLevel    Script Date: 2/18/99 12:12:10 PM ******/
/****** Object:  Stored Procedure dbo.GetUpsellRateLevel    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetUpsellRateLevel    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetUpsellRateLevel    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetUpsellRateLevel]
@LocID varchar(10),
@VehClassCode char(1),
@PickupDate varchar(30),
@LocVehRateType varchar(20)
AS
Set Rowcount 2000

Declare @UpsellClassName varchar(35)

Select @UpsellClassName =
	(Select
		VC2.Vehicle_Class_Name
	From
		Vehicle_Class VC, Vehicle_Class VC2
	Where
		VC.Vehicle_Class_Code = @VehClassCode
		And VC.Upgraded_Vehicle_Class_Code = VC2.Vehicle_Class_Code)

DECLARE @dPickupDate Datetime

SELECT @dPickupDate = Convert(datetime, NULLIF(@PickupDate,""))

Select	Distinct
	LVRL.Rate_ID,
	LVRL.Rate_Level,
	LVC.Vehicle_Class_Code,
	@UpsellClassName,
	VR.Rate_Name
From
	Location_Vehicle_Class LVC,
	Location_Vehicle_Rate_Level LVRL,
	Vehicle_Class VC,
	Vehicle_Rate VR
Where	
	VC.Vehicle_Class_Code = @VehClassCode
And	LVRL.Rate_ID = VR.Rate_ID
And 	LVC.Location_ID = Convert(smallint,@LocID)
And 	LVC.Vehicle_Class_Code = VC.Upgraded_Vehicle_Class_Code
And 	@dPickupDate BETWEEN LVC.Valid_From AND ISNULL(LVC.Valid_To,@dPickupDate)
And 	LVC.Location_Vehicle_Class_ID = LVRL.Location_Vehicle_Class_ID
And 	@dPickupDate BETWEEN LVRL.Valid_From AND ISNULL(LVRL.Valid_To,@dPickupDate)
And 	LVRL.Location_Vehicle_Rate_Type = @LocVehRateType
And 	LVRL.Rate_Selection_Type = 'Rack'

Return 1













GO
