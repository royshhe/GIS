USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehMoveVehicleData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetVehMoveVehicleData    Script Date: 2/18/99 12:12:10 PM ******/
/****** Object:  Stored Procedure dbo.GetVehMoveVehicleData    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehMoveVehicleData    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehMoveVehicleData    Script Date: 11/23/98 3:55:34 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetVehMoveVehicleData] --168998
@UnitNumber varchar(10)
AS
	/* 3/24/99 - cpy modified - added Next_Scheduled_Maintenance and Vehicle_Type_ID */

Declare	@nUnitNumber Integer
Select		@nUnitNumber = Convert(int, NULLIF(@UnitNumber,''))

Select
	Do_Not_Rent_Past_Km,
	Current_Km,
	Do_Not_Rent_Past_Days,
	Ownership_Date,
	Value,
	Location,
	Convert(char(1), Program),
	VC.Vehicle_Type_Id,
	Next_Scheduled_Maintenance
From
	Vehicle V 
INNER JOIN	Location L
	ON V.Current_Location_ID = L.Location_ID
LEFT JOIN	Vehicle_Class VC
	ON V.Vehicle_Class_Code = VC.Vehicle_Class_Code
LEFT JOIN	Lookup_Table LT
	ON  V.Current_Condition_Status= LT.Code  And LT.Category = 'Vehicle Condition Status'
Where
	V.Unit_Number = @nUnitNumber
--	And V.Vehicle_Class_Code *= VC.Vehicle_Class_Code
--	And V.Current_Location_ID = L.Location_ID
--	And LT.Category = 'Vehicle Condition Status'
--	And LT.Code =* V.Current_Condition_Status
--	
RETURN 1
GO
