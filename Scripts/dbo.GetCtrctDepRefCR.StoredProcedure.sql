USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctDepRefCR]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: Retrieve CC deposit details for a contract 
MOD HISTORY:
Name	Date		Comment
CPY 	3/08/99 	- format Collected_On before returning 
Don K 	Mar 10 1999 	Added CCSeqNum
CPY 	6/22/99 	- added new Trx columns; removed distinct 
CPY 	10/14/99 	- do type conversion and nullif outside of SQL statement 
CPY	Dec 17 1999	- added @TransTypeFlag param; if @TransTypeFlag is NULL or '0'
			  then print the word 'Deposit' for amount; else if @TransTypeFlag
			  is '1' then print the word 'Purchase' for display on the ctrct receipt
CPY	Dec 22 1999	- if @TransTypeFlag is NULL or '0', print word 'Refund'; else if 
			  @TransTypeFlag is '1' then print word 'Return' for disply on ctrct receipt
CPY	Jan 10 2000	- Renamed @TransTypeFlag to @FromPrintFlag; if call was initiated from
			  contract print, @FromPrintFlag = 1; else 0 or NULL
			- Changed swiped flag field to return 'M' or 'S' depending on 
			  whether transaction was processed via Eigen
*/
CREATE PROCEDURE [dbo].[GetCtrctDepRefCR] -- 1681574
	@CtrctNum	VarChar(10),
	@FromPrintFlag	Char(1) = '0'
AS
DECLARE	@iCtrctNum Int
DECLARE	@sDepositDesc Varchar(10)
DECLARE @sRefundDesc Varchar(10)

	-- if @FromPrintFlag = 1, then we want to return the word 'Purchase'
	-- instead of 'Deposit'
	SELECT	@FromPrintFlag = ISNULL(NULLIF(@FromPrintFlag,''), '0'),
		@iCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,'')),
		@sDepositDesc = CASE @FromPrintFlag
			WHEN '1' THEN 'Purchase'
			ELSE 'Deposit'
		END,
		@sRefundDesc = CASE @FromPrintFlag
			WHEN '1' THEN 'Return'
			ELSE 'Refund'
		END

	SELECT	
		'Transaction_Type' =
			Case
				When CPI.Amount < 0 Then
					@sRefundDesc
				Else
					@sDepositDesc
			End,
		CPI.Collected_At_Location_Id,
		CC.Credit_Card_Type_ID,
		CC.Credit_Card_Number,
		CC.Short_Token,
		CC.Last_Name,
		CC.First_Name,
		CC.Expiry,
		ABS(CPI.Amount),
		CCP.Trx_Receipt_Ref_Num,
		CCP.Authorization_Number,
		CASE @FromPrintFlag
			-- if called from print, return 'M','S', or ''
			WHEN '1' THEN 	(SELECT	CASE
						-- suppress M/S if not processed via Eigen;
						-- if no terminal id, then the CC transaction was 
						-- not processed via Eigen
						WHEN CCP.Terminal_Id IS NULL THEN ''  
						WHEN CCP.Swiped_Flag = 0 THEN 'M'
						WHEN CCP.Swiped_Flag = 1 THEN 'S'
						ELSE ''	-- default
					END)
			-- else just return the swiped flag
			ELSE Convert(char(1), CCP.Swiped_Flag)
		END,	
		Terminal_ID,
		CPI.Collected_By,
		Convert(Varchar(20), CPI.Collected_On, 113),
		CC.Sequence_Num,
		CCP.Trx_ISO_Response_Code,
		CCP.Trx_Remarks,
		Convert(char(1), CPI.Copied_payment) ResDeposit
		
	 
	FROM	Credit_Card CC Inner Join Credit_Card_Payment CCP 
			On   CC.Credit_Card_Key= CCP.Credit_Card_Key
        Inner Join 	Contract_Payment_Item CPI 
            On  CCP.Contract_Number=CPI.Contract_Number   And CCP.Sequence  = CPI.Sequence 
		Left Outer Join 	Credit_Card_Type CCT
			On  CC.Credit_Card_Type_ID=CCT.Credit_Card_Type_ID 
	WHERE	CCP.Contract_Number = @iCtrctNum
--	AND	CPI.Contract_Number = CCP.Contract_Number
--	AND	CPI.Sequence = CCP.Sequence
--	AND	CCP.Credit_Card_Key = CC.Credit_Card_Key
--	AND    CC.Credit_Card_Type_ID=CCT.Credit_Card_Type_ID 

	RETURN @@ROWCOUNT


--select * from	  Contract_Payment_Item where	Copied_payment<>0
GO
