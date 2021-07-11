USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAdhocReportDepositStatics]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


---------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              Jul 31, 2001
--  Details: 	 compute the deposit of res and con
--  Tracker:	 Issue# 1865
---------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[GetAdhocReportDepositStatics]
as
	select 
		dep.location as 'pick_up_location', 
		dep.type , 
		dep.doc_number , 
		dep.pick_up_on,
		dep.vehicle_class_name,
		sum(Case When dep.Payment_Type='Cash' Then	dep.Amount Else 0 End) as CashAmount,
		sum(Case When dep.Payment_Type='A/R' Then	dep.Amount Else 0 End) as InterimAmount    
	
	from 
	(
		select    loc.location, 
			'Con' as type , 
			con.contract_number as doc_number,
			con.pick_up_on, 
			vc.vehicle_class_name,
			(Case When cpi.Payment_type='A/R' then 'A/R'
				 Else 'Cash'
			End) Payment_type,
			sum(cpi.amount) as Amount
		from contract con
		        join location loc
			 on con.Pick_Up_Location_ID = loc.location_id
 		        join Contract_Payment_Item cpi
			 on con.contract_number = cpi.contract_number --And cpi.Payment_Type <> 'A/R' 
		        left join vehicle_class vc
			on vc.vehicle_class_code = con.vehicle_class_code
		where con.status = 'CO'
		group by con.contract_number , loc.location, con.pick_up_on, vc.vehicle_class_name,
		(Case When cpi.Payment_type='A/R' then 'A/R'
				 Else 'Cash'
		End)
		
		union 
	
		select    loc.location , 
			'Res' as Type , 
			res.confirmation_number as doc_number ,
			res.pick_up_on, 
			vc.vehicle_class_name,
			(Case When rdp.Payment_type='A/R' then 'A/R'
				 Else 'Cash'
			End) Payment_type,
			sum(rdp.amount) as Amount
		from reservation res
		        join location loc
			 on loc.location_id = res.Pick_Up_Location_ID
		        join Reservation_Dep_Payment rdp
			 on res.confirmation_number = rdp.confirmation_number 
		        left join vehicle_class vc
			on vc.vehicle_class_code = res.vehicle_class_code
		where res.status = 'A'
		group by res.confirmation_number , loc.location, res.pick_up_on, vc.vehicle_class_name,
		(Case When rdp.Payment_type='A/R' then 'A/R'
				 Else 'Cash'
		End)
	) dep
	
	--where dep.amount > 0
	Group by 
	dep.location, 	dep.type, 	dep.doc_number, dep.pick_up_on,	dep.vehicle_class_name
	order by dep.location , dep. type desc , dep.doc_number
	--compute sum(dep.amount) by dep.location
	--compute sum(dep.amount)
GO
