USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehMoveVehicleInfoData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetVehMoveVehicleInfoData    Script Date: 2/18/99 12:12:10 PM ******/
/****** Object:  Stored Procedure dbo.GetVehMoveVehicleInfoData    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehMoveVehicleInfoData    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehMoveVehicleInfoData    Script Date: 11/23/98 3:55:34 PM ******/
-- MS SQL SERVER UPGRADE ROY HE 2011-03-25
CREATE PROCEDURE [dbo].[GetVehMoveVehicleInfoData] --168998
@UnitNumber varchar(10)
AS
Select
	Model_Name,
	Model_Year,
	LT.Value,
	Current_Licence_Plate,
	Exterior_Colour,
	OC.Name,
	Convert(Char(1), VMY.Diesel)
From 	Vehicle V
LEFT JOIN 	Lookup_Table LT 	
ON  LT.Code=V.Current_Vehicle_Status And LT.Category='Vehicle Status'
LEFT JOIN 	Vehicle_Model_Year VMY
ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID
LEFT JOIN 	Owning_Company OC
ON  V.Owning_Company_Id = OC.Owning_Company_Id
Where
	V.Unit_Number = Convert(int,@UnitNumber)

--	And V.Owning_Company_Id *= OC.Owning_Company_Id
--	And V.Vehicle_Model_ID *= VMY.Vehicle_Model_ID--
--	And LT.Category='Vehicle Status'
--	And LT.Code=V.Current_Vehicle_Status
	
RETURN 1
GO
