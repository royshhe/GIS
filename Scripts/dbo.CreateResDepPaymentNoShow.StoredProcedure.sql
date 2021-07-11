USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateResDepPaymentNoShow]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
PURPOSE: To insert a record into Reservation_Dep_Payment table.
MOD HISTORY:
Name    Date        Comments
 */

-- Don K - Jun 22 1999 - Added Business_transaction_id
CREATE PROCEDURE [dbo].[CreateResDepPaymentNoShow]
	@ConfirmNum 	Varchar(10),
	@CollectedOn 	Varchar(24),
	@PaymentType 	Varchar(20),
	@Amount 	Varchar(10),
	@CollectedBy 	Varchar(20),
	@RBRDate 	Varchar(24),
	@Forfeited 	Varchar(1),
	@Refunded	VarChar(1),
	@LocationId	VarChar(10),
	@BusTrxId	Varchar(11)
AS
Declare @lastSeq int
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
		 Refunded,
		 Collected_At_Location_ID,
		 Business_Transaction_ID
		)
	VALUES	(CONVERT(Int, NULLIF(@ConfirmNum, '')),
		 Convert(Datetime, NULLIF(@CollectedOn,'')),
		 (@lastSeq+1),	
		 NULLIF(@PaymentType,''),
		 CONVERT(Decimal(9, 2), NULLIF(@Amount, '')),
		 NULLIF(@CollectedBy,''),
		 Convert(Datetime, NULLIF(@RBRDate,'')),
		 Convert(Bit, NULLIF(@Forfeited,'')),
		 Convert(Bit, NULLIF(@Refunded,'')),
		 Convert(SmallInt, NULLIF(@LocationId, '')),
		 Convert(int, NULLIF(@BusTrxID, ''))
		)
	RETURN @@ROWCOUNT
GO
