USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateResDepPayment]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
PURPOSE: To insert a record into Reservation_Dep_Payment table.
MOD HISTORY:
Name    Date        Comments
 */
-- Don K - Jun 22 1999 - Added business_transaction_id
-- Don K - Jul 16 1999 - Don't update BusTrxId on existing payments
CREATE PROCEDURE [dbo].[CreateResDepPayment]
	@ConfirmNum 	Varchar(10),
	@CollectedOn 	Varchar(24),
	@PaymentType 	Varchar(20),
	@Amount 	Varchar(10),
	@CollectedBy 	Varchar(20),
	@RBRDate 	Varchar(24),
	@Forfeited 	Varchar(1),
	@LocationID	Varchar(10),
	@BusTrxID	Varchar(11)
AS
DECLARE @dAmount Decimal(9,2),
		@dDepAmount decimal(9,2)
DECLARE @iConfirmNum Int
Declare @lastSeq int, 
	@iBusTrxID int
	SELECT 	@dAmount = Convert(Decimal(9,2), NULLIF(@Amount,'')),
		@iConfirmNum = Convert(Int, NULLIF(@ConfirmNum,'')),
		@iBusTrxID = Convert(int, NULLIF(@BusTrxID, ''))

	-- get the current max sequence number
	Select 	@lastSeq = Max(Sequence)
	From	Reservation_Dep_Payment
	Where	Confirmation_Number = @ConfirmNum and Collected_On=Convert(Datetime, NULLIF(@CollectedOn,''))


	If @lastSeq IS NULL
	Begin
		Select @lastSeq = -1
	End

	INSERT INTO Reservation_Dep_Payment
		(Confirmation_Number,
		 Collected_On,
		 Sequence,
		 Payment_Type,
		 Amount,
		 Collected_By,
		 RBR_Date,
		 Forfeited,
		 Collected_At_Location_ID,
		 Business_Transaction_ID)
	VALUES	(@iConfirmNum,
		 Convert(Datetime, NULLIF(@CollectedOn,'')),
		 (@lastSeq+1),	
		 NULLIF(@PaymentType,''),
		 @dAmount,
		 NULLIF(@CollectedBy,''),
		 Convert(Datetime, NULLIF(@RBRDate,'')),

		 Convert(Bit, NULLIF(@Forfeited,'')),
		 Convert(smallint, @LocationID),
		 @iBusTrxID)
	/* if giving a refund, update refund flag
	   of the positive deposit entries  */
	--Move to [CreateResCCDepPayment] to set the flag
--	IF @dAmount < 0
--		UPDATE	Reservation_Dep_Payment
--		SET	Refunded = 1
--		WHERE	Confirmation_Number = @iConfirmNum
--			AND	Amount >= 0	and amount=abs(@damount)
--			AND	Forfeited = 0
--			AND	Refunded = 0

	RETURN @@ROWCOUNT
GO
