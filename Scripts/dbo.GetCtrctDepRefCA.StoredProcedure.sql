USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctDepRefCA]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.GetCtrctDepRefCA    Script Date: 2/18/99 12:12:20 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctDepRefCA    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctDepRefCA    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetCtrctDepRefCA    Script Date: 11/23/98 3:55:33 PM ******/
/*
PURPOSE: 	To retrieve a list of cash payment (deposit, refund) details for a contract 
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCtrctDepRefCA]
	@CtrctNum	VarChar(10),
	@FromPrintFlag	Char(1) = '0'
AS
	/* 3/08/99 - cpy modified - format Collected_On before returning */
	/* 3/17/99 - np - removed DISTINCT */
	/* 10/14/99 - do type conversion and nullif outside of SQL statement */
DECLARE	@iCtrctNum Int
	SELECT	@iCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,''))
	SELECT	
		'Transaction_Type' =
			Case
				When CPI.Amount < 0 Then
					'Refund'
				Else
					'Deposit'
			End,
		CPI.Collected_At_Location_Id,
		CP.Cash_Payment_Type,
		CP.Foreign_Currency_Amt_Collected,
		CP.Currency_ID,

		CP.Exchange_Rate,
		ABS(CPI.Amount),
		CP.Identification_Number,

	   CP.Trx_Receipt_Ref_Num,
		CP.Authorization_Number,
		CASE @FromPrintFlag
			-- if called from print, return 'M','S', or ''
			WHEN '1' THEN 	(SELECT	CASE
						-- suppress M/S if not processed via Eigen;
						-- if no terminal id, then the CC transaction was 
						-- not processed via Eigen
						WHEN CP.Terminal_Id IS NULL THEN ''  
						WHEN CP.Swiped_Flag = 0 THEN 'M'
						WHEN CP.Swiped_Flag = 1 THEN 'S'
						ELSE ''	-- default
					END)
			-- else just return the swiped flag
			ELSE Convert(char(1), CP.Swiped_Flag)
		END,	
		Terminal_ID,

		CPI.Collected_By,
		Convert(Varchar(20), CPI.Collected_On, 113),
		CP.Trx_ISO_Response_Code,
		CP.Trx_Remarks,
		Convert(char(1),CPI.Copied_Payment) ResDeposit
		
	FROM	Cash_Payment CP,
		Contract_Payment_Item CPI
	WHERE	CP.Contract_Number = @iCtrctNum
	AND	CPI.Contract_Number = @iCtrctNum
	AND	CPI.Sequence = CP.Sequence
	RETURN @@ROWCOUNT

GO
