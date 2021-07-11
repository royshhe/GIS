USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateSalesAccSaleCCPayment]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.CreateSalesAccSaleCCPayment    Script Date: 2/18/99 12:12:13 PM ******/
/****** Object:  Stored Procedure dbo.CreateSalesAccSaleCCPayment    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateSalesAccSaleCCPayment    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateSalesAccSaleCCPayment    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Sales_Accessory_CrCard_Payment table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateSalesAccSaleCCPayment]
	@SalesContractNumber	VarChar(20),
	@CCKey			Varchar(10),
	@AuthNumber		Varchar(20),
	@SwipedFlag		Char(1),
	@TerminalID		VarChar(20),
	@TrxReceiptRefNum	Varchar(20),
	@TrxISORespCode		Varchar(2),
	@TrxRemarks		Varchar(90)
AS
	/* 4/22/99 - cpy bug fix - apply nullif check to terminal_id before insert
				- removed params CCTypeId,CC#,Lname,Fname,Expiry;
				  replaced with @CCKey */
	/* 6/22/99 - added Trx params for insert
		   - apply NULLIF check */

	INSERT INTO Sales_Accessory_CrCard_Payment
		(
		Sales_Contract_Number,
		Credit_Card_Key,
		Authorization_Number,
		Swiped_Flag,
		Terminal_ID,
		Trx_Receipt_Ref_Num,
		Trx_ISO_Response_Code,
		Trx_Remarks)
	VALUES
		(
		Convert(int, NULLIF(@SalesContractNumber,'')),
		Convert(int, NULLIF(@CCKey,'')),
		@AuthNumber,
		Convert(bit,@SwipedFlag),
		NULLIF(@TerminalID,''),
		NULLIF(@TrxReceiptRefNum,''),
		NULLIF(@TrxISORespCode,''),
		NULLIF(@TrxRemarks,''))
RETURN 1
GO
