USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctVehOnContract]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*  
PURPOSE: To retrieve vehicle on contract for the given contract number.
MOD HISTORY:
Name    Date        	Comments
CPY	Jan 25 2000	Changed the order by to order by business_transaction_id
*/
CREATE PROCEDURE [dbo].[GetCtrctVehOnContract]	--'1358971'
	@ContractNum	Varchar(10)
AS
	DECLARE @dEndDate Datetime
	DECLARE @nContractNum Integer

	/* 2/20/99 - cpy modified - added override placeholder */
	/* 3/10/99 - cpy modified - instead of returning VOC.Actual_Vehicle_Class_Code,
				return V.Vehicle_Class_Code (which is the actual vehicle
				class code for the unit num) */
	/* 4/20/99 - cpy bug fix - added order by Actual_Check_In Asc to make unchecked in
				records be returned 1st */
	/* 8/03/99 - re-write to use inner join and left outer joins
		   - join with vehicle_licence_history to get licence plate
			that was current during check out */
	/* Nov 01 - Moved data conversion code with NULLIF out of the where clause */

	SELECT @dEndDate = Convert(Datetime, '31 Dec 2078 23:59')
	SELECT @nContractNum = Convert(Int, NULLIF(@ContractNum,''))

	SET ROWCOUNT 1
	SELECT
		V.Owning_Company_ID,
		VOC.Unit_Number,
		CONVERT(VarChar, Checked_Out, 111) Checked_Out_Date,

		CONVERT(VarChar, Checked_Out, 108) Checked_Out_Time,
		Pick_Up_Location_ID,
		
		CONVERT(VarChar, Expected_Check_In, 111) Expected_Check_In_Date,
		CONVERT(VarChar, Expected_Check_In, 108) Expected_Check_In_Time,
		Expected_Drop_Off_Location_ID,
		CONVERT(VarChar, Actual_Check_In, 111) Actual_Check_In_Date,
		CONVERT(VarChar, Actual_Check_In, 108) Actual_Check_In_Time,
		
		Actual_Drop_Off_Location_ID,
		Km_Out,
		Km_In,
		Fuel_Level,
		Fuel_Remaining,
		
		Fuel_Added_Dollar_Amt,
		Fuel_Added_Litres,
		Vehicle_Condition_Status,
		Vehicle_Not_Present_Reason,
		Vehicle_Not_Present_Location,
		
		Checked_In_By,
		Check_In_Reason,
		V.Vehicle_Class_Code, -- Actual_Vehicle_Class_Code,
		Convert(Char(1), FPO_Purchased) FPO_Purchased,
		Calculated_Fuel_Litre,
		
		Fuel_Price_Per_Litre,
		Calculated_Fuel_Charge,
		Upgrade_Charge,
		VMY.Model_Name,
		Licence_Plate = ISNULL(VLH.Licence_Plate_Number, V.Current_Licence_Plate),
		
		OC.Name,
		Calculated_Upgrade_Charge,
		V.Foreign_Vehicle_Unit_Number,
		Foreign_FPO_Charge,
		Replacement_Contract_Number,
		'', 	-- placeholder for OverrideTruckAvailCheck
		V.MVA_Number,
		V.Maximum_Rental_Period
	FROM	Vehicle_On_Contract VOC
		JOIN Vehicle V
		  ON VOC.Unit_Number = V.Unit_Number

		JOIN Owning_Company OC
		  ON V.Owning_Company_Id = OC.Owning_Company_Id		

		JOIN Vehicle_Model_Year VMY
		  ON V.Vehicle_Model_Id = VMY.Vehicle_Model_Id

		LEFT JOIN Vehicle_Licence_History VLH
		  ON VOC.Unit_Number = VLH.Unit_Number
		 AND VOC.Checked_Out BETWEEN VLH.Attached_On AND
				ISNULL(VLH.Removed_On, @dEndDate)

	WHERE	VOC.Contract_Number = @nContractNum
	ORDER BY
		--Checked_Out Desc, 
		Business_Transaction_Id Desc
	RETURN @@ROWCOUNT

GO
