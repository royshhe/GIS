USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetManualConAll]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/* 
** Author: Linda Qu 							**
** Date: Nov 23, 1999                                         		**
** Purpose:  List manual Contract transaction for specified location   	**
**           on specified RBR date                            		**
** Parameter: @SearchRBRDate-                                  		**
**            @SearchCCardType   N/A                           		**
**           
*/
CREATE PROCEDURE [dbo].[GetManualConAll]
	@SearchDate varchar(20)
	
AS

SET NOCOUNT ON

--declare @SearchCCardType varchar(20)

DECLARE @SearchRBRDate datetime

SELECT @SearchRBRDate= convert (datetime, @SearchDate)

PRINT ' ***********Manual Contract Transaction Report *************'
PRINT ' **RBR Date:'+@SearchDate+'                  Location: All Location **'
PRINT ' **Report DateTime:' + CONVERT(VARCHAR(20),GETDATE())+'                    **'
PRINT ''
SELECT
'Loc'=loc.Location,--cpi.collected_at_location_id,
'Card'=cc.Credit_Card_type_id,
'Type'=br.transaction_type,
'DocNo'=br.contract_number, 
--'Foreign#'=con.foreign_contract_number,
'TranType'=CASE 
               WHEN con.status='VD' AND br.Transaction_Description = 'Check In'
		   THEN 'Void'
		   ELSE br.Transaction_Description
           END,
'Time'=br.Transaction_Date,
--'OperatorId'=br.User_ID,
'Amount'=cpi.Amount
FROM
contract_payment_item cpi,
credit_card_payment ccp,
credit_card cc,
Business_transaction br, 
Contract con,
Location loc

WHERE
    cpi.payment_type='Credit Card'
and cpi.copied_payment=0
and cpi.rbr_date=@SearchDate
--and cpi.collected_at_location_id=@SearchLocId
and cpi.collected_at_location_id=loc.location_id
and ccp.contract_number=cpi.contract_number
and ccp.sequence=cpi.sequence
and ccp.terminal_id is null
and cc.credit_card_key=ccp.credit_card_key 
and cc.credit_card_type_id in ('MCD','AMX','DC','JCB','VSA')    --@SearchCCardType
and br.business_transaction_id=cpi.business_transaction_id
and con.contract_number=cpi.contract_number


ORDER BY cpi.collected_at_location_id,cc.credit_card_type_id, br.contract_number
compute count(cpi.amount), sum(cpi.amount) by cpi.collected_at_location_id,cc.credit_card_type_id


SET NOCOUNT OFF
GO
