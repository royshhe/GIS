USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocEODTotalExport]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








--------------------------------------------------------------------------------------------------------------------
--	Programmer:	Vivian Leung
--	Date:		27 Oct 2003
--	Details		Retrieve Location EOD Total for export
--	Modification:		Name:		Date:		Detail:
--
---------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[GetLocEODTotalExport]--'2016/10/06','2016/10/06'
(
	@paramStartBusDate datetime, --varchar(20) = '22 Apr 2001',
	@paramEndBusDate datetime --varchar(20) = '23 Apr 2001'
)
AS
declare @CompanyCode int  --remove hardcode code
select @CompanyCode=Code from Lookup_Table where Category = 'BudgetBC Company'


-- convert strings to datetime
DECLARE 	@startBusDate datetime,
		@endBusDate datetime

--SELECT	@startBusDate	= CONVERT(datetime, '00:00:00 ' + @paramStartBusDate),
--		@endBusDate	= CONVERT(datetime, '23:59:59 ' + @paramEndBusDate)	

--SELECT	@startBusDate	= CONVERT(datetime, @paramStartBusDate),
--		@endBusDate	= CONVERT(datetime,  @paramEndBusDate)	

SELECT	@startBusDate = @paramStartBusDate, @endBusDate = @paramEndBusDate	

select loc.rbr_date, loc.location,
	AMXTotal = case when AMXTotal is not null
			then AMXTotal
			else 0
			end,
	NovusTotal = case when NovusTotal is not null
			then NovusTotal
			else 0
			end,
	MCTotal= case when MCTotal is not null
			then MCTotal
			else 0
			end,
	VisaTotal= case when VisaTotal is not null
			then VisaTotal
			else 0
			end,
	debitCardTotal = case when debitCardTotal is not null
			then debitCardTotal
			else 0
			end,
	cashTotal= case when cashTotal is not null
			then cashTotal
			else 0
			end,
	usCashTotal= case when usCashTotal is not null
			then usCashTotal
			else 0
			end,
--	certTotal= case when certTotal is not null
--			then certTotal
--			else 0
--			end,
--	usCertTotal= case when usCertTotal is not null
--			then usCertTotal
--			else 0
--			end,
	ImbalanceAMXTotal= case when ImbalanceAMXTotal is not null
			then ImbalanceAMXTotal
			else 0
			end,
	ImbalanceNovusTotal = case when ImbalanceNovusTotal is not null
			then ImbalanceNovusTotal
			else 0
			end,
	ImbalanceMCTotal= case when ImbalanceMCTotal is not null
			then ImbalanceMCTotal
			else 0
			end,
	ImbalanceVisaTotal= case when ImbalanceVisaTotal is not null
			then ImbalanceVisaTotal
			else 0
			end,
	ManualAMXTotal= case when ManualAMXTotal is not null
			then ManualAMXTotal
			else 0
			end,
	ManualNovusTotal= case when ManualNovusTotal is not null
			then ManualNovusTotal
			else 0
			end,
	ManualMCTotal= case when ManualMCTotal is not null
			then ManualMCTotal
			else 0
			end,
	ManualVisaTotal= case when ManualVisaTotal is not null
			then ManualVisaTotal
			else 0
			end
