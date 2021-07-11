USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetManualAll]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/* 
** Author: Linda Qu 							**
** Date: Nov 23, 1999                                         		**
** Purpose:  List 3 types of manual transaction together in one report  **
**           for all location on specified RBR date,   	                **
**           This report will also summary the amount for each type     **
**           of credit card  at each location                           **
** Parameter: @SearchDate - '9 Dec 1999'                      		**
**           
*/
CREATE PROCEDURE [dbo].[GetManualAll]
	@SearchDate varchar(20)
	
AS

SET NOCOUNT ON

DECLARE @SearchRBRDate datetime
declare @CompanyCode int  --remove hardcode code
select @CompanyCode=Code from Lookup_Table where Category = 'BudgetBC Company'

SELECT @SearchRBRDate= convert (datetime, @SearchDate)

PRINT ' ****************  Manual Transaction Report *************'
PRINT ' **RBR Date:'+@SearchDate+'                  Location: All Location **'
PRINT ' **Report DateTime:' + CONVERT(VARCHAR(20),GETDATE())+'                    **'
PRINT ''
-- Contract type transaction
SELECT
'Loc'=loc.Location,--cpi.collected_at_location_id,
'Card'=cc.Credit_Card_type_id,
'Type'=br.transaction_type,
'DocNo'=br.contract_number, 
'TranType'=CASE 
               WHEN con.status='VD' AND br.Transaction_Description = 'Check In'
		   THEN 'Void'
		   ELSE br.Transaction_Description
           END,
'Time'=br.Transaction_Date,
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
and cpi.rbr_date=@SearchRBRDate
--and cpi.collected_at_location_id=@SearchLocId
and cpi.collected_at_location_id=loc.location_id
and loc.owning_company_id=@CompanyCode
and ccp.contract_number=cpi.contract_number
and ccp.sequence=cpi.sequence
and ccp.terminal_id is null
and cc.credit_card_key=ccp.credit_card_key 
and cc.credit_card_type_id in ('MCD','AMX','DC','JCB','VSA')    --@SearchCCardType
and br.business_transaction_id=cpi.business_transaction_id
and con.contract_number=cpi.contract_number

UNION
----Reservation Type Transaction 
SELECT
'Loc'=loc.location,
'Card'=cc.Credit_Card_type_id,
'Type'=br.transaction_type,
'DocNo'=br.confirmation_number, 
'TranType'=br.Transaction_Description,
'Time'=br.Transaction_Date,
'Amount'=cpi.Amount
FROM
reservation_dep_payment cpi,
reservation_cc_dep_payment ccp,
credit_card cc,
Business_transaction br, 
Reservation res,
Location loc

WHERE
    cpi.payment_type='Credit Card'
and cpi.rbr_date=@SearchRBRDate
and cpi.collected_at_location_id=loc.location_id
and loc.owning_company_id=@CompanyCode
and ccp.confirmation_number=cpi.confirmation_number
and ccp.collected_on=cpi.collected_on
and ccp.terminal_id is null
and cc.credit_card_key=ccp.credit_card_key 
and cc.credit_card_type_id in ('MCD','AMX','DC','JCB','VSA')    --@SearchCCardType
and br.business_transaction_id=cpi.business_transaction_id
and res.confirmation_number=cpi.confirmation_number

UNION
--  Sales Accessory Type of Transaction 
SELECT
'Loc'=loc.Location,
'Card'=cc.Credit_Card_type_id,
'Type'=br.transaction_type,
'DocNo'=br.confirmation_number, 
'TranType'=br.Transaction_Description,
'Time'=br.Transaction_Date,
'Amount'=cpi.Amount
FROM
sales_accessory_sale_payment cpi,
sales_accessory_crcard_payment ccp,
credit_card cc,
Business_transaction br,
Location loc

WHERE
    cpi.payment_type='Credit Card'
and cpi.rbr_date=@SearchRBRDate
and ccp.sales_contract_number=cpi.sales_contract_number
and ccp.terminal_id is null
and cc.credit_card_key=ccp.credit_card_key 
and cc.credit_card_type_id in ('MCD','AMX','DC','JCB','VSA') --@SearchCCardType
and br.business_transaction_id=cpi.business_transaction_id
and br.location_id=loc.location_id
and loc.owning_company_id=@CompanyCode
--  Results sorted by
ORDER BY Loc.Location,cc.credit_card_type_id --, br.contract_number
compute count(cpi.amount), sum(cpi.amount) 
by loc.location,cc.credit_card_type_id


SET NOCOUNT OFF


GO
