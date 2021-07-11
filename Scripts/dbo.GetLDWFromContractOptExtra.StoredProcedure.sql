USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLDWFromContractOptExtra]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetLDWFromContractOptExtra    Script Date: 2/18/99 12:12:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLDWFromContractOptExtra    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetLDWFromContractOptExtra    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLDWFromContractOptExtra    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetLDWFromContractOptExtra]
	@ContractNum Varchar(10)
AS
	/* 10/14/99 - do type conversion and nullif outside of SQL statements */
DECLARE	@iCtrctNum Int

	SELECT @iCtrctNum = Convert(Int, NULLIF(@ContractNum,''))

	
	
	-- changed to use the last vehicle class on contract
	SELECT	LDW.LDW_Deductible

	FROM		Contract CON,
			Contract_Optional_Extra COE,
			LDW_Deductible LDW,
			RP__Last_Vehicle_On_Contract lvoc

	WHERE	CON.Contract_Number = @iCtrctNum
	AND		CON.Contract_Number = COE.Contract_Number
	AND		COE.Termination_Date >= CONVERT(DateTime, 'Dec 31 2078 23:59:00')
	AND		COE.Optional_Extra_ID = LDW.Optional_Extra_ID
	AND		LDW.Vehicle_Class_Code = lvoc.actual_Vehicle_Class_Code
	and 		CON.Contract_Number = lvoc.contract_number
	
	-- old: incorrect to use the contract vehicle class, since there can be substitutes and upgrades
	/*SELECT	LDW.LDW_Deductible

	FROM		Contract CON,
			Contract_Optional_Extra COE,
			LDW_Deductible LDW

	WHERE	CON.Contract_Number = @iCtrctNum
	AND		CON.Contract_Number = COE.Contract_Number
	AND		COE.Termination_Date >= CONVERT(DateTime, 'Dec 31 2078 23:59:00')
	AND		COE.Optional_Extra_ID = LDW.Optional_Extra_ID
	AND		LDW.Vehicle_Class_Code = CON.Vehicle_Class_Code*/

	RETURN @@ROWCOUNT
GO
