USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetConLocVehAvail]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetConLocVehAvail    Script Date: 2/18/99 12:12:14 PM ******/
/****** Object:  Stored Procedure dbo.GetConLocVehAvail    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetConLocVehAvail    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetConLocVehAvail    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve the vehicle availability for the given location id and vehicle type.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[GetConLocVehAvail]
	@LocationID	Varchar(10),
	@VehicleType	VarChar(18)
AS
	SELECT	VC.Vehicle_Class_Name,
		V.Unit_Number,
		VMY.Model_Name,
		V.Exterior_Colour,
		'Inactive_Day' =
			Case
				When	VOC.Actual_Check_In >= VM.Movement_In Then
					DateDiff(Day, VOC.Actual_Check_In, GetDate())
				Else	DateDiff(Day, VM.Movement_In, GetDate())
			End,
		V.Current_KM,
		OC.Name,
		VOC.Actual_Check_In,
		VM.Movement_In,
		NULLIF(OC.Name, 'Budget BC') Owner_Order,
		V.Current_Vehicle_Status
	FROM	Vehicle V,
		Vehicle_Class VC,
		Vehicle_Model_Year VMY,
		Owning_Company OC,
		Vehicle_Movement VM,
		Vehicle_On_Contract VOC
	WHERE	V.Vehicle_Class_Code = VC.Vehicle_Class_Code
	AND	V.Vehicle_Model_Id = VMY.Vehicle_Model_Id
	AND	V.Owning_Company_Id = OC.Owning_Company_Id
	AND	V.Unit_Number = VOC.Unit_Number
	AND	V.Unit_Number = VM.Unit_Number
	
	AND	VOC.Actual_Check_In =	(	SELECT	MAX(Actual_check_In)
						FROM	Vehicle_On_Contract
						WHERE	Unit_Number = V.Unit_Number
					)
	AND	VM.Movement_In =	(	SELECT	MAX(Movement_In)
						FROM	Vehicle_Movement
						WHERE	Unit_Number = V.Unit_Number
					)
	AND	(	(V.Program = 1
			AND	V.Current_Vehicle_Status = 'a'
			AND	V.Current_Rental_Status = 'a'
			AND	V.Current_Condition_Status IN ('a', 'd', 'f', 'h', 'j')
			)
		OR
			V.Program = 0
		)
	AND	(	(VC.Vehicle_Type_Id = 'Truck'
			AND	V.Current_KM < V.Next_Scheduled_Maintenance
			)
		OR
			VC.Vehicle_Type_ID = 'Car'
		)
	AND	V.Deleted = 0
	AND	VC.Vehicle_Type_Id = @VehicleType
	AND	V.Current_KM < V.Do_Not_Rent_Past_KM
	AND	DateDiff(Day, OwnerShip_Date, GetDate()) < V.Do_Not_Rent_Past_Days
	AND	GetDate() < V.Turn_Back_Deadline
	ORDER BY
		VC.Vehicle_Class_Name,
		Owner_Order,
		V.Current_Condition_Status,
		Inactive_Day Desc		
	RETURN @@ROWCOUNT














GO
