USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_CCI_3_Credit_Card_Balancing_OM_Old]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


















CREATE PROCEDURE [dbo].[RP_SP_CCI_3_Credit_Card_Balancing_OM_Old] --'28 apr 2010'
(
	@paramRBRDate varchar(20) = '15 April 1999'
)
AS

declare @rbrDate datetime
declare @startDate datetime
declare @endDate datetime

select @rbrDate= CONVERT(datetime,@paramRBRDate)
select @startDate=Budget_Start_Datetime,@endDate=Budget_Close_Datetime  from rbr_date where rbr_date=@rbrDate

--EIGEN TRANSACTIONS
  BEGIN
	select  (case 
		when CRLog.Credit_Card_Type is not null 
		then  CRLog.Credit_Card_Type
		else CRLog.OM_CC_Type
	 end) CC_Type,
	CRLog.Location, CRLog.Terminal_ID, CRLog.trn_id , CRLog.Authorization_Number, 
	dbo.ccmask(CRLog.Credit_Card_Number,4,4), CRLog.Last_Name, CRLog.First_Name, CRLog.Expiry, 
	CRLog.Document_Number, CRLog.Document_Type, CRLog.Amount, CRLog.Collected_On, CRLog.Collected_By, CRLog.RBR_Date,
	CRLog.Credit_Card_Type,CRLog.merchant_id, CRLog.merchant_name, 
	CRLog.OM_trn_id, CRLog.trn_datetime, 
	CRLog.trn_card_owner, CRLog.trn_ip, 
	CRLog.trn_type, 
        CRLog.trn_amount, --from  trn_original_amount
	--CRLog.trn_original_amount, 
        CRLog.trn_returns, 
	CRLog.trn_order_number, CRLog.trn_auth_code, 
	CRLog.trn_adjustment_to, CRLog.trn_response

	from

	(
	select * from 
	(
	SELECT     Credit_Card_Type, Location, Terminal_ID, 
	isnull(right(terminal_id,4)+rtrim(trn_id)+Authorization_Number,'') as  trn_id , 
	Authorization_Number, Credit_Card_Number, Last_Name, First_Name, Expiry, 
	                      Document_Number, Document_Type, Amount, Collected_On, Collected_By, RBR_Date
--SELECT *
	FROM         dbo.RP_CCI_3_Credit_Card_Balancing_Payment
	where (dbo.RP_CCI_3_Credit_Card_Balancing_Payment.RBR_Date = @rbrDate) 
	) CRPayment
	
	full OUTER JOIN
	                     
	(
	SELECT (case when dbo.Eigen_CRTransReport.trn_card_type<>'Other'
				 then dbo.Credit_Card_Type.Credit_Card_Type
				 else dbo.Eigen_CRTransReport.trn_card_type
			end) as OM_CC_Type,
			'' as merchant_id, 
		  dbo.Eigen_CRTransReport.merchant_name, 
	      right(Rtrim(dbo.Eigen_CRTransReport.Station_ID),4)+
			rtrim(Ltrim(dbo.Eigen_CRTransReport.trn_id)) +
			 rtrim(ltrim(dbo.Eigen_CRTransReport.trn_auth_code)) as OM_trn_id,
		  dbo.Eigen_CRTransReport.trn_datetime, 
	      cc.First_name+' '+cc.last_name as trn_card_owner,
		  '' as trn_ip, 
	      dbo.Eigen_CRTransReport.trn_type, 

	      (Case when dbo.Eigen_CRTransReport.trn_type='04' or dbo.Eigen_CRTransReport.trn_type='03' then dbo.Eigen_CRTransReport.trn_amount*(-1)
		    else dbo.Eigen_CRTransReport.trn_amount
	       End
	      )/100.00 as trn_amount, 
	      --dbo.Eigen_CRTransReport.trn_original_amount, 
	      '' as trn_returns, 
	      dbo.Eigen_CRTransReport.trn_order_number,
		  dbo.Eigen_CRTransReport.trn_auth_code, 
	      '' as trn_adjustment_to, '' as trn_response
--select *	    
	FROM dbo.Eigen_CRTransReport  full outer JOIN
	      dbo.Credit_Card_Type ON 
	      dbo.Eigen_CRTransReport.trn_card_type = dbo.Credit_Card_Type.Eigen_Card_Code
			left join dbo.Latest_credit_card cc 
				on  left(dbo.Eigen_CRTransReport.trn_card_number,6)=left(cc.Credit_Card_Number,6)
					and right(dbo.Eigen_CRTransReport.trn_card_number,4)=right(cc.Credit_card_number,4) 
					and  left(dbo.Eigen_CRTransReport.trn_card_Expire,2)=right(cc.Expiry,2)
					and right(dbo.Eigen_CRTransReport.trn_card_Expire,2)=left(cc.expiry,2)


	where  (dbo.Eigen_CRTransReport.trn_datetime BETWEEN 
	                      @startDate AND @endDate) and  (dbo.Eigen_CRTransReport.trn_type <> '09'  and dbo.Eigen_CRTransReport.trn_type <> '11')-- AND (dbo.Eigen_CRTransReport.trn_response = '1')
			and( dbo.Eigen_CRTransReport.rbr_date <='2010/05/02' and not ( dbo.Eigen_CRTransReport.trn_auth_code is null  or rtrim(ltrim(dbo.Eigen_CRTransReport.trn_auth_code))='')
			 or dbo.Eigen_CRTransReport.rbr_date >'2010/05/02' and dbo.Eigen_CRTransReport.Response_Code<='010' 	)

	) CRTransLog
	
	 ON CRPayment.trn_id = CRTransLog.OM_trn_id
	) CRLog
--where CRLog.OM_CC_Type='American Express'
  END


















GO
