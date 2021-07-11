USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehicleClassData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetVehicleClassData    Script Date: 2/18/99 12:11:57 PM ******/
/****** Object:  Stored Procedure dbo.GetVehicleClassData    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehicleClassData    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehicleClassData    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetVehicleClassData]
@ClassCode Varchar(35)
AS
Set Rowcount 2000
Select
	VC.Vehicle_Class_Code, VC.Vehicle_Type_ID, VC.Vehicle_Class_Name,
	VC2.Vehicle_Class_Name, VC.Deposit_Amount, VC.Minimum_Cancellation_Notice,
	VC.Minimum_Age, Convert(char(1),VC.Cash_Rental_Allowed),
	Convert(char(1),VC.US_Border_Crossing_Allowed),
	Convert(char(1),VC.Local_Rental_Only),
	vc.included_fpo_amount,
	vc.FA_Vehicle_Type_ID,
	vc.Maestro_Code,
	vc.SIPP,
	vc.DisplayOrder,
	vc.Alias,
	vc.Acctg_Segment,
	vc.Default_Optional_Extra_ID,
	vc.Description
From
	Vehicle_Class VC 
LEFT JOIN  Vehicle_Class VC2
ON VC.Upgraded_Vehicle_Class_Code = VC2.Vehicle_Class_Code
Where
	VC.Vehicle_Class_Code = @ClassCode
--	And VC.Upgraded_Vehicle_Class_Code *= VC2.Vehicle_Class_Code
Order By
	VC.Vehicle_Class_Name
Return 1



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
