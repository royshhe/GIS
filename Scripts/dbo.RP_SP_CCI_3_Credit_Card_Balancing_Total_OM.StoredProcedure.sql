USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_CCI_3_Credit_Card_Balancing_Total_OM]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
















CREATE PROCEDURE [dbo].[RP_SP_CCI_3_Credit_Card_Balancing_Total_OM] --'27 apr 2010'
(
	@paramRBRDate varchar(20) = '15 April 1999'
)
AS

declare @rbrDate datetime
declare @startDate datetime
declare @endDate datetime

select @rbrDate= CONVERT(datetime,@paramRBRDate)
select @startDate=Budget_Start_Datetime,@endDate=Budget_Close_Datetime  from rbr_date where rbr_date=@rbrDate

  Begin
	select  (case 
		when CRLog.Credit_Card_Type is not null 
		then CRLog.Credit_Card_Type
		else CRLog.OM_CC_Type
		end) CC_Type,BgtNumOfTransAuto,BgtTotalAmountAuto,BgtNumOfTransManu,BgtTotalAmountManu,OMNumOfTrans,OMTotalAmount
	

	from

	(

		select * from 
		(
		SELECT   sum(
			case
				when Electronic_Authorization = 1 AND Terminal_ID IS NULL then 0
				else 1
			end

		     ) as BgtNumOfTransAuto,  
		
		  sum(
			case
				when Electronic_Authorization = 1 AND Terminal_ID IS NULL then 0
				else Amount
			end
		    ) as BgtTotalAmountAuto,


		sum(
			case
				when Electronic_Authorization = 1 AND Terminal_ID IS NULL then 1
				else 0
			end

		     ) as BgtNumOfTransManu,  
		
		  sum(
			case
				when Electronic_Authorization = 1 AND Terminal_ID IS NULL then Amount
				else 0
			end
		    ) as BgtTotalAmountManu,


		Credit_Card_Type  --,   RBR_Date
	FROM         dbo.RP_CCI_3_Credit_Card_Balancing_Payment
	where (dbo.RP_CCI_3_Credit_Card_Balancing_Payment.RBR_Date = @rbrDate)
        group by  Credit_Card_Type
	) CRPaymentSum
	
	full OUTER JOIN
	        
	(
		SELECT  count(*) as OMNumOfTrans,  
			sum(case when (trn_type='04' or trn_type='06')  then trn_amount*(-1) 
				  else trn_amount
			     End )/100.00 as OMTotalAmount, 
			(case  when dbo.Credit_Card_Type.Credit_Card_Type is null then 'Other'
			      else dbo.Credit_Card_Type.Credit_Card_Type
				end)  as OM_CC_Type
		FROM dbo.Eigen_CRTransReport full outer JOIN
		      dbo.Credit_Card_Type ON 
		      dbo.Eigen_CRTransReport.trn_card_type = dbo.Credit_Card_Type.Eigen_Card_Code
		where  (dbo.Eigen_CRTransReport.trn_datetime BETWEEN   @startDate AND @endDate) 
			and  (dbo.Eigen_CRTransReport.trn_type not in ( '09','11'))-- AND (dbo.Eigen_CRTransReport.trn_response = '1')
			and( dbo.Eigen_CRTransReport.rbr_date <='2010/05/02' and not ( dbo.Eigen_CRTransReport.trn_auth_code is null  or rtrim(ltrim(dbo.Eigen_CRTransReport.trn_auth_code))='')
			 or dbo.Eigen_CRTransReport.rbr_date >'2010/05/02' and dbo.Eigen_CRTransReport.Response_Code<='010' 	)
		Group by dbo.Credit_Card_Type.Credit_Card_Type
	) CRTransLogSum

	
	 ON CRPaymentSum.Credit_Card_Type = CRTransLogSum.OM_CC_Type
   ) CRLog
  End











GO
