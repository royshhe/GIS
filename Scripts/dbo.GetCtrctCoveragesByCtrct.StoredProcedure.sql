USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctCoveragesByCtrct]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetCtrctCoveragesByCtrct    Script Date: 2/18/99 12:12:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctCoveragesByCtrct    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctCoveragesByCtrct    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctCoveragesByCtrct    Script Date: 11/23/98 3:55:33 PM ******/
/*
PURPOSE: 	To retrieve the optional extra for the contract.  If @History is null, return the most current one; otherwise, return a list of optional extras for the given contract number.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctCoveragesByCtrct]
	@ContractNumber		VarChar(10),
	@History		VarChar(1) = NULL
AS
	/* 4/01/99 - cpy comment - return COVERAGE-related optional extras that were
				bought on a contract
			- if History = Y, return the history of optional extras
			- else return only the current optional extra */

	/* 4/01/99 - cpy modified - added optional extra type */
	/* 4/06/99 - cpy bug fix - return LDW deductible for the current vehicle class
					on contract */

DECLARE @iContractNumber Int,
	@CurrVehClassCode Char(1)

	SELECT	@iContractNumber = Convert(Int, NULLIF(@ContractNumber,''))

	-- Get vehicle class code of the current vehicle on contract
	SET ROWCOUNT 1

	SELECT 	@CurrVehClassCode = V.Vehicle_Class_Code
	FROM	Vehicle V,
		Vehicle_On_Contract VOC
	WHERE	VOC.Unit_Number = V.Unit_Number
	AND	VOC.Contract_Number = @iContractNumber
	ORDER BY VOC.Checked_Out DESC

	SET ROWCOUNT 0

  If @History = 'Y'
	SELECT	Distinct
		COE.Optional_Extra_ID,
		OE.Optional_Extra,
		COE.Daily_Rate,
		COE.Weekly_Rate,
		LDW.LDW_Deductible,
		CONVERT(VarChar(1), COE.Included_In_Rate),
		'', /*IOE.Quantity Included_Quantity, */
		COE.Quantity,
		0,
		CONVERT(VarChar, COE.Rent_From, 111) Rent_From_Date,
		CONVERT(VarChar, COE.Rent_From, 108) Rent_From_Time,
		CONVERT(VarChar, COE.Rent_To, 111) Rent_To_Date,
		CONVERT(VarChar, COE.Rent_To, 108) Rent_To_Time,
		'', /* Opt Extra Unit_Number */
		'',
		CONVERT(VarChar, COE.GST_Exempt) GST_Exempt,
		CONVERT(VarChar, COE.HST2_Exempt) HST2_Exempt,
		CONVERT(VarChar, COE.PST_Exempt) PST_Exempt,

		Coe.Flat_rate,

		COE.Sold_By,
		COE.Sold_On,
		COE.Sold_At_Location_ID,
		CON.Rate_ID,
		CON.Rate_Assigned_Date,
		LOC.Location,
		OE.Type,
		'',
		'',
		COE.Sequence
	
	FROM	Contract CON 
		Inner Join 	Contract_Optional_Extra COE
		On CON.Contract_Number = COE.Contract_Number
		Inner Join Optional_Extra OE
		On COE.Optional_Extra_ID = OE.Optional_Extra_ID
		Inner Join	Optional_Extra_Price OEP
	    On  OE.Optional_Extra_ID = OEP.Optional_Extra_ID
		Inner Join	Location LOC
		On COE.Sold_At_Location_ID = LOC.Location_ID
		Left Join	LDW_Deductible LDW
		On OE.Optional_Extra_ID = LDW.Optional_Extra_ID
		And LDW.Vehicle_Class_Code = COALESCE(@CurrVehClassCode, CON.Vehicle_Class_Code)
	 

--
--		Contract CON,
--		Contract_Optional_Extra COE,
--		Optional_Extra OE,
--		Optional_Extra_Price OEP,
--		LDW_Deductible LDW,
--		Location LOC
	WHERE	CON.Contract_Number = @iContractNumber
