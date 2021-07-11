USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrintOptExtrasByCtrct]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*  PURPOSE:		To retrieve a list of COVERAGE-related optional extras with ldw deductible for the given contract number..
     MOD HISTORY:
     Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[GetCtrctPrintOptExtrasByCtrct]
	@ContractNum		VarChar(10)
AS
DECLARE @iContractNum Int
DECLARE @CurrVehClassCode Char(1)
DECLARE @dCurrDate Datetime

	/* 2/19/99 - cpy created - return COVERAGE-related optional extras with ldw deductible */
	/* 3/17/99 - cpy bug fix - if no VOC record for this contract, set current vcls to
				   the contract vcls */
	/* 4/07/99 - cpy bug fix - only return the COVERAGE-related optional extras that are
				   valid NOW */
	/* 7/12/99 - added CurrDatetime param */
	/* 7/16/99 - instead of using criteria @dCurrDate BETWEEN rentfrom/rentto,
		     return rows that have @dCurrDate BEFORE Rentto */
	/* 8/04/99 - remove CurrDatetime param - return all rows regardless of time */
	-- 10/06/03 - use the RP__Last_Vehicle_On_Contract to get the correct deductible for last vehicle on contract (avoid same check out time)

	SELECT	@iContractNum = Convert(Int, NULLIF(@ContractNum,''))

	-- Get current vehicle's class code
	SELECT	@CurrVehClassCode = V.Vehicle_Class_Code
	FROM	Vehicle V,
		RP__Last_Vehicle_On_Contract VOC
		-- Vehicle_On_Contract VOC
	WHERE 	VOC.Contract_Number = @iContractNum
	AND	VOC.Unit_Number = V.Unit_Number
	/*AND	VOC.Checked_Out = (	SELECT	MAX(Checked_Out)
					FROM	Vehicle_On_Contract
					WHERE	Contract_Number = @iContractNum )*/

	SELECT	COE.Optional_Extra_ID,
		OE.Optional_Extra,
		COE.Daily_Rate,
		COE.Weekly_Rate,
		LD.Ldw_Deductible,
		CONVERT(VarChar(1), COE.Included_In_Rate),
		'', --  IOE.Quantity  Included_Quantity
		COE.Quantity,
		0,
		CONVERT(VarChar, COE.Rent_From, 111) Rent_From_Date,
		CONVERT(VarChar, COE.Rent_From, 108) Rent_From_Time,
		CONVERT(VarChar, COE.Rent_To, 111) Rent_To_Date,
		CONVERT(VarChar, COE.Rent_To, 108) Rent_To_Time,
		CONVERT(VarChar, COE.GST_Exempt) GST_Exempt,
		CONVERT(VarChar, COE.HST2_Exempt) HST2_Exempt,
		CONVERT(VarChar, COE.PST_Exempt) PST_Exempt,
		COE.Sold_By,
		COE.Sold_On,
		COE.Sold_At_Location_ID,
		C.Rate_ID,
		C.Rate_Assigned_Date,
		'', -- LOC.Location,
		OE.Type

	FROM	Contract C
		JOIN Contract_Optional_Extra COE
		  ON C.Contract_Number = COE.Contract_Number

		JOIN Optional_Extra OE
		  ON COE.Optional_Extra_Id = OE.Optional_Extra_Id
		 AND COE.Termination_Date >= CONVERT(DateTime, 'Dec 31 2078')
		 AND OE.Type IN ('LDW', 'BUYDOWN', 'PAI', 'PEC', 'CARGO','ELI','PAE','RSN')
--
--		JOIN Optional_Extra_Price OEP
--		  ON OE.Optional_Extra_Id = OEP.Optional_Extra_ID

		LEFT JOIN Ldw_Deductible LD
		  ON COE.Optional_Extra_Id = LD.Optional_Extra_Id
		 AND LD.Vehicle_Class_Code = Coalesce(@CurrVehClassCode, C.Vehicle_Class_Code)

	WHERE	C.Contract_Number = @iContractNum
	--AND	@dCurrDate <= COE.Rent_To
	
	ORDER BY COE.Daily_Rate desc
	--ORDER BY OE.Type,
	--	 Rent_From_Date Desc,
	--	 Rent_To_Date Desc

	RETURN @@ROWCOUNT
GO
