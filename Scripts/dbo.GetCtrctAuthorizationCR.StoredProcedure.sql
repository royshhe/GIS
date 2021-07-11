USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctAuthorizationCR]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: To retrieve the credit card authorization for a contract
MOD HISTORY:
Name	Date        	Comments
CPY	3/08/99 	- cpy modified - format Authorized_On before returning 
Don K 	Mar 10 1999 	- Added CCSeqNum
CPY	10/22/99 	- do nullif outside of SQL statements 
CPY	Jan 12 2000	- Added Trx columns to be returned
			- Added @FromPrintFlag param to indicate how to return the swiped flag
			- Changed swiped flag field to return 'M' or 'S' depending on 
			  whether transaction was processed via Eigen

*/
CREATE PROCEDURE [dbo].[GetCtrctAuthorizationCR]
	@CtrctNum	VarChar(10), 
	@FromPrintFlag	Char(1) = '0'
AS

DECLARE	@iCtrctNum Int
	SELECT @iCtrctNum = CONVERT(Int, NULLIF(@CtrctNum,''))

	SELECT
		'Authorization',
		CCA.Authorized_At_Location_ID,
		CC.Credit_Card_Type_ID,
		CC.Credit_Card_Number,
		CC.Short_Token,
		CC.Last_Name,
		CC.First_Name,
		CC.Expiry,
		CC.Customer_ID,
		CCA.Amount_Authorized,
		CCA.Trx_Receipt_Ref_Num, 
		CCA.Authorization_Number,
		Convert(char(1),CCA.Collected_Flag),
		CASE @FromPrintFlag
			-- if called from print, return 'M','S', or ''
			WHEN '1' THEN 	(SELECT	CASE
						-- suppress M/S if not processed via Eigen;
						-- if no terminal id, then the CC transaction was 
						-- not processed via Eigen
						WHEN CCA.Terminal_Id IS NULL THEN ''  
						WHEN CCA.Swiped_Flag = 0 THEN 'M'
						WHEN CCA.Swiped_Flag = 1 THEN 'S'
						ELSE ''	-- default
					END)
			-- else just return the swiped flag
			ELSE Convert(char(1), CCA.Swiped_Flag)
		END as Swiped_Flag,	
		CCA.Terminal_ID,
		CCA.Authorized_By,
		Convert(Varchar(20), CCA.Authorized_On, 113),
		CCA.Contract_Billing_party_ID,
		CCA.Sequence,
		CC.Sequence_Num, 
		CCA.Trx_ISO_Response_Code, 
		CCA.Trx_Remarks,
		'Auth Only' as Transaction_Type
	FROM	Credit_Card CC Inner Join		Credit_Card_Authorization CCA
				On CC.Credit_Card_Key = CCA.Credit_Card_Key   
		Inner Join	Renter_Primary_Billing RPB
				On CCA.Contract_Number =RPB.Contract_Number
	WHERE	CCA.Contract_Number = @iCtrctNum
	AND	RPB.Contract_Number = @iCtrctNum
	AND	RPB.Contract_Billing_Party_ID = -1
--	AND 	CCA.Credit_Card_Key = CC.Credit_Card_Key

	RETURN @@ROWCOUNT
GO
