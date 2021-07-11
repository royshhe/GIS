USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_12_Vehicle_Sold]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--------------------------------------------------------------------------------------------------------------------------------------
-- By:		Roy He
-- Date:	Mar 11 2004
-- Purpose: 	Listing of all sold vehicles
--		
--------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[RP_SP_Flt_12_Vehicle_Sold]  --'*','2004-01-01','2004-01-31'
       @Vehicle_Type  CHAR(5)  = '*',
       @SoldStartDate varchar(30)='',
       @SoldEndDate   varchar(30)=''

as

DECLARE @StartDate datetime
DECLARE @EndDate datetime

/*if @SoldStartDate = ''
begin
	select @StartDate = getdate()
end*/

declare @CompanyCode int  --remove hardcode code
select @CompanyCode=Code from Lookup_Table where Category = 'BudgetBC Company'
	

select  @StartDate=CONVERT(DATETIME, @SoldStartDate )

if @SoldEndDate = ''
begin
	select @EndDate = getdate()+1
end


else
begin
	select  @EndDate=CONVERT(DATETIME, @SoldEndDate )+1
end

select 	vc.vehicle_type_id		as 'Type',
	case when v.program = 1
		then 'Program'
		else rt.Value
		end			as 'Order',
	v.Unit_number		as 'Unit Number',
	v.Serial_Number		as 'Serial Number', 
	vm.Model_Year		as 'Year',
	vm.Model_Name	as 'Model',
	/*left( rs.value,30 )	as 'Rental Status',*/
	v.Current_Km 		as 'KM',
	v.Ownership_Date 	as 'Transfer Date',
	left(vs.value,25) 		as 'Status',
	dbo.RP__Auction_Movement.Movement_out, 
        dbo.RP__Auction_Movement.Movement_In, 
        dbo.RP__Vehicle_Status_Dates.PulledForDisposalDate, 
        dbo.RP__Vehicle_Status_Dates.SignedOffDate,
	--Up_to	= @EndDate,
        v.Vehicle_Status_Effective_On,
	datediff(dayofyear, v.Ownership_Date, v.Vehicle_Status_Effective_On) 	as Days_in_service,
        datediff(dayofyear,  dbo.RP__Auction_Movement.Movement_In,   dbo.RP__Vehicle_Status_Dates.SignedOffDate) as Days_In_Auction, 

       /*case when  dbo.RP__Vehicle_Status_Dates.SignedOffDate is not null
            then    dbo.RP__Vehicle_Status_Dates.SignedOffDate
            else    dbo.RP__Vehicle_Status_Dates.PulledForDisposalDate
       end*/

	l.Location		as 'Location',
	v.Current_Licence_Plate as 'Licence'

from 	vehicle v
        LEFT OUTER JOIN
                      dbo.RP__Auction_Movement ON v.Unit_Number = dbo.RP__Auction_Movement.Unit_Number 
        LEFT OUTER JOIN
                      dbo.RP__Vehicle_Status_Dates ON v.Unit_Number = dbo.RP__Vehicle_Status_Dates.Unit_Number
	left join vehicle_class vc
		on v.vehicle_class_code = vc.vehicle_class_code
	left join (
		select Code , value from lookup_table
		where Category = 'Vehicle Status'
      		) vs
		on vs.code = v.Current_Vehicle_Status
	left join
	location l 
		on l.location_id = v.current_location_id
	left join 
	vehicle_model_year vm
		on vm.Vehicle_Model_ID = v.Vehicle_Model_ID 
	left join (
		select code , value
		from lookup_table
		where Category = 'Vehicle Rental Status' 
      		) rs
		on rs.Code = v.Current_Rental_Status
	left join (
		select code , value
		from lookup_table
		where Category = 'Risk Type' 
      		) rt
		on rt.Code = v.Risk_Type

where 	v.deleted = 0 
	and v.Owning_Company_ID =  @CompanyCode
	and v.Current_Vehicle_Status = 'i'
	and v.Foreign_vehicle_unit_number is null
        and (v.Vehicle_Status_Effective_On>=@StartDate and v.Vehicle_Status_Effective_On<@EndDate )
        and (@Vehicle_Type = '*'
	 OR
	 vc.Vehicle_Type_ID = @Vehicle_Type
	)
--order by vs.value, v.unit_number
order by vc.vehicle_type_id, -- 'order', 
vm.Model_Name, vm.Model_Year, v.Unit_number

Return @@ROWCOUNT
GO
