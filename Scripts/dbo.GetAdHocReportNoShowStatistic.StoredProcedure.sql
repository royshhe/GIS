USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAdHocReportNoShowStatistic]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



---------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              Jul 30, 2001
--  Details: 	 no show reports
--  Tracker:	 Issue# 1864
---------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[GetAdHocReportNoShowStatistic]

	@from_rbr_date varchar(255) = 'Jul 01 2001' ,
	@to_rbr_date varchar(255) = 'Jul 30 2001'

as

	declare @startdate_d  datetime
	declare @enddate_d datetime
 
	select @startdate_d = convert( datetime , @from_rbr_date )
	select @enddate_d = convert( datetime ,  @to_rbr_date ) + 1	

	select 
		( case when bt2.RBR_Date is null then bt.rbr_date
		      else bt2.RBR_Date
		 end ) as Res_Open_RBR , 
		bt.Confirmation_Number as Res_Confirm , 
		r.Foreign_Confirm_Number as F_Res_Confirm ,
		loc.location  as Res_PickUp_Loc , 
		rdp.Amount  , 
		rdp.Payment_Type  , 
		vc.Vehicle_Class_Name 

	from business_transaction bt
	left join Reservation_Dep_Payment rdp
	  on bt.Confirmation_Number = rdp.Confirmation_Number
	left join Reservation r
	  on r.Confirmation_Number = bt.Confirmation_Number
	left join business_transaction bt2
	  on  bt2.Confirmation_Number = bt.Confirmation_Number and  bt2.Transaction_Description = 'Create' 
	join location loc
	  on loc.location_id = r.Pick_Up_Location_ID
	join vehicle_class vc
	  on r.Vehicle_Class_Code = vc.Vehicle_Class_Code

	where bt.Transaction_Description = 'No Show' 
	 and convert( int , rdp.Amount ) > 0
	 and 
		( 
			( bt2.RBR_Date >= @startdate_d and bt2.RBR_Date < @enddate_d ) 
			or ( bt2.RBR_Date is null and bt.RBR_Date >= @startdate_d and bt.RBR_Date < @enddate_d )
		)
	order by Res_Open_RBR , Res_Confirm
GO
