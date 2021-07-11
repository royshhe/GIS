USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_23_BToll_Payment]    Script Date: 2021-07-10 1:50:50 PM ******/
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

CREATE Procedure [dbo].[RP_SP_Acc_23_BToll_Payment] --'2012-12-01', '2012-12-10'
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



SELECT     '' as TicketNumber,Issuer,  Issue_Date, ViolationCharge, AdminCharge, Contract_Number, Billing_Method, License_Number, RBR_Date
--select *
FROM         dbo.Bridge_Toll_vw 
where RBR_Date between @startDate and @endDate	
order by Contract_Number,Issue_Date

RETURN @@ROWCOUNT







GO
