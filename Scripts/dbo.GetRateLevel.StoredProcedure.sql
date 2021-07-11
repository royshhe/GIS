USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateLevel]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRateLevel    Script Date: 2/18/99 12:12:09 PM ******/
/****** Object:  Stored Procedure dbo.GetRateLevel    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRateLevel    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetRateLevel    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetRateLevel]
@BCDNum varchar(10),
@PickupLoc varchar(20),
@VehClassCode char(1),
@PickupDate varchar(20)
AS
Select Distinct
	B.Rate_ID, B.Rate_Level
From
	Organization A, Organization_Rate B
Where

	A.BCD_Number = @BCDNum
	And A.Organization_ID = B.Organization_ID
	And B.Termination_Date = 'Dec 31 2078 11:59PM'
	And B.Valid_From <= Convert(datetime, @PickupDate)
	And B.Valid_To >= Convert(datetime, @PickupDate)
Union
Select Distinct
	LVRL.Rate_ID,LVRL.Rate_Level
From
	Location_Vehicle_Class LVC, Location_Vehicle_Rate_Level LVRL,
	Vehicle_Class VC
Where	
	LVC.Location_ID = Convert(smallint,@PickupLoc)
        And (LVC.Vehicle_Class_Code = @VehClassCode Or LVRL.Rate_Selection_Type='Promotion')
        And LVC.Vehicle_Class_Code = VC.Vehicle_Class_Code
	And Convert(datetime, @PickupDate) BETWEEN LVC.Valid_From AND LVC.Valid_To
	And Convert(datetime, @PickupDate) BETWEEN LVRL.Valid_From AND LVRL.Valid_To
        And LVRL.Location_Vehicle_Rate_Type IN ('Same Day', 'Walk In', 'Future')
Return 1












GO
