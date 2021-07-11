USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_CCI_4_Credit_Card_Statement_OM]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [dbo].[RP_SP_CCI_4_Credit_Card_Statement_OM] -- '11 aug 2014'
(
	@paramStmtDate varchar(20) = '15 April 1999'
)
AS

declare @stmtDate datetime
declare @startDate datetime
declare @endDate datetime
declare @EigenstartDate datetime
declare @EigenendDate datetime

select @stmtDate= CONVERT(datetime,@paramStmtDate)
select @startDate=DateAdd(hour,-3,@stmtDate)
select @endDate=DateAdd(hour,24,@startDate)

select @EigenstartDate=Budget_Start_Datetime,@EigenendDate=Budget_Close_Datetime  from rbr_date where rbr_date=@paramStmtDate

--select @EigenstartDate=DateAdd(minute,-90,@stmtDate)
--select @EigenendDate=DateAdd(hour,24,@EigenstartDate) 


--if @stmtDate<=convert(datetime,'09 Feb 2010' )
--  BEGIN
--	SELECT   dbo.Credit_Card_Type.Credit_Card_Type as OM_CC_Type,dbo.OM_CRTransReport.merchant_id, dbo.OM_CRTransReport.merchant_name, 
--	      convert(varchar,dbo.OM_CRTransReport.trn_id) OM_trn_id, dbo.OM_CRTransReport.trn_datetime, 
--	      dbo.OM_CRTransReport.trn_card_owner, dbo.OM_CRTransReport.trn_ip, 
--	      dbo.OM_CRTransReport.trn_type, 

--	      (Case when dbo.OM_CRTransReport.trn_type='R' or dbo.OM_CRTransReport.trn_type='VP' then dbo.OM_CRTransReport.trn_original_amount*(-1)
--		    else dbo.OM_CRTransReport.trn_original_amount
--	       End
--	      )/100.00 as trn_amount, 
--	      --dbo.OM_CRTransReport.trn_original_amount, 
--              dbo.OM_CRTransReport.trn_returns, 
--	      dbo.OM_CRTransReport.trn_order_number, dbo.OM_CRTransReport.trn_auth_code, 
--	      dbo.OM_CRTransReport.trn_adjustment_to, dbo.OM_CRTransReport.trn_response
	    
--	FROM dbo.OM_CRTransReport INNER JOIN
--	      dbo.Credit_Card_Type ON 
--	      dbo.OM_CRTransReport.trn_card_type = dbo.Credit_Card_Type.Online_Mart_Code

--	where  (dbo.OM_CRTransReport.trn_datetime >= @startDate AND dbo.OM_CRTransReport.trn_datetime< @endDate) and  (dbo.OM_CRTransReport.trn_type <> 'PA') AND (dbo.OM_CRTransReport.trn_response = '1')
--  END	
--else
--BEGIN
	SELECT   
		  (case when dbo.Eigen_Settlement_CRTransReport.trn_card_type<>'Other'
				 then dbo.Credit_Card_Type.Credit_Card_Type
				 else dbo.Eigen_Settlement_CRTransReport.trn_card_type
			end) as OM_CC_Type,
		  '' as merchant_id,
		  --replace(dbo.Eigen_Settlement_CRTransReport.merchant_name, 'BUDGET-VANCOUVER-','') AS merchant_name,
		  (case when l.merchant_name is not null
				then 	l.location
				WHEN dbo.Eigen_Settlement_CRTransReport.merchant_name='BUDGET-VANCOUVER-SURREY-KING-GEORGE-HWY (BC LTD 09'
				THEN 'B-39 Surrey'
				else	dbo.Eigen_Settlement_CRTransReport.merchant_name
			end) as MerchantName,

	      right(Rtrim(dbo.Eigen_Settlement_CRTransReport.Station_ID),4)+
			rtrim(Ltrim(dbo.Eigen_Settlement_CRTransReport.trn_id)) +
			 rtrim(ltrim(dbo.Eigen_Settlement_CRTransReport.trn_auth_code)) as OM_trn_id,
		  dbo.Eigen_Settlement_CRTransReport.trn_datetime, 
	      cctrans.First_name+' '+cctrans.last_name as trn_card_owner, '' as trn_ip, 
	      dbo.Eigen_Settlement_CRTransReport.trn_type, 

	      (Case when dbo.Eigen_Settlement_CRTransReport.trn_type='04' or dbo.Eigen_Settlement_CRTransReport.trn_type='03' then dbo.Eigen_Settlement_CRTransReport.trn_amount*(-1)
		    else dbo.Eigen_Settlement_CRTransReport.trn_amount
	       End
	      )/100.00 as trn_amount, 
	      --'' as trn_original_amount, 
          '' as trn_returns, 
	      dbo.Eigen_Settlement_CRTransReport.trn_order_number, 
		  dbo.Eigen_Settlement_CRTransReport.trn_auth_code,
	      '' as trn_adjustment_to, '' as trn_response,
	      --Convert(Varchar(20), ISNULL('RA'+cctrans.Contract_Number,''))+Convert(Varchar(20),ISNULL('RE'+Confirmation_Number,''))+Convert(Varchar(20),ISNULL('SA'+Sales_Contract_Number,'')) as docNumber
	      ISNULL('RA'+RIGHT(Convert(Varchar, cctrans.Contract_Number+10000000000),9),'')+ISNULL('RE'+RIGHT(Convert(Varchar,cctrans.Confirmation_Number+10000000000),9),'')+ISNULL('SA'+RIGHT(Convert(Varchar,cctrans.Sales_Contract_Number+10000000000),9),'') as docNumber
