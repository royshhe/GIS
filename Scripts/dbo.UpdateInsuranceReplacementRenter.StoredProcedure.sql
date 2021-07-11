USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateInsuranceReplacementRenter]    Script Date: 2021-07-10 1:50:50 PM ******/
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
 
CREATE PROCEDURE [dbo].[UpdateInsuranceReplacementRenter]
	@CtrctNum	varchar(20),
	@VehicleLicencePlate	varchar(20),
	@ClaimNumber Varchar(50),
	@AccidentType		varchar(10),
	@ShopName 	varchar(20),
	@DateInShop Varchar(24),
	@LastChangedBy Varchar(20)
AS
	Declare	@nCtrctNum Integer
	Select		@nCtrctNum = CONVERT(int, NULLIF(@CtrctNum, ''))

	UPDATE	Insurance_Replacement_Renter
		Set Vehicle_Licence_Plate=@VehicleLicencePlate,
			Claim_Number=@ClaimNumber,
			Accident_Type=@AccidentType,
			Shop_Name=@ShopName,
			Date_In_Shop=Convert(Datetime, NULLIF(@DateInShop,'')),		
			Last_Change_By=@LastChangedBy,
			Last_Change_On=GetDate()
	 WHERE	contract_number = @nCtrctNum
	RETURN @@ROWCOUNT




GO
