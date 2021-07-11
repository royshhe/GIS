USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateResCCDepPayment]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
PURPOSE: To insert a record into Reservation_CC_Dep_Payment table.
MOD HISTORY:
Name    Date        Comments
 */

-- Don K - Apr 15 1999 - Convert blank to null in Terminal ID
CREATE PROCEDURE [dbo].[CreateResCCDepPayment] --'1544775','2009-12-08 12:55','1149214','152321','1','EIGEN','002001001250','00','Purchase   EIGEMVC4  APPROVED  00-001 S-00200100'
	@ConfirmNum	Varchar(10),
	@CollectedOn	Varchar(24),
	@CCKey		Varchar(10),
	@AuthNum	Varchar(12),
	@SwipedFlag	char(1),
	@TerminalID	Varchar(20),
	@TrxReceiptRefNum 	Char(20),
	@TrxISORespCode		Char(2),
	@TrxRemarks		Varchar(90)
AS
	/* 6/22/99 - added Trx params for insert */

DECLARE @CreditCardKey Int
Declare @lastSeq int 
declare @RefundedReceiptRefNum varchar(20)
	
/*	SELECT @CreditCardKey =
		(SELECT	Credit_Card_Key
	 	 FROM	Credit_Card
	 	 WHERE	Credit_Card_Type_ID = @CCType
		 AND 	Credit_Card_Number = @CCNumber
		 AND 	Last_Name = @LastName
		 AND 	First_Name = @FirstName)	
*/
	SELECT @CreditCardKey = Convert(Int, NULLIF(@CCKey,''))

	-- get the current max sequence number
	Select 	@lastSeq = Max(Sequence)
	From	Reservation_CC_Dep_Payment
	Where	Confirmation_Number = @ConfirmNum and Collected_On=Convert(Datetime, NULLIF(@CollectedOn,''))


	If @lastSeq IS NULL
	Begin
		Select @lastSeq = -1
	End
	
	if CHARINDEX('@',@TrxRemarks)<>0 
		begin
			select @RefundedReceiptRefNum=substring(@TrxRemarks,CHARINDEX('@',@TrxRemarks)+1,20)
			select @TrxRemarks=substring(@TrxRemarks,0,CHARINDEX('@',@TrxRemarks))
		end
	  else
		begin
			select @RefundedReceiptRefNum=''
		end

	INSERT INTO Reservation_CC_Dep_Payment
	       (Confirmation_Number,
		Collected_On,
		Sequence,
		Credit_Card_Key,
		Authorization_Number,
		Swiped_Flag,

		Terminal_ID,
		Trx_Receipt_Ref_Num,
		Trx_ISO_Response_Code,
		Trx_Remarks)
	VALUES (Convert(Int, NULLIF(@ConfirmNum,'')),
		Convert(Datetime, NULLIF(@CollectedOn,'')),
		(@lastSeq+1),	
		@CreditCardKey,
		NULLIF(@AuthNum,''),
		Convert(bit,@SwipedFlag),
		NULLIF(@TerminalID, ''),
		NULLIF(@TrxReceiptRefNum,''),
		NULLIF(@TrxISORespCode, ''),
		NULLIF(@TrxRemarks, ''))

	if len(ltrim(@RefundedReceiptRefNum))>0 
		update Reservation_Dep_Payment set refunded=1,Refunded_Receipt_Ref_Num=@RefundedReceiptRefNum
			from Reservation_Dep_Payment RDP inner 
			join Reservation_CC_Dep_Payment RCDP
				on RDP.confirmation_number=RCDP.confirmation_number 
					and rdp.Collected_On=RCDP.Collected_On and 
					rdp.sequence=rcdp.sequence
			WHERE	RDP.Confirmation_Number = @ConfirmNum
					AND	RCDP.Trx_Receipt_Ref_Num=ltrim(@RefundedReceiptRefNum)
					and rdp.collected_on=RCDP.Collected_On
					and rdp.sequence=rcdp.sequence
					--AND	rdp.Forfeited = 0
					AND	rdp.Refunded = 0


	RETURN @@ROWCOUNT
GO
