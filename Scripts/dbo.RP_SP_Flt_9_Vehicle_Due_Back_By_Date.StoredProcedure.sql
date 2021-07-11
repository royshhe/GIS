USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_9_Vehicle_Due_Back_By_Date]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Flt_9_Vehicle_Due_Back_By_Hourly
PURPOSE: Select all information needed for Vehicle Due Back by Hourly Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/22
USED BY:  Vehicle Due Back by Hourly Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/12/02	Exclude foreign vehicles
Joseph Tseung	2000/01/21	Exclude deleted vehicles
*/

create PROCEDURE [dbo].[RP_SP_Flt_9_Vehicle_Due_Back_By_Date] --'*','*','*','25 sep 2012'
(
	@paramVehicleTypeID varchar(18) = '*',
	@paramVehicleClassID varchar(1000) = '*',
	@paramDueBackLocationID varchar(500) = '*',
	@paramDueBackDate varchar(20) = '01 September 1999'
)

AS
-- convert strings to datetime

DECLARE 	@dueBackDate datetime

SELECT	@dueBackDate	= CONVERT(datetime, '00:00:00 ' + @paramDueBackDate)

-- fix upgrading problem (SQL7->SQL2000)
--DECLARE  @tmpLocID varchar(20)

--if @paramDueBackLocationID = '*'
--	BEGIN
--		SELECT @tmpLocID='0'
--        END
--else
--	BEGIN
--		SELECT @tmpLocID = @paramDueBackLocationID
--	END 
-- end of fixing the problem



SELECT	convert(varchar(30),Contract.contract_number) as Contract_Number,
		contract.First_name+' '+contract.Last_name as RenterName,
		Vehicle_On_Contract.Expected_Check_In,
    	--CONVERT(datetime, CONVERT(varchar(12), Vehicle_On_Contract.Expected_Check_In, 112)) AS Expected_Check_In_Date,
		--DATEPART(hh,  Vehicle_On_Contract.Expected_Check_In) AS Expected_Check_In_Hour,
		Vehicle_Class.Vehicle_Type_ID,
    	Vehicle_Class.Vehicle_Class_Code + '-' + Vehicle_Class.Vehicle_Class_Name AS Vehicle_Class_Code_Name,
    	Vehicle_On_Contract.Expected_Drop_Off_Location_ID AS Expected_Check_In_Location_ID,
     	Location.Location AS Expected_Check_In_Location_Name,
		Vehicle_On_Contract.Unit_Number,
		vehicle.MVA_Number,
		VMY.Model_Name,
		Vehicle_On_Contract.Checked_Out,
		L2.Location as Location_Out,
    	vehicle.Current_Km, 
    	vehicle.Do_Not_Rent_Past_Km,  
    	vehicle.Ownership_Date,
    	vehicle.Do_Not_Rent_Past_Days,
		case when  isnull(Do_Not_Rent_Past_Km,999999)- (Current_Km)>=1000
					and  isnull(Do_Not_Rent_Past_Km,999999)- (Current_Km)<2000	
				then 'K1'
			 when  isnull(Do_Not_Rent_Past_Km,999999)- (Current_Km)>=500
					and  isnull(Do_Not_Rent_Past_Km,999999)- (Current_Km)<1000		
				then 'K2' 	
			 when  isnull(Do_Not_Rent_Past_Km,999999)- (Current_Km)>=250
					and  isnull(Do_Not_Rent_Past_Km,999999)- (Current_Km)<5000		
				then 'K3' 	
			 when  isnull(Do_Not_Rent_Past_Km,999999)- (Current_Km)<250	
				then 'KR' 
			 else ''
		end	 as TurnBackKMWarning,

		case when  isnull(Do_Not_Rent_Past_Days,9999)- DATEDIFF(dd, getdate(), Ownership_Date)<5
				then 'DR'
			 when  isnull(Do_Not_Rent_Past_Days,9999)- DATEDIFF(dd, getdate(), Ownership_Date)>=5
					and isnull(Do_Not_Rent_Past_Days,9999)- DATEDIFF(dd, getdate(), Ownership_Date)<10
				then 'D4'
			 when  isnull(Do_Not_Rent_Past_Days,9999)- DATEDIFF(dd, getdate(), Ownership_Date)>=10
					and isnull(Do_Not_Rent_Past_Days,9999)- DATEDIFF(dd, getdate(), Ownership_Date)<15
				then 'D3'
			 when  isnull(Do_Not_Rent_Past_Days,9999)- DATEDIFF(dd, getdate(), Ownership_Date)>=15
					and isnull(Do_Not_Rent_Past_Days,9999)- DATEDIFF(dd, getdate(), Ownership_Date)<20
				then 'D2'
			 when  isnull(Do_Not_Rent_Past_Days,9999)- DATEDIFF(dd, getdate(), Ownership_Date)>=20
					and isnull(Do_Not_Rent_Past_Days,9999)- DATEDIFF(dd, getdate(), Ownership_Date)<30
				then 'D1'
			 else ''
		end	 as TurnBackDayWarning,
		
		vehicle.foreign_vehicle_unit_number   
					
		
