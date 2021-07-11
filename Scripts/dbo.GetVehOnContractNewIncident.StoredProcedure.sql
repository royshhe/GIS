USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehOnContractNewIncident]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: Get the details about a vehicle on contract for use in vehicle support.
	 There can be 3 forms of the select. All match on ContractNum plus:
		- retrieve using CheckedOut and numeric UnitNumber (match on 
		  checked out datetime and GIS unit number or foreign unit number)
		- retrieve using CheckedOut and non-numeric UnitNumber (match on 
		  checked out datetime and foreign unit number only)
		- retrieve using ContractNum only, but return the latest checked
		  out record in vehicle on contract
MOD HISTORY:
Name	Date		Comment
NP	Oct 29 		- Moved data conversion code with NULLIF out of the where clause 
Don K	Mar 24 2000	Moved unit number conversion after check for numeric unit number
*/
CREATE PROCEDURE [dbo].[GetVehOnContractNewIncident]  --925441, 152598, '2006/06/26', 1
	@ContractNum	Varchar(10),
	@UnitNumber	VarChar(10) = Null,
	@CheckedOut	VarChar(24) = Null,
	@Numeric	VarChar(1) = Null
AS
	Declare	@nContractNum Integer
	Declare	@nUnitNumber Integer

	Select		@nContractNum = Convert(Int, NULLIF(@ContractNum,""))

	If @UnitNumber = ''
		SELECT @UnitNumber = NULL
	If @CheckedOut = ''
		SELECT @CheckedOut = NULL
	If @Numeric = ''
		SELECT @Numeric = NULL
  If @UnitNumber Is Not NULL And @CheckedOut Is Not NULL
    If @Numeric Is Not NULL
      Begin
	/* Retrieve using ContractNum, CheckedOut and numeric UnitNumber 
	  (match on checked out datetime and GIS unit number or foreign unit number)
	 */
	Select		@nUnitNumber = Convert(Int, NULLIF(@UnitNumber,""))

	SELECT	CON.Contract_Number,
		CON.Last_Name,
		CON.First_Name,
		V.Unit_Number,
		V.Current_Licence_Plate,
		V.Owning_Company_ID,
		LT.Value As LDW_Declined_Reason,
		CON.LDW_Declined_Details,
		CONVERT(VarChar, VOC.Checked_Out, 111) Checked_Out_Date,
		CONVERT(VarChar, VOC.Checked_Out, 108) Checked_Out_Time,
		CONVERT(VarChar, VOC.Actual_Check_In, 111) Checked_In_Date,
		CONVERT(VarChar, VOC.Actual_Check_In, 108) Checked_In_Time,
		VMY.Model_Name,
		V.Serial_Number,
		V.Exterior_Colour,
		CON.Foreign_Contract_Number,
		V.Foreign_Vehicle_Unit_Number
--	FROM	Contract CON,
--		Vehicle V,
--		Vehicle_On_Contract VOC,
--		Vehicle_Model_Year VMY,
--		Lookup_Table LT

	FROM	Contract CON 
	INNER JOIN Vehicle_On_Contract VOC
	ON CON.Contract_Number = VOC.Contract_Number
	INNER  JOIN 	Vehicle V
	ON VOC.Unit_Number = V.Unit_Number
	INNER  JOIN 	Vehicle_Model_Year VMY
	ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID
	LEFT  JOIN Lookup_Table LT
	ON CON.LDW_Declined_Reason = LT.Code AND	LT.Category = 'LDW Declined Reason'


	WHERE	CON.Contract_Number =@nContractNum
--	AND	CON.Contract_Number = VOC.Contract_Number
	AND	((V.Unit_Number = @nUnitNumber AND V.Foreign_Vehicle_Unit_Number IS NULL)
		OR V.Foreign_Vehicle_Unit_Number = @UnitNumber)
--	AND	VOC.Unit_Number = V.Unit_Number
	AND	VOC.Checked_Out = CONVERT(Datetime, @CheckedOut)
