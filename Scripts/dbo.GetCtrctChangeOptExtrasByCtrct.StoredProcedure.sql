USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctChangeOptExtrasByCtrct]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetCtrctChangeOptExtrasByCtrct    Script Date: 2/18/99 12:12:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChangeOptExtrasByCtrct    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChangeOptExtrasByCtrct    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctChangeOptExtrasByCtrct    Script Date: 11/23/98 3:55:33 PM ******/
/*
PURPOSE: 	To retrieve the optional extra information for the given contract. If @History is not null, return all optional extra for that contract;
		otherwise, return only the most current one.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctChangeOptExtrasByCtrct] -- '3019273'
	@ContractNumber		VarChar(10),
	@History		VarChar(1) = NULL
AS
	/* 4/01/99 - cpy comment - returns non-coverage optional extras
			- if History = Y, include historical records
			- else, return only currently rented optional extras */

	/* 4/01/99 - cpy bug fix - when returning history, was returning multiple
			rows for the same item when there were multiple prices
			defined in optional_extra_price */

	/* 4/01/99 - added optional extra type */
	/* 10/11/99 - do type conversion and nullif outside of SQL statement */

DECLARE @iCtrctNum Int,
	@dTermDate Datetime

	SELECT	@iCtrctNum = CONVERT(Int, NULLIF(@ContractNumber, '')),
		@dTermDate = CONVERT(DateTime, 'Dec 31 2078')

  If @History = 'Y'
	SELECT	COE.Optional_Extra_ID,
		OEO.Optional_Extra,
		COE.Daily_Rate,
		COE.Weekly_Rate,
		0, /* Deductible, */
		CONVERT(VarChar(1), COE.Included_In_Rate),
		'', /*IOE.Quantity Included_Quantity, */
		COE.Quantity,
		0,
		CONVERT(VarChar, COE.Rent_From, 111) Rent_From_Date,
		CONVERT(VarChar, COE.Rent_From, 108) Rent_From_Time,
		CONVERT(VarChar, COE.Rent_To, 111) Rent_To_Date,
		CONVERT(VarChar, COE.Rent_To, 108) Rent_To_Time,
		COE.Unit_Number,
		COE.Coupon_Code,
		CONVERT(VarChar, COE.GST_Exempt) GST_Exempt,
		CONVERT(VarChar, COE.HST2_Exempt) HST2_Exempt,
		CONVERT(VarChar, COE.PST_Exempt) PST_Exempt,

		COE.Flat_rate,

		COE.Sold_By,
		COE.Sold_On,
		COE.Sold_At_Location_ID,
		CON.Rate_ID,
		CON.Rate_Assigned_Date,
		LOC.Location,
		OEO.Type,
		COE.Status,
		COE.Return_Location_ID,
		COE.Sequence
	
	FROM	Contract CON,
		Contract_Optional_Extra COE,
		Optional_Extra_Other OEO,
		Optional_Extra_Price OEP,
		Location LOC
	WHERE	CON.Contract_Number = @iCtrctNum
	AND	CON.Contract_Number = COE.Contract_Number
	AND	COE.Optional_Extra_ID = OEO.Optional_Extra_ID
	AND	OEO.Optional_Extra_ID = OEP.Optional_Extra_ID
	AND	COE.Rent_From BETWEEN OEP.Optional_Extra_Valid_From AND
					ISNULL(OEP.Valid_To, @dTermDate)
	AND	COE.Sold_At_Location_ID = LOC.Location_ID
	ORDER BY
		OEO.Optional_Extra,
		COE.Sold_On Desc
  Else
	SELECT	Distinct
		COE.Optional_Extra_ID,
		OEO.Optional_Extra,
		COE.Daily_Rate,
		COE.Weekly_Rate,
		0, /* Deductible, */
		CONVERT(VarChar(1), COE.Included_In_Rate),
		'', /* IOE.Quantity  Included_Quantity, */
		COE.Quantity,
		0,
		CONVERT(VarChar, COE.Rent_From, 111) Rent_From_Date,
		CONVERT(VarChar, COE.Rent_From, 108) Rent_From_Time,
		CONVERT(VarChar, COE.Rent_To, 111) Rent_To_Date,
		CONVERT(VarChar, COE.Rent_To, 108) Rent_To_Time,
		COE.Unit_Number,
		COE.Coupon_Code,
		CONVERT(VarChar, COE.GST_Exempt) GST_Exempt,
		CONVERT(VarChar, COE.HST2_Exempt) HST2_Exempt,
		CONVERT(VarChar, COE.PST_Exempt) PST_Exempt,

		COE.Flat_rate,

		COE.Sold_By,
		COE.Sold_On,
		COE.Sold_At_Location_ID,
		CON.Rate_ID,
		CON.Rate_Assigned_Date,
		LOC.Location,
		OEO.Type,
		COE.Status,
		COE.Return_Location_ID,
		COE.Sequence
	
	FROM	Contract CON,
		Contract_Optional_Extra COE,
		Optional_Extra_Other OEO,
		Optional_Extra_Price OEP,
		Location LOC
	WHERE	CON.Contract_Number = @iCtrctNum
	AND	CON.Contract_Number = COE.Contract_Number
	AND	COE.Optional_Extra_ID = OEO.Optional_Extra_ID
	AND	OEO.Optional_Extra_ID = OEP.Optional_Extra_ID
	AND	COE.Sold_At_Location_ID = LOC.Location_ID
	AND	COE.Termination_Date >= @dTermDate
	ORDER BY
		OEO.Optional_Extra,
		COE.Sold_On Desc

	RETURN @@ROWCOUNT

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
