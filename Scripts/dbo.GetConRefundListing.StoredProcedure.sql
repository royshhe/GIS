USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetConRefundListing]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.GetActiveReservation    Script Date: 2/18/99 12:12:01 PM ******/
/****** Object:  Stored Procedure dbo.GetActiveReservation    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetActiveReservation    Script Date: 1/11/99 1:03:15 PM ******/
/*
PURPOSE: 	To retrieve all active reservations with pickup date which has passed by NoShowTimeLimit.
MOD HISTORY:
Name    Date        Comments

select *
--update claimrefundlisting$ set processed='Y'
from claimrefundlisting$
where  processed='G'

*/

CREATE PROCEDURE [dbo].[GetConRefundListing]
AS

declare @go as varchar(3)
select @go='YES'
if @go='YES' 
begin
	SELECT DISTINCT 
				   TOP 100 PERCENT c.contract_number,
					case when ccinfo.First_name is not null 
							then ccinfo.First_name
							else ccinfo1.First_name
						end AS Card_Holder_Last_Name, 
				   case when ccinfo.last_name is not null 
							then ccinfo.last_name
							else ccinfo1.last_name
						end  AS Card_Holder_First_Name,
					 case when ccinfo.Expiry is not null 
							then ccinfo.Expiry
							else ccinfo1.Expiry 
							end as Expiry, 
					case when ccinfo.Credit_Card_Number is not null 
							then ccinfo.Credit_Card_Number
							else ccinfo1.Credit_Card_Number
						end as Credit_Card_Number,
					 case when ccinfo.Credit_Card_Key is not null 
							then ccinfo.Credit_Card_Key 
							else ccinfo1.Credit_Card_Key
						end as Credit_Card_Key,
				   round(cf.chequeamount,2) RefundAmount	,			
					 cf.claim#,
	--				, 
	--				v.vehicle_class_code,
	--				VOC.Checked_Out, VOC.Actual_Check_In, VOC.Km_Out, VOC.Km_In, 'F' + VOC.Fuel_Level AS Expr1, 
	--               VOC.Fuel_Price_Per_Litre, VOC.FPO_Purchased, VOC.Calculated_Fuel_Charge, VOC.Calculated_Fuel_Litre, VOC.Foreign_FPO_Charge, VMY.Model_Name, 
	--               VMY.Model_Year, 
						dbo.Customer.Last_Name, 
						dbo.Customer.First_Name, 
						dbo.Customer.Address_1, 
						dbo.Customer.Address_2,
						 dbo.Customer.City, 
				         dbo.Customer.Province, 
							dbo.Customer.Postal_Code, 
						lt.value as CountryName, dbo.Customer.Email_Address
				   --,Icbcrate.rate_name


	--select distinct cf.*,c.contract_number,c.First_name, c.last_name ,ccinfo.First_name as CC_First_Name,ccinfo.last_name as CC_Last_Name,credit_card_number,expiry,credit_card_type_ID
	--select distinct *
	from claimrefundlisting$ cf 
			inner join contract c on c.contract_number=cf.contract#
			left join (Select LCCP.Contract_Number, CC.* from Credit_Card_Payment LCCP  
							   Inner join 
									 (SELECT   CCP.Contract_Number, Max(CCP.Sequence) Seq
									 FROM  dbo.Credit_Card_Payment AS CCP
									 Group By   CCP.Contract_Number
									 ) ConPay
									 On LCCP.Contract_Number=ConPay.Contract_Number And LCCP.Sequence=     ConPay.Seq
							   INNER JOIN
									 dbo.Credit_Card AS CC ON LCCP.Credit_Card_Key = CC.Credit_Card_Key
							) ccinfo on ccinfo.contract_number=c.contract_number
               LEFT OUTER JOIN
               dbo.Customer ON c.Customer_ID = dbo.Customer.Customer_ID 
				left join lookup_table lt on lt.code=dbo.Customer.country and lt.category='country'

			left join (Select LCCA.Contract_Number, CC1.* from Credit_Card_Authorization LCCA  
							   Inner join 
									 (SELECT   CCA.Contract_Number, Max(CCA.Sequence) Seq
									 FROM  dbo.Credit_Card_Authorization AS CCA
									 Group By   CCA.Contract_Number
									 ) ConPay1
									 On LCCa.Contract_Number=ConPay1.Contract_Number And LCCa.Sequence=     ConPay1.Seq
							   INNER JOIN
									 dbo.Credit_Card AS CC1 ON LCCa.Credit_Card_Key = CC1.Credit_Card_Key
							) ccinfo1 on ccinfo1.contract_number=c.contract_number

	--where c.contract_number='1483099'
	where cf.chequeamount<>0
			and cf.processed='G' 
			--and (cf.processed<>'Y' and cf.processed<>'X' and )
	order by c.contract_number
end

