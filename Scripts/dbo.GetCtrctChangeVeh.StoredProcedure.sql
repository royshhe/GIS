USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctChangeVeh]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetCtrctChangeVeh    Script Date: 2/18/99 12:12:21 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChangeVeh    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChangeVeh    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChangeVeh    Script Date: 11/23/98 3:55:33 PM ******/
/*
PURPOSE: 	To retrieve the vehicle on contract information for the given contract number.
MOD HISTORY:

Name    Date        Comments
Roy He  Update for SQL 2008
*/
CREATE PROCEDURE [dbo].[GetCtrctChangeVeh]
	@CtrctNum	VarChar(11)
AS
	SELECT	Distinct
		VOC.Unit_Number,
		VMY.Model_Name,
		OC.Name,
		CONVERT(VarChar, VOC.Actual_Check_In, 111) Check_In_Date,
		CONVERT(VarChar, VOC.Actual_Check_In, 108) Check_In_Time,
		VOC.KM_In,
		CONVERT(Varchar,VOC.FPO_Purchased) FPO_Purchased,
		VOC.Check_In_Reason,
		LT.Value,
		VOC.KM_Out,
		VOC.Fuel_Level,
		VOC.Fuel_Remaining,
		VOC.Fuel_Added_Dollar_Amt,
		VOC.Fuel_Added_Litres,
		VOC.Vehicle_Not_Present_Reason,
		VOC.Vehicle_Not_Present_Location,
		VSI.Claim_Number
				
	     FROM	 Vehicle_On_Contract VOC
INNER JOIN Vehicle V
		On VOC.Unit_Number = V.Unit_Number

INNER JOIN Vehicle_Model_Year VMY
        On V.Vehicle_Model_Id = VMY.Vehicle_Model_ID
INNER JOIN Owning_Company OC
		On V.Owning_Company_Id = OC.Owning_Company_ID
INNER JOIN 		Lookup_Table LT
		On 	LT.Code = VOC.Vehicle_Condition_Status
LEFT  JOIN 	Vehicle_Support_Incident VSI
		On  VOC.Contract_Number = VSI.Contract_Number
--
--       Vehicle_On_Contract VOC,
--		Vehicle_Support_Incident VSI,
--		Vehicle V,
--		Vehicle_Model_Year VMY,
--		Owning_Company OC,
--		Lookup_Table LT

	WHERE	VOC.Contract_Number = CONVERT(int, @CtrctNum)
--	AND	VOC.Contract_Number *= VSI.Contract_Number
--	AND	VOC.Unit_Number = V.Unit_Number
--	AND	V.Vehicle_Model_Id = VMY.Vehicle_Model_ID
--	AND	V.Owning_Company_Id = OC.Owning_Company_ID
	AND	LT.Category = "Vehicle Condition Status"
--	AND	LT.Code = VOC.Vehicle_Condition_Status

RETURN @@ROWCOUNT
GO
