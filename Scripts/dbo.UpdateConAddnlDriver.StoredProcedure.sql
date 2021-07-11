USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateConAddnlDriver]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PURPOSE: To update a record in Contract_Additional_Driver table .
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[UpdateConAddnlDriver]
	@ContractNum 	Varchar(10),
	@AddDriverId	Varchar(10),
	@LastName 	Varchar(25),
	@FirstName 	Varchar(25),
	@ValidFrom 	Varchar(24),
	@ValidTo 	Varchar(24),
	@CustId 	Varchar(10),
	@BirthDate 	Varchar(24),
	@DLNumber 	Varchar(25),
	@DLJurisdiction Varchar(20),
	@DLExpiry 	Varchar(24),
	@DLClass 	Varchar(1),
	@Addr1 	Varchar(50),
	@Addr2 	Varchar(20),
	@City 		Varchar(20),
	@ProvState 	Varchar(20),
	@Country 	Varchar(20),
	@PostalCode 	Varchar(10),
	@AddType	Varchar(20),
	@ChangedBy 	Varchar(20),
	@NoCharge	VarChar(1)
AS
	/* 10/05/99 - @LastName, @FirstName varchar(20) -> varchar(25) 
			@DLNumber varchar(10) -> varchar(25) 
			@PostalCode varchar(7) -> varchar(10) */
	/* 10/18/99 - do type conversion and nullif outside of SQL statements */

DECLARE @dCurrDate Datetime, 
	@iCtrctNum Int, 
	@iAddDriverId Int

	SELECT 	@dCurrDate = GetDate(), 
		@iCtrctNum = Convert(Int, NULLIF(@ContractNum,'')),
		@iAddDriverId = Convert(Int, NULLIF(@AddDriverId,''))

	UPDATE 	Contract_Additional_Driver

	SET	Last_Name = @LastName,
		First_Name = @FirstName,
		Valid_From = Convert(Datetime, NULLIF(@ValidFrom,'')),
		Valid_To = Convert(Datetime, NULLIF(@ValidTo,'')),
		Customer_ID = Convert(Int, NULLIF(@CustId,'')),
		Birth_Date = Convert(Datetime, NULLIF(@BirthDate,'')),
		Driver_Licence_Number = @DLNumber,
		Driver_Licence_Jurisdiction = @DLJurisdiction,
		Driver_Licence_Expiry = Convert(Datetime, NULLIF(@DLExpiry,'')),
		Driver_Licence_Class = @DLClass,
		Address_1 = @Addr1,
		Address_2 = @Addr2,
		City = @City,
		Province_State = @ProvState,
		Country = @Country,
		Postal_Code = @PostalCode,
		Addition_Type = @AddType,
		Last_Changed_By = @ChangedBy,
		No_Charge = Convert(Bit, NULLIF(@NoCharge, ''))

	WHERE	Contract_Number = @iCtrctNum
	AND	Additional_Driver_Id = @iAddDriverId
	AND	Termination_Date = '31 Dec 2078 23:59'

	RETURN @@ROWCOUNT




















GO
