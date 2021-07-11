USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateConAddnlDriver]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PURPOSE: To insert a record into Contract_Additional_Driver table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateConAddnlDriver]
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
	@Addr1		Varchar(50),
	@Addr2		Varchar(20),
	@City 		Varchar(20),
	@ProvState 	Varchar(20),
	@Country 	Varchar(20),
	@PostalCode 	Varchar(10),
	@AddType	Varchar(20),
	@ChangedBy 	Varchar(20),
	@NoCharge	VarChar(1)
AS
	/* Don K - Oct 8 1999 - Only make additional driver id unique within
		a contract. This stops it locking the whole table.
	 */
	/* 10/05/99 - @lastName, @FirstName varchar(20) -> varchar(25) 
			@DLNumber varchar(10) -> varchar(25) 
			@PostalCode varchar(7) -> varchar(10) */

DECLARE @iAddDriverId Int,
	@nCtrctNum int

	-- Set Driver Id to be the AddDriverId if provided
	SELECT @iAddDriverId = Convert(Int, NULLIF(@AddDriverId,'')),
		@nCtrctNum = Convert(Int, NULLIF(@ContractNum,''))
	IF @iAddDriverId IS NULL
		-- Get next AddDriverId to be MAX + 1
		-- Set default driver id to start from 1
		SELECT @iAddDriverId = ISNULL(
			(SELECT MAX(Additional_Driver_ID) + 1
			 FROM 	Contract_Additional_Driver 
			 WHERE	Contract_Number = @nCtrctNum), 1)
	INSERT INTO Contract_Additional_Driver
		(Contract_Number,
		 Additional_Driver_ID,
		 Last_Name,
		 First_Name,
		 Effective_Date,
		 Valid_From,
		 Valid_To,
		 Customer_ID,
		 Birth_Date,
		 Driver_Licence_Number, Driver_Licence_Jurisdiction,
		 Driver_Licence_Expiry,
		 Driver_Licence_Class, Address_1, Address_2,
		 City, Province_State, Country, Postal_Code,
		 Addition_Type, Last_Changed_By,
		 Termination_Date,
		 No_Charge)
	VALUES
		(@nCtrctNum,
		 @iAddDriverId,
		 @LastName, @FirstName,
		 GetDate(),
		 Convert(Datetime, NULLIF(@ValidFrom,'')),
		 Convert(Datetime, NULLIF(@ValidTo,'')),
		 Convert(Int, NULLIF(@CustId,'')),
		 Convert(Datetime, NULLIF(@BirthDate,'')),
		 @DLNumber, @DLJurisdiction,
		 Convert(Datetime, NULLIF(@DLExpiry,'')),
		 @DLClass, @Addr1, @Addr2,
		 @City, @ProvState, @Country, @PostalCode,
		 @AddType, @ChangedBy,
		 '31 Dec 2078 23:59',
		 Convert(Bit, NULLIF(@NoCharge, ''))
		)
	RETURN @@ROWCOUNT



















GO
