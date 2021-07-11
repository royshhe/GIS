USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_25_Cert_Voucher_Summary]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
PROCEDURE NAME: RP_SP_Acc_20_PTicket_Payment
PURPOSE: Select all the information needed for Parking Ticket Payment

AUTHOR:	Roy He
DATE CREATED: 2008/02/26
USED BY: Parking Ticket Payment
MOD HISTORY:
Name 		Date		Comments
*/

CREATE Procedure [dbo].[RP_SP_Acc_25_Cert_Voucher_Summary] --'2011-10-01', '2011-10-23'
(
	@paramStartDate varchar(20) = '2008-01-01',
	@paramEndDate varchar(20) = '2008-01-10'
)
AS
-- convert strings to datetime
DECLARE
	@startDate datetime,
	@endDate datetime

SELECT	
	@startDate	= CONVERT(datetime, @paramStartDate),
	@endDate	= CONVERT(datetime, @paramEndDate)	

select	(case when Brac.rank is not null 
				then Brac.Rank
				else Certificate.Rank
		end) RowNumber,	
		Brac.contract_number vContractNumber,
		Brac.Payment_Type vPaymentType,
		Brac.Currency_ID vCurrencyID,
		Brac.Exchange_Rate vExchangeRate,
		Brac.Foreign_Currency_Amt_Collected vForeignCurrencyAmtCollected,
		Brac.Amount vAmount,
		Brac.RBR_Date vRBRDate,
		Certificate.contract_number cContractNumber,
		Certificate.Payment_Type cPaymentType ,
		Certificate.Currency_ID cCurrencyID,
		--Certificate.Exchange_Rate cExchangeRate,
		'' as cExchangeRate,
		Certificate.Foreign_Currency_Amt_Collected cForeignCurrencyAmtCollected,
		Certificate.Amount cAmount,
		Certificate.RBR_Date cRBRDate

from 
(select rank=count(*),v1.contract_number,v1.Payment_Type,v1.Currency_ID,v1.Exchange_Rate,v1.Foreign_Currency_Amt_Collected,v1.Amount,v1.RBR_Date
	from 
		(
SELECT     dbo.Contract_Credit_Card_Payment_vw.Contract_Number as contract_number ,
			dbo.Contract_Credit_Card_Payment_vw.Credit_Card_Type as Payment_Type,
			'' as Currency_ID ,'' as Exchange_Rate,
			dbo.Contract_Credit_Card_Payment_vw.Amount as Foreign_Currency_Amt_Collected, 
			'' AS Amount,--			dbo.Contract_TnM_vw.Amount AS Amount, 
            dbo.Contract_Credit_Card_Payment_vw.RBR_Date  as RBR_Date
FROM         dbo.Contract_Credit_Card_Payment_vw 
--				INNER JOIN
--                      dbo.Contract_TnM_vw ON dbo.Contract_Credit_Card_Payment_vw.Contract_Number = dbo.Contract_TnM_vw.Contract_Number
			where rbr_date  between @startDate and @endDate
				and credit_card_type in (select credit_card_type from credit_card_type where maestro_code in ('BU','BL','BO','BI','GE','CP'))-- ('BML Leasing','International Brac','GE Capital','One Trip Voucher','PH&H')
			) v1,

		(SELECT     dbo.Contract_Credit_Card_Payment_vw.Contract_Number as contract_number ,
					dbo.Contract_Credit_Card_Payment_vw.Credit_Card_Type as Payment_Type,
					'' as Currency_ID ,'' as Exchange_Rate,
					dbo.Contract_Credit_Card_Payment_vw.Amount as Foreign_Currency_Amt_Collected, 
					'' AS Amount, 
                      dbo.Contract_Credit_Card_Payment_vw.RBR_Date  as RBR_Date
FROM         dbo.Contract_Credit_Card_Payment_vw 
--					INNER JOIN
--                      dbo.Contract_TnM_vw ON dbo.Contract_Credit_Card_Payment_vw.Contract_Number = dbo.Contract_TnM_vw.Contract_Number
			where rbr_date  between @startDate and  @endDate
				and credit_card_type in  (select credit_card_type from credit_card_type where maestro_code in ('BU','BL','BO','BI','GE','CP'))--('BML Leasing','International Brac','GE Capital','One Trip Voucher','PH&H')
			) v2

	where convert(varchar(10),v1.contract_number)+convert(varchar(10),v1.Foreign_Currency_Amt_Collected)>=convert(varchar(10),v2.contract_number)+convert(varchar(10),v2.Foreign_Currency_Amt_Collected)
	group by v1.contract_number,v1.Payment_Type,v1.Currency_ID,v1.Exchange_Rate,v1.Foreign_Currency_Amt_Collected,v1.Amount,v1.RBR_Date
	) BRAC full outer join

(select rank=count(*),c1.contract_number,c1.Payment_Type,c1.Currency_ID,c1.Exchange_Rate,c1.Foreign_Currency_Amt_Collected,c1.Amount,c1.RBR_Date
	from 
		(select   dbo.Contract_Prepayment_vw.Contract_Number as contract_number,
					Payment_Type,
					Currency_ID,
					Exchange_Rate,
					Foreign_Currency_Amt_Collected,
					'' as Amount,
					RBR_Date
			FROM         dbo.Contract_Prepayment_vw 
--					INNER JOIN
--                      dbo.Contract_TnM_vw ON dbo.Contract_Prepayment_vw.Contract_Number = dbo.Contract_TnM_vw.Contract_Number
			where dbo.Contract_Prepayment_vw.RBR_Date between @startDate and  @endDate
--					and dbo.Contract_Prepayment_vw.payment_type='Certificate'
				) c1,

		(select   dbo.Contract_Prepayment_vw.Contract_Number as contract_number,
					Payment_Type,
					Currency_ID,
					Exchange_Rate,
					Foreign_Currency_Amt_Collected,
					'' as Amount,
					RBR_Date
			FROM         dbo.Contract_Prepayment_vw 
--					INNER JOIN
--                      dbo.Contract_TnM_vw ON dbo.Contract_Prepayment_vw.Contract_Number = dbo.Contract_TnM_vw.Contract_Number
			where dbo.Contract_Prepayment_vw.RBR_Date between @startDate and  @endDate
--					and dbo.Contract_Prepayment_vw.payment_type='Certificate'
			) c2

	where convert(varchar(20),c1.contract_number)+c1.Payment_Type>=convert(varchar(20),c2.contract_number)+c2.Payment_Type
	group by c1.contract_number,c1.Payment_Type,c1.Currency_ID,c1.Exchange_Rate,c1.Foreign_Currency_Amt_Collected,c1.Amount,c1.RBR_Date
	) Certificate
	
	on Brac.rank=Certificate.rank
order by Rownumber
RETURN @@ROWCOUNT

GO