--	AND	CON.Contract_Number = COE.Contract_Number
--	AND	COE.Optional_Extra_ID = OE.Optional_Extra_ID
--	AND	OE.Optional_Extra_ID = OEP.Optional_Extra_ID
--	AND	OE.Optional_Extra_ID *= LDW.Optional_Extra_ID
--	AND	LDW.Vehicle_Class_Code =* COALESCE(@CurrVehClassCode, CON.Vehicle_Class_Code)
	AND	OE.Type IN ('LDW', 'Buydown', 'PAI', 'PEC', 'Cargo','ELI','PAE','RSN')
--	AND	COE.Sold_At_Location_ID = LOC.Location_ID
	ORDER BY
		OE.Optional_Extra,
		COE.Sold_On Desc
  Else
	SELECT	Distinct
		COE.Optional_Extra_ID,
		OE.Optional_Extra,
		COE.Daily_Rate,
		COE.Weekly_Rate,
		LDW.LDW_Deductible,
		CONVERT(VarChar(1), COE.Included_In_Rate),
		'', /* IOE.Quantity  Included_Quantity, */
		COE.Quantity,
		0,
		CONVERT(VarChar, COE.Rent_From, 111) Rent_From_Date,
		CONVERT(VarChar, COE.Rent_From, 108) Rent_From_Time,
		CONVERT(VarChar, COE.Rent_To, 111) Rent_To_Date,
		CONVERT(VarChar, COE.Rent_To, 108) Rent_To_Time,
		'', /* Opt Extra Unit_Number */
		'',
		CONVERT(VarChar, COE.GST_Exempt) GST_Exempt,
		CONVERT(VarChar, COE.HST2_Exempt) HST2_Exempt,
		CONVERT(VarChar, COE.PST_Exempt) PST_Exempt,

		Coe.Flat_rate,

		COE.Sold_By,
		COE.Sold_On,
		COE.Sold_At_Location_ID,
		CON.Rate_ID,
		CON.Rate_Assigned_Date,
		LOC.Location,
		OE.Type,
		'',
		'',
		COE.Sequence
	FROM	Contract CON 
		Inner Join 	Contract_Optional_Extra COE
		On CON.Contract_Number = COE.Contract_Number
		Inner Join Optional_Extra OE
		On COE.Optional_Extra_ID = OE.Optional_Extra_ID
		Inner Join	Optional_Extra_Price OEP
	    On  OE.Optional_Extra_ID = OEP.Optional_Extra_ID
		Inner Join	Location LOC
		On COE.Sold_At_Location_ID = LOC.Location_ID
		Left Join	LDW_Deductible LDW
		On OE.Optional_Extra_ID = LDW.Optional_Extra_ID
		And LDW.Vehicle_Class_Code = COALESCE(@CurrVehClassCode, CON.Vehicle_Class_Code)

--
--       Contract CON,
--		Contract_Optional_Extra COE,
--		Optional_Extra OE,
--		Optional_Extra_Price OEP,
--		LDW_Deductible LDW,
--		Location LOC
	WHERE	CON.Contract_Number = @iContractNumber
--	AND	CON.Contract_Number = COE.Contract_Number
--	AND	COE.Optional_Extra_ID = OE.Optional_Extra_ID
--	AND	OE.Optional_Extra_ID = OEP.Optional_Extra_ID
--	AND	OE.Optional_Extra_ID *= LDW.Optional_Extra_ID
--	AND	LDW.Vehicle_Class_Code =* COALESCE(@CurrVehClassCode, CON.Vehicle_Class_Code)
	AND	OE.Type IN ('LDW', 'Buydown', 'PAI', 'PEC', 'Cargo','ELI','PAE','RSN')
--	AND	COE.Sold_At_Location_ID = LOC.Location_ID
	AND	COE.Termination_Date >= CONVERT(DateTime, 'Dec 31 2078')
	ORDER BY
		OE.Optional_Extra,
		COE.Sold_On Desc
	
RETURN @@ROWCOUNT

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
