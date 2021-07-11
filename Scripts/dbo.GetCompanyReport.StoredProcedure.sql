USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCompanyReport]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



/* Programmer:  Jack Jian
    Date:  Mar 26, 2001
    Details: reply email from John mar 23, 2001, create report on BMS , tracker #1840
*/



CREATE PROCEDURE [dbo].[GetCompanyReport]

@FromDate varchar(255) ,
@CompanyName varchar(255)

as

set nocount on 

declare @FramDate_D datetime
SELECT @FramDate_D = CONVERT(DATETIME, @FromDate )


select distinct bt.contract_number , con.status , bt.rbr_date
into #tmp_Contract 
 from business_transaction bt
join contract con
on  bt.contract_number = con.contract_number
where bt.rbr_date >= @FramDate_D
and bt.Transaction_Description = 'Check Out'
and con.company_name like @CompanyName + '%'

/*get the Time Charge */
select cci.contract_number , sum(cci.amount) as Time_Charge
into #tmp_timecharge  
from contract_charge_item  cci
where cci.contract_number in (select contract_number from #tmp_contract tcon where tcon.status = 'CI' )
and cci.charge_type='10'
group by cci.contract_number
order by cci.contract_number

/*get the Km Charge */
select contract_number,sum(amount) as KM_Charge
into #tmp_kmcharge
from contract_charge_item 
where contract_number in (select contract_number from #tmp_contract where status = 'CI' ) 
and charge_type='11'
group by contract_number
order by contract_number
 
/*get the KM driven */
select contract_number,  kmdriven=(sum(km_in) - sum(km_out) )
into #tmp_kmdriven
from vehicle_on_contract
where contract_number in (select contract_number from #tmp_contract where status = 'CI' )
group by contract_number
order by contract_number 

-------------------------------------------------

select tcon.contract_number , con.status,   con.company_name , con.first_name , con.last_name ,

  case  
    when con.rate_id is null 
 	then ( select Rate_Name from quoted_vehicle_rate qvr  where qvr.quoted_rate_id=con.quoted_rate_id  )
    else
	       ( select Rate_Name from vehicle_rate i_vr where i_vr.rate_id = con.rate_id AND con.Rate_Assigned_Date between i_vr.effective_date and i_vr.termination_date )
  end rate_name ,

-- tcon.rbr_date  as checkout_date , 
   voc.Checked_Out as CheckOut_Date ,  --  vehicle chout date

   case 
     when con.status = 'CI'
	then ( select rbr_date from business_transaction i_bt  where i_bt.contract_number = tcon.contract_number and i_bt.Transaction_Description = 'Check In' ) 
     else
	Null
   end Checkin_Date ,                                 -- contract check in date

( select location from location where location_id = voc.Pick_Up_Location_ID ) as Checkout_Location ,
( select location from location where location_id = voc.Actual_Drop_Off_Location_ID ) as Drop_Location ,

vc.Vehicle_Class_Name as Vehicle_Class_In_Rate ,

( select i_vc.Vehicle_Class_Name from vehicle_class i_vc where  i_vc.Vehicle_Class_Code  = voc.Actual_Vehicle_Class_Code ) as Vehcile_Class_On_Rent ,

con.Confirmation_Number ,

ttc.Time_Charge , tkmc.KM_Charge ,  tkm.kmdriven

from #tmp_Contract tcon
join contract con
on tcon.contract_number = con.contract_number

left join vehicle_class vc 
on con.Vehicle_Class_Code = vc.Vehicle_Class_Code 

left join vehicle_on_contract voc 
on tcon.contract_number = voc.contract_number

left join #tmp_kmdriven tkm
on tcon.contract_number = tkm.contract_number
left join #tmp_timecharge ttc
on tcon.contract_number = ttc.contract_number
left join #tmp_kmcharge tkmc
on tcon.contract_number = tkmc.contract_number

order by tcon.contract_number, CheckOut_Date

set nocount off

return



GO