--	AND	V.Vehicle_Model_ID = VMY.Vehicle_Model_ID
--	AND	CON.LDW_Declined_Reason *= LT.Code
--	AND	LT.Category = 'LDW Declined Reason'
	ORDER BY
		VOC.Checked_Out Desc
	RETURN @@ROWCOUNT
      End
    Else
      Begin
	/* Retrieve using ContractNum, CheckedOut and non-numeric UnitNumber 
	   (match on checked out datetime and foreign unit number only)
	 */
	SELECT	CON.Contract_Number,
		CON.Last_Name,
		CON.First_Name,
		V.Unit_Number,
		V.Current_Licence_Plate,
		V.Owning_Company_ID,
		LT.Value As LDW_Declined_Reason,
		CON.LDW_Declined_Details,
		CONVERT(VarChar, VOC.Checked_Out, 111) Checked_Out_Date,
		CONVERT(VarChar, VOC.Checked_Out, 108) Checked_Out_Time,
		CONVERT(VarChar, VOC.Actual_Check_In, 111) Checked_In_Date,
		CONVERT(VarChar, VOC.Actual_Check_In, 108) Checked_In_Time,
		VMY.Model_Name,
		V.Serial_Number,
		V.Exterior_Colour,
		CON.Foreign_Contract_Number,
		V.Foreign_Vehicle_Unit_Number
--	FROM	Contract CON,
--		Vehicle V,
--		Vehicle_On_Contract VOC,
--		Vehicle_Model_Year VMY,
--		Lookup_Table LT

	FROM	Contract CON 
	INNER JOIN Vehicle_On_Contract VOC
	ON CON.Contract_Number = VOC.Contract_Number
	INNER  JOIN 	Vehicle V
	ON VOC.Unit_Number = V.Unit_Number
	INNER  JOIN 	Vehicle_Model_Year VMY
	ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID
	LEFT  JOIN Lookup_Table LT
	ON CON.LDW_Declined_Reason = LT.Code AND	LT.Category = 'LDW Declined Reason'

	WHERE	CON.Contract_Number = @nContractNum
--	AND	CON.Contract_Number = VOC.Contract_Number
	AND	V.Foreign_Vehicle_Unit_Number = @UnitNumber
--	AND	VOC.Unit_Number = V.Unit_Number
	AND	VOC.Checked_Out = CONVERT(Datetime, @CheckedOut)
--	AND	V.Vehicle_Model_ID = VMY.Vehicle_Model_ID
--	AND	CON.LDW_Declined_Reason *= LT.Code
--	AND	LT.Category = 'LDW Declined Reason'
	ORDER BY
		VOC.Checked_Out Desc
	RETURN @@ROWCOUNT
      End
  Else
    Begin
	/* Retrieve using ContractNum only, but return the latest checked
	   out record in vehicle on contract
	 */
	SET ROWCOUNT 1
	SELECT	CON.Contract_Number,
		CON.Last_Name,
		CON.First_Name,
		V.Unit_Number,
		V.Current_Licence_Plate,

		V.Owning_Company_ID,
		LT.Value As LDW_Declined_Reason,
		CON.LDW_Declined_Details,
		CONVERT(VarChar, VOC.Checked_Out, 111) Checked_Out_Date,
		CONVERT(VarChar, VOC.Checked_Out, 108) Checked_Out_Time,
		CONVERT(VarChar, VOC.Actual_Check_In, 111) Checked_In_Date,
		CONVERT(VarChar, VOC.Actual_Check_In, 108) Checked_In_Time,
		VMY.Model_Name,
		V.Serial_Number,
		V.Exterior_Colour,
		CON.Foreign_Contract_Number,
		V.Foreign_Vehicle_Unit_Number
--	FROM	Contract CON,
--		Vehicle V,
--		Vehicle_On_Contract VOC,
--		Vehicle_Model_Year VMY,
--		Lookup_Table LT
	
	FROM	Contract CON 
	INNER JOIN Vehicle_On_Contract VOC
	ON CON.Contract_Number = VOC.Contract_Number
	INNER  JOIN 	Vehicle V
	ON VOC.Unit_Number = V.Unit_Number
	INNER  JOIN 	Vehicle_Model_Year VMY
	ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID
	LEFT  JOIN Lookup_Table LT
	ON CON.LDW_Declined_Reason = LT.Code AND	LT.Category = 'LDW Declined Reason'

	WHERE	CON.Contract_Number = @nContractNum
--	AND	CON.Contract_Number = VOC.Contract_Number
	AND	CON.Status = 'CO'
--	AND	VOC.Unit_Number = V.Unit_Number
--	AND	V.Vehicle_Model_ID = VMY.Vehicle_Model_ID
--	AND	CON.LDW_Declined_Reason *= LT.Code
--	AND	LT.Category = 'LDW Declined Reason'
	ORDER BY
		VOC.Checked_Out Desc
	RETURN @@ROWCOUNT
    End
GO
