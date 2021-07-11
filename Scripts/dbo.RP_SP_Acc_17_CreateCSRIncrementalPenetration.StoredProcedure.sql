USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_17_CreateCSRIncrementalPenetration]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*

Per Kevin required, From Sep 2013, all location will apply the same Terms & Condition as YVR/DT /peter 2013/09/18
*/





CREATE  PROCEDURE [dbo].[RP_SP_Acc_17_CreateCSRIncrementalPenetration] -- '2016-05-26', '2016-06-22','*','*'
(
	@paramStartBusDate varchar(20) = '22 Apr 2001',
	@paramEndBusDate varchar(20) = '23 Apr 2001',
	@paramVehicleTypeID varchar(18) = 'car',
	@paramPickUpLocationID varchar(20) = '*'
)
AS
-- convert strings to datetime
DECLARE 	@startBusDate datetime,
		@endBusDate datetime,
		@tmpLocID varchar(20)

SELECT	@startBusDate	= CONVERT(datetime, '00:00:00 ' + @paramStartBusDate),
		@endBusDate	= CONVERT(datetime, '23:59:59 ' + @paramEndBusDate)	

		
	if @paramPickUpLocationID = '*'
		BEGIN
			SELECT @tmpLocID='0'
			END
	else
		BEGIN
			SELECT @tmpLocID = @paramPickUpLocationID
		END 



SELECT 	
        csr.EmployeeID,
		csr.active,
		r1.pick_up_location_id as Location_ID,
		l.Location,
		r1.Vehicle_Type_ID,
   		case when csr.active = 0
			then r1.CSR_Name + ' (T)'
			else r1.CSR_Name
			end 					as CSR_Name,
   		Count(r1.Contract_number) 			as Contract_In,

		sum(
				Case 
					when   rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate') And  (rate_name Not Like '%Month%') And r1.Upgrade <>0 Then 1
					Else 0
        			End
			) 	as UpGradeCount,

		sum(
				Case 
					when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  And r1.All_Seats<>0 then 1
					Else 0
	     			End
			 ) 	as All_Seats_Count,

		sum(Case When r1.All_Level_LDW>0 Then 1 Else 0 End)				as All_Level_LDW_Count,
		sum(Case When r1.Buydown>0 Then 1 Else 0 End)				as Buydown_Count,
		sum(Case When r1.PAI>0 Then 1 Else 0 End)				as PAE_Count,
		sum(Case When r1.RSN>0 Then 1 Else 0 End)				as RSN_Count,
		sum(Case When r1.ELI>0 Then 1 Else 0 End)				as ELI_Count,
		sum(	Case 
					when rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')   and (rate_name Not Like '%Month%')  And  r1.Additional_Driver_Charge<>0 Then 1
				Else 0
    				End) 		as Additional_Driver_Charge_Count,
		SUM(
			 Case When
			 (
						(
								Case 
									when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  and Driver_Under_Age>0 Then 1
								Else 0
	     							End
							 ) 	
							+	
						(
								Case 
									when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI','Budget Monthly Rate')  and (rate_name Not Like '%Month%')   And r1.Ski_Rack>0 Then 1
								Else 0
	     							End
							 ) 	
							+

						(
								Case 
									when  rate_name not in ('Yaris Promo','FM Rate','GBI',  'GCI', 'special monthly rate', 'GAI', 'FMI','Budget Monthly Rate')  and (rate_name Not Like '%Month%')  and  r1.Seat_Storage>0 Then 1
									Else 0
	     							End
							 ) 	+

						(
								Case 
									when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  And r1.Our_Of_Area>0 Then 1
									Else 0
	     							End
							 ) 	
	    					+
							(
								Case 
									when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  And  r1.All_Dolly>0 Then 1
									Else 0
	     							End
							 ) 	

							+
							(
								Case 
									when  rate_name not in ('Yaris Promo','FM Rate','GBI', 'GCI', 'special monthly rate', 'GAI','FMI', 'Budget Monthly Rate')  and (rate_name Not Like '%Month%')  And  r1.All_Gates>0 then 1
								Else 0
	     							End
							 ) 	
						  +
						 (
								Case 
									when  rate_name not in ('Yaris Promo','FM Rate','GBI',  'GCI', 'special monthly rate', 'GAI', 'FMI','Budget Monthly Rate')   and (rate_name Not Like '%Month%')  And r1.Blanket>0 Then 1
									Else 0
	     							End
							 ) 	
						+
						 (Case When r1.GPS>0 then 1 Else 0 End)  
					 ) >0 
			Then 1 
			Else
				0
			End )   as Other_Extra_Count,

		SUM(
			Case 
				when  rate_name not in ('Yaris Promo','FM Rate','GBI',  'GCI', 'special monthly rate', 'GAI', 'FMI','Budget Monthly Rate')   and (rate_name Not Like '%Month%')  And r1.Snow_Tire>0 Then 1
				Else 0
				End
			 )   as Snow_Tire_Count,

		sum(case when r1.FPOCount=1 and r1.FPO > .00
			 then 1
	    		 when r1.FPOCount=-1 and r1.FPO < .00
			 then -1	
			 else 0 
			 end)					as FPOCount	        	
--select *	
FROM 	RP_Acc_17_CSR_Incentive_Report_L2 r1
inner join 
ViewBugetBCLocation l
	on l.location_id = r1.pick_up_location_id
inner join
(select distinct u.user_id, left(ltrim(u.user_name),20) as User_name, u.active, u.employeeID
from GISUsers u
) csr
	on csr.user_name = r1.CSR_Name
WHERE		(@paramVehicleTypeID = '*' OR r1.Vehicle_Type_ID = @paramVehicleTypeID)
and	(@paramPickUpLocationID = '*' or CONVERT(INT, @tmpLocID) = l.Location_ID)
and (r1.RBR_Date BETWEEN  @startBusDate and @endBusDate ) --and  (r1.CSR_Name like 'Brahim Jounh')

GROUP BY 	csr.EmployeeID,
		csr.active,
		r1.pick_up_location_id,
		l.Location,
   		r1.CSR_Name,
		r1.Vehicle_Type_ID

order by r1.Vehicle_Type_ID,l.Location,All_Level_LDW_Count desc



GO