/*

--select * from Refund_History order by trxdate
--delete from Refund_History where contract_number='1603861' and trxdate='2012-12-14 17:09:11.173'
insert into Refund_History (Contract_Number,Last_Name,First_Name,Expiry,Credit_Card_Number,Credit_Card_Key,RefundAmount,status,TrxDate,Remarks)

SELECT DISTINCT 
               TOP 100 PERCENT VOC.Contract_Number,
                CCPayment.Last_Name AS Card_Holder_Last_Name, 
               CCPayment.First_Name AS Card_Holder_First_Name, CCPayment.Expiry, 
				CCPayment.Credit_Card_Number, ccpayment.Credit_Card_Key,
               round(VOC.Fuel_Price_Per_Litre *5.00,2) RefundAmount	,			
				'0' as status,
				getdate() as TrxDate,
				'Credit Card' as Remarks				
FROM  dbo.Vehicle_On_Contract AS VOC INNER JOIN
               dbo.Vehicle AS V ON VOC.Unit_Number = V.Unit_Number inner join
               dbo.Vehicle_Model_Year AS VMY ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID INNER JOIN
               dbo.Contract AS CON ON VOC.Contract_Number = CON.Contract_Number
               LEFT OUTER JOIN
               dbo.Customer ON CON.Customer_ID = dbo.Customer.Customer_ID 
               LEFT OUTER JOIN
               
               (Select LCCP.Contract_Number, CC.* from Credit_Card_Payment LCCP  
                           Inner join 
                                 (SELECT   CCP.Contract_Number, Max(CCP.Sequence) Seq
                                 FROM  dbo.Credit_Card_Payment AS CCP
                                 Group By   CCP.Contract_Number
                                 ) ConPay
                                 On LCCP.Contract_Number=ConPay.Contract_Number And LCCP.Sequence=     ConPay.Seq
                           INNER JOIN
                                 dbo.Credit_Card AS CC ON LCCP.Credit_Card_Key = CC.Credit_Card_Key
                                 
                                 
                           
                      ) CCPayment     on   Con.Contract_Number=CCPayment.Contract_Number
				--left outer join  (select rate_id,rate_name from vehicle_rate where rate_name like 'ICBC%') Icbcrate on con.rate_id=Icbcrate.rate_id

WHERE (VOC.FPO_Purchased = 1 and voc.calculated_fuel_charge>0) AND (VOC.Actual_Check_In >= '2010-06-01') AND (VOC.Actual_Check_In < '2012-12-09')  
AND (V.Owning_Company_ID = 7425) AND 
(VOC.Km_Out <> VOC.Km_In) 
AND (CON.Status = 'ci')
and CCPayment.credit_card_type_id not  in ('BU','BRC','BML','BOV')
and con.contract_number  in ('1405953','1387096','1482414')--ICBC RAte
--and con.contract_number not in ('1587946','1603921','1603889','1603861','1586797','1586794')--alread process
and  con.contract_number not in (select con.contract_number
							--select *
							FROM  dbo.Vehicle_On_Contract AS VOC INNER JOIN
										   dbo.Contract AS CON ON VOC.Contract_Number = CON.Contract_Number
										inner join dbo.contract_charge_item cci on con.contract_number=cci.contract_number
							WHERE (VOC.FPO_Purchased = 1) AND (VOC.Actual_Check_In >= '2010-06-01') AND (VOC.Actual_Check_In < '2012-12-09')  
							AND cci.charge_type=14
							and (VOC.Km_Out <> VOC.Km_In) 
							group by con.contract_number,cci.charge_type
							having sum(cci.amount)=0)
		
--and  (right(expiry,2)<12 or right(expiry,2)=12 and left(expiry,2)<=11)
--and con.contract_number in (select contract_number from refund_history where reprocess=1 and status=0)

--and con.contract_number in ('1586794')

ORDER BY VOC.Contract_Number DESC 



SELECT DISTINCT 
               TOP 100 PERCENT VOC.Contract_Number,
                CCPayment.Last_Name AS Card_Holder_Last_Name, 
               CCPayment.First_Name AS Card_Holder_First_Name, CCPayment.Expiry, 
				CCPayment.Credit_Card_Number, ccpayment.Credit_Card_Key,
               round(VOC.Fuel_Price_Per_Litre *5.00,2) RefundAmount	,			
				 VOC.Unit_Number, 
				v.vehicle_class_code,
				VOC.Checked_Out, VOC.Actual_Check_In, VOC.Km_Out, VOC.Km_In, 'F' + VOC.Fuel_Level AS Expr1, 
               VOC.Fuel_Price_Per_Litre, VOC.FPO_Purchased, VOC.Calculated_Fuel_Charge, VOC.Calculated_Fuel_Litre, VOC.Foreign_FPO_Charge, VMY.Model_Name, 
               VMY.Model_Year, dbo.Customer.Last_Name, dbo.Customer.First_Name, dbo.Customer.Address_1, dbo.Customer.Address_2, dbo.Customer.City, 
               dbo.Customer.Province, dbo.Customer.Postal_Code, lt.value as CountryName, dbo.Customer.Email_Address
               --,Icbcrate.rate_name

FROM  dbo.Vehicle_On_Contract AS VOC INNER JOIN
               dbo.Vehicle AS V ON VOC.Unit_Number = V.Unit_Number inner join
               dbo.Vehicle_Model_Year AS VMY ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID INNER JOIN
               dbo.Contract AS CON ON VOC.Contract_Number = CON.Contract_Number
               LEFT OUTER JOIN
               dbo.Customer ON CON.Customer_ID = dbo.Customer.Customer_ID 
               LEFT OUTER JOIN
               
               (Select LCCP.Contract_Number, CC.* from Credit_Card_Payment LCCP  
                           Inner join 
                                 (SELECT   CCP.Contract_Number, Max(CCP.Sequence) Seq
                                 FROM  dbo.Credit_Card_Payment AS CCP
                                 Group By   CCP.Contract_Number
                                 ) ConPay
                                 On LCCP.Contract_Number=ConPay.Contract_Number And LCCP.Sequence=     ConPay.Seq
                           INNER JOIN
                                 dbo.Credit_Card AS CC ON LCCP.Credit_Card_Key = CC.Credit_Card_Key
                                 
                                 
                           
                      ) CCPayment     on   Con.Contract_Number=CCPayment.Contract_Number
				--left outer join  (select rate_id,rate_name from vehicle_rate where rate_name like 'ICBC%') Icbcrate on con.rate_id=Icbcrate.rate_id
				left join lookup_table lt on lt.code=dbo.Customer.country and lt.category='country'
WHERE (VOC.FPO_Purchased = 1 and voc.calculated_fuel_charge>0) AND (VOC.Actual_Check_In >= '2010-06-01 00:00') AND (VOC.Actual_Check_In < '2012-12-09 00:00')  
AND (V.Owning_Company_ID = 7425) AND 
(VOC.Km_Out <> VOC.Km_In) 
AND (CON.Status = 'ci')
and CCPayment.credit_card_type_id not  in ('BU','BRC','BML','BOV')
and con.contract_number  in ('1405953','1387096','1482414')--ICBC RAte
--and con.contract_number not in ('1587946','1603921','1603889','1603861','1586797','1586794')--alread process
and  con.contract_number not in (select con.contract_number
							--select *
							FROM  dbo.Vehicle_On_Contract AS VOC INNER JOIN
										   dbo.Contract AS CON ON VOC.Contract_Number = CON.Contract_Number
										inner join dbo.contract_charge_item cci on con.contract_number=cci.contract_number
							WHERE (VOC.FPO_Purchased = 1) AND (VOC.Actual_Check_In >= '2010-06-01 00:00') AND (VOC.Actual_Check_In < '2012-12-09 00:00')  
							AND cci.charge_type=14
							and (VOC.Km_Out <> VOC.Km_In) 
							group by con.contract_number,cci.charge_type
							having sum(cci.amount)=0)
		
--and (right(expiry,2)<12 or right(expiry,2)=12 and left(expiry,2)<=11)
--and con.contract_number in (select contract_number from refund_history where reprocess=1 and status=0)

--and con.contract_number='1551929'

ORDER BY VOC.Contract_Number DESC 
	
RETURN @@ROWCOUNT



/*
--log
date:	2012/12/01--2012/12/09 109 / 109
		2012-11-01--2012-12-01 492 / 491 
		2012-10-01--2012-11-01 698 / 692 
		2012-09-01--2012-10-01 728 / 726
		2012-08-01--2012-09-01 934 / 932
		2012-07-01--2012-08-01 893 / 891
		2012-06-15--2012-07-01 353 / 353
		2012-06-01--2012-06-15 264 / 264
		2012-05-01--2012-06-01 549 / 548
		2012-04-01--2012-05-01 520 / 520
		2012-03-01--2012-04-01 476 / 476
		2012-01-01--2012-03-01 902 / 902

		2011-09-01--2012-01-01 1468 / 1466
		2011-06-20--2011-09-01 1527 / 1522
		2011-02-01--2011-06-20 1485 / 1483
		2010-09-01--2011-02-01 1411 / 1405
		2010-06-01--2010-09-01 1406 / 1399

for Expired:
		2012-10-01--2012-12-09 26 / 26
		2012-06-01--2012-10-01 270 / 270
		2012-01-01--2012-06-01 457 / 457
		2011-06-01--2012-01-01 1392 / 1389
		2011-01-01--2012-06-01 2915 / 2909  wrong
		2011-01-01--2011-06-01 1066 / 1063

		2010-10-01--2011-01-01 735  / 735
		2010-09-01--2010-10-01 407 /  406
		2010-08-01--2010-09-01 701 / 700
		2010-07-01--2010-08-01 821 /820
		2010-06-01--2010-07-01 674 / 669
*/


*/
GO
