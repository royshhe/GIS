USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetInsuranceReplacementRenterHistory]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO













/****** Object:  Stored Procedure dbo.GetInsuranceReplacementRenterHistory    Script Date: 2/18/99 12:12:15 PM ******/
/****** Object:  Stored Procedure dbo.GetInsuranceReplacementRenterHistory    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetInsuranceReplacementRenterHistory    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetInsuranceReplacementRenterHistory    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetInsuranceReplacementRenterHistory
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
CREATE PROCEDURE [dbo].[GetInsuranceReplacementRenterHistory]
	@CtrctNum	varchar(11)
AS
	/* 10/22/99 - do nullif outside of SQL statements */

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = Convert(Int, NULLIF(@CtrctNum,''))

	SELECT	Vehicle_Licence_Plate,
			Claim_Number,
			Accident_Type,
			Shop_Name,
			Date_In_Shop,		
			Last_Change_By,
			Last_Change_On
	  FROM	Insurance_Replacement_Renter_History
	 WHERE	contract_number = @iCtrctNum
		order by last_change_on desc
	RETURN @@ROWCOUNT















GO