FROM 	Contract with(nolock)
	INNER JOIN
    	Vehicle_On_Contract
		ON Contract.Contract_Number = Vehicle_On_Contract.Contract_Number
     	INNER JOIN
    	Vehicle
		ON Vehicle_On_Contract.Unit_Number = Vehicle.Unit_Number
		INNER JOIN   dbo.Vehicle_Model_Year VMY 
			ON Vehicle.Vehicle_Model_ID = VMY.Vehicle_Model_ID 
		INNER JOIN
		Vehicle_Class
		ON Vehicle.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
     	INNER JOIN
    	Location
		ON Vehicle_On_Contract.Expected_Drop_Off_Location_ID = Location.Location_ID
		AND Location.Rental_Location = 1 	-- location has to be rental location
     	INNER JOIN
    	Location L2
		ON Vehicle_On_Contract.Pick_up_Location_ID = L2.Location_ID
	INNER JOIN
	Lookup_Table lt1
		ON lt1.Code = Location.Owning_Company_ID
		AND lt1.Category = 'BudgetBC Company'	-- drop off location has to be a BRAC BC location
	INNER JOIN
	Lookup_Table lt2
		ON lt2.Code = Vehicle.Owning_Company_ID
		AND lt2.Category = 'BudgetBC Company'	-- BRAC BC vehicles
		

WHERE 	(Contract.Status = 'CO')
	AND
	(Vehicle_On_Contract.Actual_Check_In IS NULL)
	AND
	Vehicle.Deleted = 0
	AND
	(@paramVehicleTypeID = "*" OR Vehicle_Class.Vehicle_Type_ID = @paramVehicleTypeID)
	AND
 	(@paramVehicleClassID = "*" OR Vehicle_Class.Vehicle_Class_Code in (select * from dbo.Split(@paramVehicleClassID,'~')))
	AND
 	(@paramDueBackLocationID = "*" or  Vehicle_On_Contract.Expected_Drop_Off_Location_ID in (select * from dbo.Split(@paramDueBackLocationID,'~')))
	AND
	DATEDIFF(dd, @dueBackDate, Vehicle_On_Contract.Expected_Check_In) <= 0
	
