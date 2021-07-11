USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehAvail_VM]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetVehAvail_VM    Script Date: 2/18/99 12:12:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehAvail_VM    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehAvail_VM    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehAvail_VM    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetVehAvail_VM] --16
	@LocationID	Varchar(10)
AS
	/* 3/05/99 - cpy bug fix - check for null values in do_not_rent_past_km/days */
	/* 3/09/99 - cpy bug fix - put ISNULL check on Next_Scheduled_Maintenance */
	/* 3/12/99 - cpy bug fix - return foreign unit # if foreign, else return unit # */
	/* 3/17/99 - cpy bug fix - return condition status desc, not code */

DECLARE	@iBracCompanyId Int

	-- NOTE: it is important to alias the column names if you are going to apply
	--	 formatting to column because vb invoker references by specific column names

	-- get budgetbc owning company id
	SELECT	@iBracCompanyId = Convert(Int, Code)
	FROM	Lookup_Table
	WHERE	Category = 'BudgetBC Company'

	SELECT	VC.Vehicle_Class_Name,
		ISNULL(V.Foreign_Vehicle_Unit_Number, V.Unit_Number) as Unit_Number,
		VMY.Model_Name,
		V.Exterior_Colour,
		DateDiff(Day, VM.Movement_In, GetDate()) as Inactive_Day,
		V.Current_KM,
		OC.Name,
		'Owner_Order' =
			Case
				When V.Owning_Company_Id = @iBracCompanyId Then
					'1'
				Else OC.Name
			End,
		LT.Value as Current_Condition_Status, --V.Current_Condition_Status,
		V.Do_Not_Rent_Past_KM,
		V.Do_Not_Rent_Past_Days,
		V.OwnerShip_Date,
		VC.Vehicle_Type_ID,
		V.Next_Scheduled_Maintenance,
		V.Current_Licence_Plate
--	FROM	Vehicle V,
--		Vehicle_Class VC,
--		Vehicle_Model_Year VMY,
--		Owning_Company OC,
--		Vehicle_Movement VM,
--		Lookup_Table LT


	FROM	Vehicle V
		INNER JOIN Vehicle_Class VC
		ON V.Vehicle_Class_Code = VC.Vehicle_Class_Code
		INNER JOIN  Vehicle_Model_Year VMY
		ON V.Vehicle_Model_Id = VMY.Vehicle_Model_Id
        INNER JOIN	Owning_Company OC
		ON V.Owning_Company_Id = OC.Owning_Company_Id
		INNER JOIN Vehicle_Movement VM
		ON V.Unit_Number = VM.Unit_Number
		LEFT JOIN 		Lookup_Table LT
		ON V.Current_Condition_Status = LT.Code AND	LT.Category = 'Vehicle Condition Status'

	WHERE	V.Current_Location_Id = CONVERT(SmallInt, @LocationID)
--	AND	V.Vehicle_Class_Code = VC.Vehicle_Class_Code
--	AND	V.Vehicle_Model_Id = VMY.Vehicle_Model_Id
--	AND	V.Owning_Company_Id = OC.Owning_Company_Id
--	AND	V.Current_Condition_Status *= LT.Code
--	AND	LT.Category = 'Vehicle Condition Status'
--	AND	V.Unit_Number = VM.Unit_Number
	
	AND	VM.Movement_In =	(	SELECT	MAX(Movement_In)
						FROM	Vehicle_Movement
						WHERE	Unit_Number = V.Unit_Number
					)
	AND	V.Current_Vehicle_Status = 'd'
	AND	V.Current_Rental_Status = 'a'
	AND	V.Current_Condition_Status IN ('a', 'd', 'f', 'h', 'j')
	AND	(	(V.Program = 1
			AND	ISNULL(V.Current_KM,0) < ISNULL(V.Do_Not_Rent_Past_KM, ISNULL(V.Current_KM + 1,1))
			AND	DateDiff(Day, OwnerShip_Date, GetDate()) < ISNULL(V.Do_Not_Rent_Past_Days, 32767)
			AND	GetDate() < ISNULL(V.Turn_Back_Deadline, DateAdd(Day, 1, GetDate()) )
			)
		OR
			V.Program = 0
		)
	AND	(	(VC.Vehicle_Type_Id = 'Truck'
			AND	V.Current_KM < ISNULL(V.Next_Scheduled_Maintenance, V.Current_KM + 1)
			)
		OR
			VC.Vehicle_Type_ID = 'Car'
		)
	AND	V.Deleted = 0
	ORDER BY 1 asc, 8 asc, 5 desc

	RETURN @@ROWCOUNT
GO
