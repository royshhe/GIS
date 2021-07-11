USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateResInsuranceReplacementRenter]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.UpdateInsuranceReplacementRenter    Script Date: 2/18/99 12:12:18 PM ******/

/*
PROCEDURE NAME: UpdateInsuranceReplacementRenter
PURPOSE: To update an InsuranceReplacementRenter record
AUTHOR: Roy He
DATE CREATED: Apr 14, 2009
CALLED BY: Contract
REQUIRES: a record exists with the contract number
ENSURES: the record is updated. returns 1 for success, else 0
PARAMETERS:
	 
MOD HISTORY:

Name    Date        Comments
*/
 
create PROCEDURE [dbo].[UpdateResInsuranceReplacementRenter]
	@ConfirmNum	varchar(20),
	@VehicleLicencePlate	varchar(20),
	@ClaimNumber Varchar(50),
	@AccidentType		varchar(10),
	@ShopName 	varchar(20),
	@DateInShop Varchar(24),
	@LastChangedBy Varchar(20)
AS
	Declare	@nConfirmNum Integer
	Select		@nConfirmNum = CONVERT(int, NULLIF(@ConfirmNum, ''))

	UPDATE	Reservation_Insurance_Replacement_Renter
		Set Vehicle_Licence_Plate=@VehicleLicencePlate,
			Claim_Number=@ClaimNumber,
			Accident_Type=@AccidentType,
			Shop_Name=@ShopName,
			Date_In_Shop=Convert(Datetime, NULLIF(@DateInShop,'')),		
			Last_Change_By=@LastChangedBy,
			Last_Change_On=GetDate()
	 WHERE	Confirmation_number = @nConfirmNum
	RETURN @@ROWCOUNT
GO
