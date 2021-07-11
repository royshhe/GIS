USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[IsFirstDirectBillPosting]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.IsFirstDirectBillPosting    Script Date: 2/18/99 12:12:21 PM ******/
/****** Object:  Stored Procedure dbo.IsFirstDirectBillPosting    Script Date: 2/16/99 2:05:43 PM ******/
/*
PURPOSE: To check if there is record in Business Transaction and Ar Transaction table for the given contract and customer.
	        If so return 0 and 1 otherwise.
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[IsFirstDirectBillPosting]
	@ContractNum Varchar(10),
	@CustomerCode Varchar(35)
AS
/* Is First Posting if SELECT returns 0 */
Declare @ret integer
Declare @nContractNum Integer
Select @nContractNum = Convert(int, NULLIF(@ContractNum, ''))

Select @ret =
	(SELECT
		Count(*)
	FROM
		Business_Transaction BT, AR_Transactions ART
	WHERE
		BT.Contract_Number = @nContractNum
		And ART.Customer_Account = @CustomerCode
		And BT.Business_Transaction_ID = ART.Business_Transaction_ID)
If @ret = 0
	Select @ret = 1
Else
	Select @ret = 0
Select @ret
	
RETURN @ret














GO