--select *
	FROM dbo.Eigen_Settlement_CRTransReport  
	     Left Join	dbo.location l	
				on l.merchant_name=replace(dbo.Eigen_Settlement_CRTransReport.merchant_name ,'-SURREY','')
		 left JOIN	dbo.Credit_Card_Type 
		        ON dbo.Eigen_Settlement_CRTransReport.trn_card_type = dbo.Credit_Card_Type.Eigen_Card_Code
		 left JOIN credit_card_transaction  cctrans     
		 --left join (select distinct cc.Credit_card_number,cc.expiry,cct.authorization_number,max(cct.First_name) as first_name,max(cct.last_name) as last_name,trx_receipt_ref_num
			--			from 
			--				credit_card_transaction cct
						 
			--			--group by cc.Credit_card_number,cc.expiry,cct.authorization_number,cct.trx_receipt_ref_num
			--			) cctrans 
				on  --left(dbo.Eigen_Settlement_CRTransReport.trn_card_number,6)=left(cctrans.Credit_Card_Number,6)	and 
					right(dbo.Eigen_Settlement_CRTransReport.trn_card_number,4)=right(cctrans.Credit_card_number,4) 
--					and  left(dbo.Eigen_Settlement_CRTransReport.trn_card_Expire,2)=right(cctrans.Expiry,2)
--					and  right(dbo.Eigen_Settlement_CRTransReport.trn_card_Expire,2)=left(cctrans.expiry,2)
					and  (dbo.Eigen_Settlement_CRTransReport.trn_card_type='Debit' or left(dbo.Eigen_Settlement_CRTransReport.trn_card_Expire,2)=right(cctrans.Expiry,2) or left(dbo.Eigen_Settlement_CRTransReport.trn_card_Expire,2)=(convert(integer,right((cctrans.Expiry),2))+2))
					and (dbo.Eigen_Settlement_CRTransReport.trn_card_type='Debit' or right(dbo.Eigen_Settlement_CRTransReport.trn_card_Expire,2)=left(cctrans.expiry,2))
					and dbo.Eigen_Settlement_CRTransReport.trn_auth_code=cctrans.authorization_number
					and left(dbo.Eigen_Settlement_CRTransReport.trn_id,12)=left(cctrans.trx_receipt_ref_num,12)

	where  (dbo.Eigen_Settlement_CRTransReport.RBR_Date=@paramStmtDate) and 
			 dbo.Eigen_Settlement_CRTransReport.trn_type not in ( '09'  , '11' )
					and dbo.Eigen_Settlement_CRTransReport.trn_auth_code<>'' -- AND (dbo.Eigen_Settlement_CRTransReport.trn_response = '1')
	order by l.location
  --END


 



--select count(*),  Credit_card_number, expiry, authorization_number,trx_receipt_ref_num 
--from credit_card_transaction  
--where rbr_date>'2011-01-01'
--group by  Credit_card_number, expiry, authorization_number,trx_receipt_ref_num
--having count(*)>1

--select * from Eigen_Settlement_CRTransReport
--select * from credit_card_transaction



GO
