USE [GISData]
GO
/****** Object:  View [dbo].[RP_Con_4_Location_EOD_Reconciliation_L1_Base_POReq]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[RP_Con_4_Location_EOD_Reconciliation_L1_Base_POReq]
AS
SELECT    distinct dbo.Contract.Contract_Number, dbo.Reservation.CID,dbo.bgt_armaster.po_num_reqd_flag--, dbo.Prepayment.Issuer_ID
FROM         dbo.bgt_armaster RIGHT OUTER JOIN
                      (
						select contract_number,payment_type,issuer_id
						from dbo.Prepayment
						group by contract_number,payment_type,issuer_id
						having sum(foreign_currency_amt_collected)<>0) Prepayment 
										ON dbo.bgt_armaster.customer_code = Prepayment.Issuer_ID RIGHT OUTER JOIN
                      dbo.Reservation INNER JOIN
                      dbo.Contract ON dbo.Reservation.Confirmation_Number = dbo.Contract.Confirmation_Number ON Prepayment.Contract_Number = dbo.Contract.Contract_Number
GO
