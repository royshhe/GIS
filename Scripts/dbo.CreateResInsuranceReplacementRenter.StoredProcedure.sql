USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateResInsuranceReplacementRenter]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/*
PURPOSE: To insert a record into Contract_Reimbur_And_Discount table.
MOD HISTORY:
Name    Date        Comments
*/

-- Roy He - May 7 2009 

create PROCEDURE [dbo].[CreateResInsuranceReplacementRenter]
@ConfirmNum	varchar(20),
@VehicleLicencePlate	varchar(20),
@ClaimNumber Varchar(50),
@AccidentType		varchar(10),
@ShopName 	varchar(20),
@DateInShop Varchar(24),
@LastChangedBy Varchar(20)


AS
INSERT
	  INTO	Reservation_Insurance_Replacement_Renter
		(
		Confirmation_Number,
		Vehicle_Licence_Plate,
		Claim_Number,
		Accident_Type,
		Shop_Name,
		Date_In_Shop,
		Last_Change_By,
		Last_Change_On
		)

	VALUES	(
		CONVERT(int, @ConfirmNum),
		@VehicleLicencePlate,
		@ClaimNumber,
		@AccidentType,
		@ShopName,
		Convert(Datetime, NULLIF(@DateInShop,'')),		
		@LastChangedBy,
		GetDate()
		)
	RETURN @@ROWCOUNT
GO
