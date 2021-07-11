USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateVoidedCreditCardTransaction]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[CreateVoidedCreditCardTransaction]
	@AuthNum 	Varchar(12),
	@CCTypeId 	Char(3),
	@CCNum 		Varchar(20),
	@LastName 	Varchar(25),
	@FirstName 	Varchar(25),
	@CCExpiry 	Char(5),
	@Amount 	Varchar(10),
	@CollectedBy 	Varchar(20),
	@CollectedAtLocId Varchar(5),
	@TerminalId 	Varchar(20),
	@TrxReceiptNum 	Char(8),
	@TrxISORespCode Char(2),
	@TrxRemarks 	Varchar(20),
	@SwipedFlag 	Char(1),
	@ContractNum 	Varchar(10),
	@ConfirmNum 	Varchar(10),
	@SalesCtrctNum 	Varchar(10),
	@AddedToGIS 	Char(1),
	@EnteredOnHH 	Char(1),
	@SourceFunction Varchar(20),
	@RBRDate 	Varchar(24)
AS

	SELECT	@AuthNum = NULLIF(@AuthNum,''),
		@CCTypeId = NULLIF(@CCTypeId,''),
		@CCNum = NULLIF(@CCNum,''),
		@LastName = NULLIF(@LastName,''),
		@FirstName = NULLIF(@FirstName,''),
		@CCExpiry = NULLIF(@CCExpiry,''),
		@Amount = NULLIF(@Amount,''),
		@CollectedBy = NULLIF(@CollectedBy,''),
		@CollectedAtLocId = NULLIF(@CollectedAtLocId,''),
		@TerminalId = NULLIF(@TerminalId,''),
		@TrxReceiptNum = NULLIF(@TrxReceiptNum,''),
		@TrxISORespCode = NULLIF(@TrxISORespCode,''),
		@TrxRemarks = NULLIF(@TrxRemarks,''),
		@SwipedFlag = NULLIF(@SwipedFlag,''),
		@ContractNum = NULLIF(@ContractNum,''),
		@ConfirmNum = NULLIF(@ConfirmNum,''),
		@SalesCtrctNum = NULLIF(@SalesCtrctNum,''),
		@AddedToGIS = NULLIF(@AddedToGIS,''),
		@EnteredOnHH = NULLIF(@EnteredOnHH,''),
		@SourceFunction = NULLIF(@SourceFunction,''),
		@RBRDate = NULLIF(@RBRDate,'')


	INSERT INTO Credit_Card_Void_Transaction
		(Authorization_Number,
		 Credit_Card_Type_Id,
		 Credit_Card_Number,
		 Last_Name,
		 First_Name,
		 Expiry,
		 Amount,
		 Collected_By,
		 Collected_At_Location_Id,
		 Terminal_ID,
		 Trx_Receipt_Ref_Num,
		 Trx_ISO_Response_Code,
		 Trx_Remarks,
		 Swiped_Flag,
		 Contract_Number,
		 Confirmation_Number,
		 Sales_Contract_Number,
		 Added_To_GIS,
		 Entered_On_Handheld,
		 [Function],
		 RBR_Date,
		 System_Datetime)
	VALUES  (@AuthNum,
		 @CCTypeId,
		 @CCNum,
		 @LastName,
		 @FirstName,
		 @CCExpiry,
		 Convert(Decimal(9,2), @Amount),
		 @CollectedBy,
		 Convert(SmallInt, @CollectedAtLocId),
		 @TerminalId,
		 @TrxReceiptNum,
		 @TrxISORespCode,
		 @TrxRemarks,
		 Convert(Bit, @SwipedFlag),
		 Convert(Int, @ContractNum),
		 Convert(Int, @ConfirmNum),
		 Convert(Int, @SalesCtrctNum),
		 Convert(Bit, @AddedToGIS),
		 Convert(Bit, @EnteredOnHH),
		 @SourceFunction,
		 Convert(Datetime, @RBRDate),
		 GetDate())

	RETURN @@ROWCOUNT




GO