union
	--Vehicle Movement
	select 'Movement' as contract_number,
		vm.Driver_Name as RenterName,
		null as Expected_Check_In,
		vc.Vehicle_Type_ID,
    	vc.Vehicle_Class_Code + '-' + vc.Vehicle_Class_Name AS Vehicle_Class_Code_Name,
    	vm.Receiving_location_ID AS Expected_Check_In_Location_ID,
     	Location.Location AS Expected_Check_In_Location_Name,
		vm.Unit_Number,
		v.MVA_Number,
		VMY.Model_Name,
		vm.Movement_Out,
		L2.Location as Location_Out,
    	v.Current_Km, 
    	v.Do_Not_Rent_Past_Km,  
    	v.Ownership_Date,
    	v.Do_Not_Rent_Past_Days,
		case when  isnull(Do_Not_Rent_Past_Km,999999)- (Current_Km)>=1000
					and  isnull(Do_Not_Rent_Past_Km,999999)- (Current_Km)<2000	
				then 'K1'
			 when  isnull(Do_Not_Rent_Past_Km,999999)- (Current_Km)>=500
					and  isnull(Do_Not_Rent_Past_Km,999999)- (Current_Km)<1000		
				then 'K2' 	
			 when  isnull(Do_Not_Rent_Past_Km,999999)- (Current_Km)>=250
					and  isnull(Do_Not_Rent_Past_Km,999999)- (Current_Km)<5000		
				then 'K3' 	
			 when  isnull(Do_Not_Rent_Past_Km,999999)- (Current_Km)<250	
				then 'KR' 
			 else ''
		end	 as TurnBackKMWarning,

		case when  isnull(Do_Not_Rent_Past_Days,9999)- DATEDIFF(dd, getdate(), Ownership_Date)<5
				then 'DR'
			 when  isnull(Do_Not_Rent_Past_Days,9999)- DATEDIFF(dd, getdate(), Ownership_Date)>=5
					and isnull(Do_Not_Rent_Past_Days,9999)- DATEDIFF(dd, getdate(), Ownership_Date)<10
				then 'D4'
			 when  isnull(Do_Not_Rent_Past_Days,9999)- DATEDIFF(dd, getdate(), Ownership_Date)>=10
					and isnull(Do_Not_Rent_Past_Days,9999)- DATEDIFF(dd, getdate(), Ownership_Date)<15
				then 'D3'
			 when  isnull(Do_Not_Rent_Past_Days,9999)- DATEDIFF(dd, getdate(), Ownership_Date)>=15
					and isnull(Do_Not_Rent_Past_Days,9999)- DATEDIFF(dd, getdate(), Ownership_Date)<20
				then 'D2'
			 when  isnull(Do_Not_Rent_Past_Days,9999)- DATEDIFF(dd, getdate(), Ownership_Date)>=20
					and isnull(Do_Not_Rent_Past_Days,9999)- DATEDIFF(dd, getdate(), Ownership_Date)<30
				then 'D1'
			 else ''
		end	 as TurnBackDayWarning ,
		v.foreign_vehicle_unit_number   
	from vehicle_movement vm 
			inner join vehicle v on vm.unit_number =v.unit_number
			INNER JOIN   dbo.Vehicle_Model_Year VMY	ON v.Vehicle_Model_ID = VMY.Vehicle_Model_ID 
			INNER JOIN Vehicle_Class VC ON v.Vehicle_Class_Code = VC.Vehicle_Class_Code
     		INNER JOIN Location ON vm.Receiving_location_ID = Location.Location_ID
	     	INNER JOIN Location L2	ON vm.Sending_Location_ID = L2.Location_ID
	
	where movement_in is null
		AND
		(@paramVehicleTypeID = "*" OR VC.Vehicle_Type_ID = @paramVehicleTypeID)
		AND
 		(@paramVehicleClassID = "*" OR VC.Vehicle_Class_Code in (select * from dbo.Split(@paramVehicleClassID,'~')))
		AND
 		(@paramDueBackLocationID = "*" or  vm.Receiving_location_ID in (select * from dbo.Split(@paramDueBackLocationID,'~')))
	
	

--GROUP BY 	
--	Vehicle_On_Contract.Expected_Check_In,
--    	CONVERT(datetime, CONVERT(varchar(12), Vehicle_On_Contract.Expected_Check_In, 112)),
--	DATEPART(hh, Vehicle_On_Contract.Expected_Check_In),
--    	Vehicle_Class.Vehicle_Type_ID,
--    	Vehicle_Class.Vehicle_Class_Name,
--    	Vehicle_On_Contract.Expected_Drop_Off_Location_ID,
--    	Location.Location,
--	Vehicle_Class.Vehicle_Class_Code
order by Expected_Check_In_Location_Name,Vehicle_Type_ID,Vehicle_On_Contract.Expected_Check_In

RETURN @@ROWCOUNT

GO
