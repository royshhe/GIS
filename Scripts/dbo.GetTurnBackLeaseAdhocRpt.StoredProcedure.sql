USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetTurnBackLeaseAdhocRpt]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









--------------------------------------------------------------------------------------------------------------------------------------
-- Programmer:	Vivian Leung	
-- Date:	Mar 11 2002
-- Purpose: 	Adhoc report for turn back services (for all non-sold vehicles)
--		Issue #: 1893
--------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[GetTurnBackLeaseAdhocRpt]  --  '21 Sep 2017'

       @MonEndDate varchar(30)=''

as


DECLARE @EndDate datetime

if @MonEndDate = ''
begin
	select @EndDate = getdate()
end
else
begin
	select  @EndDate=CONVERT(DATETIME, @MonEndDate )
end

declare @CompanyCode int  --remove hardcode code
select @CompanyCode=Code from Lookup_Table where Category = 'BudgetBC Company'
	

select 	vc.vehicle_type_id		as 'Type',
	case when v.program = 1
		then 'Program'
		else rt.value
		end			as 'Order',
	v.Unit_number		as 'Unit Number',
	v.Serial_Number		as 'Serial Number', 
	vm.Model_Year		as 'Year',
	vm.Model_Name	as 'Model',
	/*left( rs.value,30 )	as 'Rental Status',*/
	v.Current_Km 		as 'KM',
	--v.Ownership_Date 	as 'Transfer Date',
	dbo.UpdatedVehicleISD(v.Unit_Number) as 'Transfer Date',
	 
	(Case When vs.Value='Pulled For Disposal'  Then
						(Case When v.Program=1 Then 'Pulled For TurnBack'
							 Else 'Pulled For Sale'
						End)						
                      Else 
						left(vs.value,25) 
                      End) AS 'Status', 
                      
	Up_to	= @EndDate,
	datediff(dayofyear, dbo.UpdatedVehicleISD(v.Unit_Number), @EndDate) 	as Days_in_service,	
	l.Location		as 'Location',
	v.Current_Licence_Plate as 'Licence',
	mf.Value as Manufacturer,
	v.Exterior_Colour,
	dl.Value as Dealer,
	V.Turn_Back_Deadline as turn_back_date,
	SO.SignOffDate,
	V.Ownership,
	V.Turn_Back_Message	,
	CASE WHEN v.Current_Rental_Status = 'b' AND vVoc.Actual_Check_IN IS NULL THEN vVoc.Contract_Number ELSE NULL 
                      END AS Contract_Number, 
	CASE WHEN v.Current_Rental_Status = 'b' AND vVoc.Actual_Check_IN IS NULL THEN vVoc.Expected_Check_In ELSE NULL 
                      END AS Expected_Check_In,
    V.FA_Remarks,
    dbo.VehCurrentBookValue(v.Unit_Number, Getdate()) -dbo.ZeroIfNull(v.Price_Difference) AS BookValue,
	v.Vehicle_Cost,
	v.MVA_Number

	--Select * from vehicle
                      
from 	vehicle v
	left join RP_Flt_8_Vehicle_Control_L1_Base_VOC vVoc
	ON v.Unit_Number = vVoc.Unit_Number 
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
		where Category = 'Manufacturer' 
      		) mf
		on mf.Code = vm.Manufacturer_ID
	left join (
		select code , value
		from lookup_table
		where Category = 'Dealer' 
      		) dl
		on dl.Code = v.Dealer_ID
	left join (
		select code , value
		from lookup_table
		where Category = 'Risk Type' 
      		) rt
		on rt.Code = v.Risk_type
	left join (SELECT     VH.Unit_Number, VH.Effective_On AS SignOffDate
				FROM         dbo.Vehicle_History AS VH INNER JOIN
                          (SELECT     Code, Value
                            FROM          dbo.Lookup_Table
                            WHERE      (Category = 'Vehicle Status')) AS CatVehicleStatus ON VH.Vehicle_Status = CatVehicleStatus.Code
						Inner Join Vehicle V on VH.Unit_number=V.Unit_Number
						INNER JOIN
                          (SELECT     Code, Value
                            FROM          dbo.Lookup_Table
                            WHERE      (Category = 'BudgetBC Company')) AS CatOwningCompany
						ON V.Owning_Company_ID = CatOwningCompany.Code
					WHERE     (CatVehicleStatus.Value = 'Signed Off')) SO 
			on So.unit_number=v.unit_number

where 	v.deleted = 0 
	and v.Owning_Company_ID = @CompanyCode
	and v.Current_Vehicle_Status != 'i'
	and v.Foreign_vehicle_unit_number is null
--order by vs.value, v.unit_number
order by vc.vehicle_type_id, v.program, vm.Model_Name, vm.Model_Year, v.Unit_number








GO
