USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResInsuranceReplacementRenter]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetInsuranceReplacementRenter    Script Date: 2/18/99 12:12:15 PM ******/
/****** Object:  Stored Procedure dbo.GetInsuranceReplacementRenter    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetInsuranceReplacementRenter    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetInsuranceReplacementRenter    Script Date: 11/23/98 3:55:33 PM ******/
/*
PROCEDURE NAME: GetInsuranceReplacementRenter
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
create PROCEDURE [dbo].[GetResInsuranceReplacementRenter]
	@ConfirmNum	varchar(11)
AS
	/* 10/22/99 - do nullif outside of SQL statements */

DECLARE	@iConfirmNum Int
	SELECT @iConfirmNum = Convert(Int, NULLIF(@ConfirmNum,''))

	SELECT	Vehicle_Licence_Plate,
			Claim_Number,
			Accident_Type,
			Shop_Name,
			Date_In_Shop,		
			Last_Change_By,
			Last_Change_On
	  FROM	Reservation_Insurance_Replacement_Renter
	 WHERE	Confirmation_number = @iConfirmNum
	RETURN @@ROWCOUNT
GO
