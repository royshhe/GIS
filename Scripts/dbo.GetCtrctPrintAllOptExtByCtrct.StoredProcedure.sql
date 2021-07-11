USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPrintAllOptExtByCtrct]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetCtrctPrintAllOptExtByCtrct] --'3019273'
	@ContractNumber		VarChar(10)
AS
	/* 3/15/99 - cpy created - copied from GetCtrctChangeOptExtrasByCtrct; only difference
			is that this function returns all opt extras included or not */
	/* 10/18/99 - do type conversion and nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = CONVERT(Int, NULLIF(@ContractNumber, ''))

	SELECT	Distinct
		COE.Optional_Extra_ID,
		OE.Optional_Extra,
		(case when CONVERT(VarChar(1), COE.Included_In_Rate)=1 
				then 0
				else COE.Daily_Rate
		end) as Daily_Rate,
		(case when CONVERT(VarChar(1), COE.Included_In_Rate)=1 
				then 0
				else COE.Weekly_Rate
		end) as Weekly_Rate,
		0, /* Deductible, */
		CONVERT(VarChar(1), COE.Included_In_Rate),
		'', /* IOE.Quantity  Included_Quantity, */
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
		CON.Rate_ID,
		CON.Rate_Assigned_Date,
		LOC.Location,
		oe.type,
		(case when CONVERT(VarChar(1), COE.Included_In_Rate)=1 
				then 0
				else COE.Flat_rate
		end) as Flat_Rate		
	
	FROM	Contract CON,
		Contract_Optional_Extra COE,
		Optional_Extra OE,
		Optional_Extra_Price OEP,
		Location LOC
	WHERE	CON.Contract_Number = @iCtrctNum
	AND	CON.Contract_Number = COE.Contract_Number
	AND	COE.Optional_Extra_Id = OE.Optional_Extra_Id
	AND	OE.Optional_Extra_ID = OEP.Optional_Extra_ID
	AND	COE.Sold_At_Location_ID = LOC.Location_ID
	AND	OE.Type IN ('LDW', 'Buydown', 'PAI', 'PEC', 'Cargo','ELI','PAE','RSN')
	AND	COE.Termination_Date >= CONVERT(DateTime, 'Dec 31 2078')
	And ((CONVERT(VarChar, COE.Rent_From, 111)+CONVERT(VarChar, COE.Rent_From, 108))<>(CONVERT(VarChar, COE.Rent_To, 111)+CONVERT(VarChar, COE.Rent_To, 108)))
	and CONVERT(VarChar(1), COE.Included_In_Rate)=0-- filter out those inclusive data
	and COE.Quantity<>0

	union all

	SELECT	Distinct
		COE.Optional_Extra_ID,
		OE.Optional_Extra,
		(case when CONVERT(VarChar(1), COE.Included_In_Rate)=1 
				then 0
				else COE.Daily_Rate
		end) as Daily_Rate,
		(case when CONVERT(VarChar(1), COE.Included_In_Rate)=1 
				then 0
				else COE.Weekly_Rate
		end) as Weekly_Rate,
		0, /* Deductible, */
		CONVERT(VarChar(1), COE.Included_In_Rate),
		'', /* IOE.Quantity  Included_Quantity, */
		COE.Quantity,
		0,
		CONVERT(VarChar, COE.Rent_From, 111) Rent_From_Date,
		CONVERT(VarChar, COE.Rent_From, 108) Rent_From_Time,
		CONVERT(VarChar, COE.Rent_To, 111) Rent_To_Date,
		CONVERT(VarChar, COE.Rent_To, 108) Rent_To_Time,
		CONVERT(VarChar, COE.GST_Exempt) GST_Exempt,
	    CONVERT(VarChar, COE.HST2_Exempt) HST2_Exempt,
--		CONVERT(bit, convert(int,COE.GST_Exempt)*convert(int,COE.HST2_Exempt)) GST_Exempt,		
		CONVERT(VarChar, COE.PST_Exempt) PST_Exempt,
		COE.Sold_By,
		COE.Sold_On,
		COE.Sold_At_Location_ID,
		CON.Rate_ID,
		CON.Rate_Assigned_Date,
		LOC.Location,
		oe.type,
		(case when CONVERT(VarChar(1), COE.Included_In_Rate)=1 
				then 0
				else COE.Flat_rate
		end) as Flat_Rate		
	
	FROM	Contract CON,
		Contract_Optional_Extra COE,
		Optional_Extra OE,
		Optional_Extra_Price OEP,
		Location LOC
	WHERE	CON.Contract_Number = @iCtrctNum
	AND	CON.Contract_Number = COE.Contract_Number
	AND	COE.Optional_Extra_Id = OE.Optional_Extra_Id
	AND	OE.Optional_Extra_ID = OEP.Optional_Extra_ID
	AND	COE.Sold_At_Location_ID = LOC.Location_ID
	AND	OE.Type not IN ('LDW', 'Buydown', 'PAI', 'PEC', 'Cargo','ELI','PAE','RSN')
	AND	COE.Termination_Date >= CONVERT(DateTime, 'Dec 31 2078')
	And ((CONVERT(VarChar, COE.Rent_From, 111)+CONVERT(VarChar, COE.Rent_From, 108))<>(CONVERT(VarChar, COE.Rent_To, 111)+CONVERT(VarChar, COE.Rent_To, 108)))
	and CONVERT(VarChar(1), COE.Included_In_Rate)=0
	and COE.Quantity<>0

	ORDER BY  Daily_Rate desc
		--OE.Optional_Extra,
		--Rent_From_Date Desc,
		--Rent_To_Date Desc

	RETURN @@ROWCOUNT
GO
