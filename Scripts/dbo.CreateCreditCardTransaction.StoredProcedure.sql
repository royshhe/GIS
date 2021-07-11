USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateCreditCardTransaction]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/*
PURPOSE: To insert a record into Credit_Card_Transaction table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateCreditCardTransaction]
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
	@TrxReceiptNum 	Char(20),
	@TrxISORespCode Char(2),
	@TrxRemarks 	Varchar(90),
	@SwipedFlag 	Char(1),
	@ContractNum 	Varchar(10),
	@ConfirmNum 	Varchar(10),
	@SalesCtrctNum 	Varchar(10),
	@AddedToGIS 	Char(1),
	@EnteredOnHH 	Char(1),
	@SourceFunction Varchar(20),
	@RBRDate 	Varchar(24),
	@ShortToken	Varchar(20)
AS

	/* 8/05/99 - log credit card transaction completed through Eigen */

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
		@RBRDate = NULLIF(@RBRDate,''),
		@ShortToken = NULLIF(@ShortToken,'')
		
		--If receipt ref num is null, create one
		Select  @TrxReceiptNum=isnull(@TrxReceiptNum,  convert(varchar,convert(bigint, RAND( (DATEPART(mi, GETDATE()) * 600000 )+ (DATEPART(ss, GETDATE()) * 1000 )+ DATEPART(ms, GETDATE()) )*1000000000000)))  

	INSERT INTO Credit_Card_Transaction
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
		 System_Datetime,
		 Short_Token)
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
		 GetDate(), 
		 @ShortToken)

	RETURN @@ROWCOUNT
GO
