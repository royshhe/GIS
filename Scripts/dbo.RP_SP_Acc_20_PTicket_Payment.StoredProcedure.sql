USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_20_PTicket_Payment]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
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

CREATE Procedure [dbo].[RP_SP_Acc_20_PTicket_Payment] --'2008-01-01', '2008-01-10'
(
	@paramStartDate varchar(20) = '2008-01-01',
	@paramEndDate varchar(20) = '2008-01-10',
	@paramIssuerID varchar(20) = '*'
)
AS
-- convert strings to datetime
DECLARE
	@startDate datetime,
	@endDate datetime

SELECT	
	@startDate	= CONVERT(datetime, @paramStartDate),
	@endDate	= CONVERT(datetime, @paramEndDate)	



SELECT     TicketNumber, PTicket_Issuer.Issuer, Issue_Date, ViolationCharge, AdminCharge, Contract_Number, Billing_Method, License_Number, RBR_Date
FROM         dbo.Parking_Ticket_vw PTicket
left outer join (select Code as Issuer_ID, Value as Issuer from Lookup_Table where category ='Parking Ticket Issuer') PTicket_Issuer     
		      On PTicket.Issuer=Pticket_Issuer.Issuer_ID
where RBR_Date between @startDate and @endDate	AND	(@paramIssuerID = "*" or @paramIssuerID = PTicket.Issuer)
order by PTicket_Issuer.Issuer, Issue_Date

RETURN @@ROWCOUNT




GO