from 
(select rbr_date, location, location_id 
	from rbr_date 
	cross join 
	(SELECT     location_id, location
		FROM         Location
		--WHERE     (Owning_Company_ID = @CompanyCode) AND (ResNet = 1) AND (Delete_Flag = 0) AND (GIS_Member = 1)
                Where Location.location in (	'B-01 YVR Airport',
						'B-02 YVR South Terminal',
--						'B-02A Helijet Terminal',
						'B-03 Downtown',
						--'B-04 Burrard',
						'B-05 Kingsway',
						--'B-06 North Vanc.',
						'B-08 Service Center',
						'B-10 Special Rentals',
						'B-11 Cruise Ship',
						--'B-20 PGAP',
--						'B-21 PGDT',
						--'B-22 PGADM',
--						'B-25 FSJAP',
--						'B-27 FSJDT',
						--'B-32 Calgary Head Office',
--						'B-33 FSJ Adm',
						'B-35 Richmond',
						'BC/Reznet',
						--'BC/Whistler',
						'B-39 Surrey',
						'B-40 Abbotsford Airport',
						'B-42 Chilliwack',
						'B-41 Abbotsford Downtown',
						'B-43 Production',
						'B-44 Langley',
						'B-45 Port Coquitlam',
						'B-47 Coquitlam',
						'B-07 Burnaby',	
						'B-46 Burnaby Production'--,
						--'B-03 Downtown Production'
						)
	) loc2
	where rbr_date between @startBusDate and @endBusDate		
) loc
left join
(select r.rbr_date, location_id,
	sum(case when credit_card_type = 'VISA' and transaction_type in ('automatic', 'Manual')
		then Purchase - refund 
		else 0
		end)	as VisaTotal,
	sum(case when credit_card_type = 'Master Card' and transaction_type in ('automatic', 'Manual')
		then Purchase - refund 
		else 0
		end)	as MCTotal,
	sum(case when credit_card_type = 'American Express' and transaction_type in ('automatic', 'Manual')
		then Purchase - Refund 
		else 0
		end)	as AMXTotal,
 	sum(case when (credit_card_type = 'Discover Novus' or credit_card_type = 'Diners/Enroute'or credit_card_type = 'Japan Carte Blanche') and transaction_type in ('automatic', 'Manual')
		then Purchase - refund 
		else 0
		end)	as NovusTotal,
	sum(case when credit_card_type = 'VISA' and transaction_type = 'Imbalance'
		then Purchase - refund 
		else 0
		end)	as ImbalanceVisaTotal,
	sum(case when credit_card_type = 'Master Card' and transaction_type = 'Imbalance'
		then Purchase - refund 
		else 0
		end)	as ImbalanceMCTotal,
	sum(case when credit_card_type = 'American Express' and transaction_type = 'Imbalance'
		then Purchase - Refund 
		else 0
		end)	as ImbalanceAMXTotal,
	sum(case when (credit_card_type = 'Discover Novus' or credit_card_type = 'Diners/Enroute' or credit_card_type = 'Japan Carte Blanche') and transaction_type = 'Imbalance'
		then Purchase - refund 
		else 0
		end)	as ImbalanceNovusTotal,
	sum(case when credit_card_type = 'VISA' and transaction_type = 'Manual'
		then Purchase - refund 
		else 0
		end)	as ManualVisaTotal,
	sum(case when credit_card_type = 'Master Card' and transaction_type = 'Manual'
		then Purchase - refund 
		else 0
		end)	as ManualMCTotal,
	sum(case when credit_card_type = 'American Express' and transaction_type = 'Manual'
		then Purchase - Refund 
		else 0
		end)	as ManualAMXTotal,
	sum(case when (credit_card_type = 'Discover Novus' or credit_card_type = 'Diners/Enroute' or credit_card_type = 'Japan Carte Blanche') and transaction_type = 'Manual'
		then Purchase - refund 
		else 0
		end)	as ManualNovusTotal		
	from 
	rbr_date r
	left join
	(
	SELECT Transaction_Type, RBR_Date, (Case When Location_ID=255 Then 20 Else Location_ID End) Location_ID, Credit_Card_Type, Purchase, Refund
	FROM  dbo.RP_Con_4_Location_EOD_Reconciliation_SR_Credit_Card_Totals
	
	)cct
	--RP_Con_4_Location_EOD_Reconciliation_SR_Credit_Card_Totals cct
	on cct.rbr_date = r.rbr_date
	where r.rbr_date between @startBusDate and @endBusDate
	group by r.rbr_date, location_id
)credit
on credit.location_id = loc.location_id
and credit.rbr_date = loc.rbr_date
left join 
(select r.rbr_date, location_id, 
	sum(case when debit_card = 1 and cash = 0
		then cash_cdn_amount 
		else 0
		end)	as debitCardTotal,
	sum(case when (cash = 1 and debit_card = 0) or (cash = 0 and debit_card = 0)
		then cash_cdn_amount 
		else 0
		end)	as cashTotal
	from rbr_date r
	left join
	(SELECT RBR_Date, (Case When Location_ID=255 Then 20 Else Location_ID End) Location_ID, Cash_Type, Debit_Card, Cash, Cash_Cdn_Amount
FROM  dbo.RP_Con_4_Location_EOD_Reconciliation_SR_Cdn_Cash_Totals
)csht
--	RP_Con_4_Location_EOD_Reconciliation_SR_Cdn_Cash_Totals csht
	on r.rbr_date = csht.rbr_date 
	where r.rbr_date between @startBusDate and @endBusDate
	group by r.rbr_date, location_id
) cash
on loc.rbr_date = cash.rbr_date
and loc.location_id = cash.location_id
left join
(select r.rbr_date, location_id,
	sum( Cash_US_amount) as usCashTotal
	from 
	rbr_date r
	left join
	(SELECT RBR_Date, (Case When Location_ID=255 Then 20 Else Location_ID End) Location_ID, Cash_Type, Cash_US_Amount
	FROM  dbo.RP_Con_4_Location_EOD_Reconciliation_SR_US_Cash_Totals) r2

	--RP_Con_4_Location_EOD_Reconciliation_SR_US_Cash_Totals r2
	on r.rbr_date = r2.rbr_date 
	where r.rbr_date between @startBusDate and @endBusDate
	group by r.rbr_date, location_id
) uscash
on loc.rbr_date = uscash.rbr_date
and loc.location_id = uscash.location_id
left join 
(select r.rbr_date, location_id, 
	sum(case when (currency_id=1)
		then cert_amount 
		else 0
		end)	as certTotal
	from rbr_date r
	left join
--select * from 
   (SELECT RBR_Date, (Case When Location_ID=255 Then 20 Else Location_ID End) Location_ID, Cert_Type, Cert_Amount, Currency_ID
FROM  dbo.RP_Con_4_Location_EOD_Reconciliation_SR_Cert_Totals) ct

	--RP_Con_4_Location_EOD_Reconciliation_SR_Cert_Totals ct
	on r.rbr_date = ct.rbr_date 
	where r.rbr_date between @startBusDate and @endBusDate
	group by r.rbr_date, location_id
) cert
on loc.rbr_date = cert.rbr_date
and loc.location_id = cert.location_id
left join
(select r.rbr_date, location_id,
	sum(case when (currency_id=2)
		then cert_amount 
		else 0
		end)	as usCertTotal
	from 
	rbr_date r
	left join
	(SELECT RBR_Date,  (Case When Location_ID=255 Then 20 Else Location_ID End) Location_ID, Cert_Type, Cert_Amount, Currency_ID
	FROM  dbo.RP_Con_4_Location_EOD_Reconciliation_SR_Cert_Totals)ct2
	--RP_Con_4_Location_EOD_Reconciliation_SR_Cert_Totals  ct2
	on r.rbr_date = ct2.rbr_date 
	where r.rbr_date between @startBusDate and @endBusDate
	group by r.rbr_date, location_id
) usCert
on loc.rbr_date = usCert.rbr_date
and loc.location_id = usCert.location_id
order by loc.rbr_date, loc.location








GO
