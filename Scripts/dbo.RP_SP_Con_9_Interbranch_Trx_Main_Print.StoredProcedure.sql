USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_9_Interbranch_Trx_Main_Print]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE procedure [dbo].[RP_SP_Con_9_Interbranch_Trx_Main_Print]
(
	@paramStartDate varchar(20) = '01 jun 2003',
	@paramEndDate varchar(20) = '23 jun 2003',
	@paramOwningCompany_id varchar(10),
	@paramPrintFrom varchar(10)
)
AS
-- convert strings to datetime

DECLARE 	@startDate datetime,
		@endDate datetime,
		@owningCompanyID int,
		@printFrom int

SELECT	@startDate	= CONVERT(datetime, '00:00:00 ' + @paramStartDate),
	@endDate	= CONVERT(datetime, '23:59:59 ' + @paramEndDate)


if @paramOwningCompany_id = '*'
	BEGIN
		SELECT @owningCompanyID='0'
        END
else
	BEGIN
		SELECT @owningCompanyID = convert(int, @paramOwningCompany_id)
	END 

SELECT @printFrom = convert(int, @paramPrintFrom)


select distinct r1.contract_number
	
from
RP_Con_9_Interbranch_Data_L1 r1
--left join
--RP_Con_5_Interbranch_Deposit_Refund_SB_L1_Base_1 r2
--on r1.business_transaction_id = r2.business_transaction_id
where r1.Contract_number >= @printFrom 
and r1.rbr_date between @startDate and @endDate
and (	
	   ( @paramOwningCompany_id = '*' or r1.PULocOCID = @owningCompanyID) 
	or (@paramOwningCompany_id = '*' or r1.DOLocOCID = @owningCompanyID)
	or ( @paramOwningCompany_id = '*' or r1.VehOCID = @owningCompanyID)
 )

order by r1.contract_number asc
GO
