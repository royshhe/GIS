USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctInsXfer]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetCtrctInsXfer    Script Date: 2/18/99 12:12:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctInsXfer    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctInsXfer    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctInsXfer    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetCtrctInsXfer
PURPOSE: To retrieve an insurance_transfer record
AUTHOR: Don Kirkby
DATE CREATED: Aug 14, 1998
CALLED BY: Contract
REQUIRES: a record exists with the contract number
ENSURES: returns the details of a record
PARAMETERS:
	CtrctNum: Contract number
MOD HISTORY:
Name    Date        Comments
Niem P.	980924	    Return expiry time as well
*/
CREATE PROCEDURE [dbo].[GetCtrctInsXfer]
	@CtrctNum	varchar(11)
AS
	/* 10/22/99 - do nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = Convert(Int, NULLIF(@CtrctNum,''))

	SELECT	company_name,
		CONVERT(VarChar, Expiry, 111) Expiry_Date,
		CONVERT(VarChar, Expiry, 108) Expiry_Time,
		collision_deductible,
		comprehensive_deductible,
		vehicle_manufacturer,
		vehicle_model_name,
		vehicle_year,
		vehicle_licence_plate
	  FROM	insurance_transfer
	 WHERE	contract_number = @iCtrctNum
	RETURN @@ROWCOUNT













GO
