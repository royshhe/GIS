USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_con_13_GPS_Tracking]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[RP_SP_con_13_GPS_Tracking] --   'gps', '*'
(
	@paramOpExtraType varchar(18) = 'GPS',
	@paramPULocationID varchar(20) = '16'
)
AS

DECLARE  @tmpLocID varchar(20)

if @paramPULocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramPULocationID
	END 


-- Creteria: Pickup Location, Optional Extra Type
				 --Optional Extra Inventory Tracking......

Select 
CLoc.Location as Current_Location,
OPT.Unit_Number,
OPT.serial_number,
OPT.Contract_Number,
OPT.Status Rental_Status,
PLoc.Location PickUpLocation, 
(Case When DLoc.Location is not null Then DLoc.Location Else Rental.EDOLoc End) as DropOffLocation, 
Rental.VehicleUnitNumber, 
Rental.CustomerName,
OPT.Optional_Extra,
OPT.PUDate Rent_From, 
OPT.DODate Rent_To,
OPT.Daily_Rate,
OPT.Weekly_Rate, 
OPT.Type,
OPT.Coupon_Code,
0 as Deleted_flag,
OPT.Expiry_Date
--DueBacDate,	
--Movement_Type  
From	 

(
	SELECT	
	OE.Optional_Extra,	 	 
	OEI.Unit_Number,
	OEI.serial_number, 
	OTA.PUDate, 
	OTA.DODate,
	(Case when OTA.Status='CO' Then PULoc
		 when OTA.Status='CI' Then DOLoc
	End) CurrentLoc, 
	OTA.PULoc,
	OTA.DOLoc, 
	(Case when OTA.Status='CO' Then 'On Rent'
		 when OTA.Status='CI' Then 'Available'
	End) Status,
	OTA.Contract_Number,
	OTA.Daily_Rate,
	OTA.Weekly_Rate, 
	OTA.Coupon_Code,
	OTA.Movement_Type,
	OE.Type,
	OEI.Expiry_date	 	  
	FROM dbo.Optional_Extra_Inventory OEI 
	INNER JOIN  dbo.Optional_Extra OE 
		 ON OEI.Optional_Extra_ID = OE.Optional_Extra_ID	
	Left Join 
	(Select 
		coe.Optional_Extra_ID,
		coe.unit_number,
		coe.PUDate,
		coe.DODate,
		coe.PULoc,
		coe.DOLoc,
		coe.Status,
		coe.Daily_Rate,
		coe.Weekly_Rate, 
		coe.Coupon_Code,
		coe.Contract_Number,  
		coe.Movement_Type	 
		from	
		(
					SELECT   
						Optional_Extra_ID,
						Unit_Number,
						ce.Contract_Number,
						Rent_From PUDate, 
						Sold_At_Location_ID PULoc,
						Rent_To DODate, 
						Return_Location_ID DOLoc, 
						Daily_Rate, 
						Weekly_Rate, 
						Coupon_Code,
						Sold_By Moved_by, 
						ce.Status, 
						'Contract' Movement_Type   
					
					FROM  dbo.Contract_Optional_Extra ce --AS coe
					Inner Join dbo.Contract con 
						on ce.Contract_number=con.Contract_Number			
					where   ce.Termination_Date>getdate()	and ce.unit_number is not null
					And con.status not in ('VD','CA')	 
					and ce.Rent_From<>ce.Rent_To
					--where   Termination_Date>getdate()	and unit_number is not null
					Union 
					SELECT 
						Optional_Extra_ID, 
						Unit_Number,
						NULL Contract_Number, 
						Movement_Out PUDate, 
						Sending_Location_ID PULoc,
						Movement_In DODate,    
						Receiving_Location_ID DOLoc, 
						NULL Daily_Rate, 
						NULL Weekly_Rate, 
						NULL Coupon_Code,
						Moved_By,
						'CI' as Status, 
						Movement_Type
					FROM  dbo.Optional_Extra_Item_Movement AS oim
	) coe


--dbo.Contract_Optional_Extra AS coe 
	INNER JOIN
	(
		SELECT Unit_Number, Optional_Extra_ID, max(PUDate) Last_PU_Date
		FROM  
		(
			SELECT   
				Optional_Extra_ID,
				Unit_Number,
				ce.Contract_Number,
				Rent_From PUDate, 
				Sold_At_Location_ID PULoc,
				Rent_To DODate, 
				Return_Location_ID DOLoc, 
				Sold_By Moved_by, 
				ce.Status, 
				'Contract' Movement_Type
			FROM  dbo.Contract_Optional_Extra ce --AS coe
					Inner Join dbo.Contract con 
						on ce.Contract_number=con.Contract_Number			
					where   ce.Termination_Date>getdate()	and ce.unit_number is not null
					And con.status not in ('VD','CA')	 
					and ce.Rent_From<>ce.Rent_To
					  
			Union 
			SELECT 
				Optional_Extra_ID, 
				Unit_Number,
				NULL Contract_Number, 
				Movement_Out PUDate, 
				Sending_Location_ID PULoc,
				Movement_In DODate,    
				Receiving_Location_ID DOLoc, 
				Moved_By,
				'CI' as Status, 
				Movement_Type
				FROM  dbo.Optional_Extra_Item_Movement AS oim
			) mv
		 
		--Where Termination_Date>getdate() 
			Group by Unit_Number, Optional_Extra_ID
		) LUR       
		ON	coe.Unit_Number =   LUR.Unit_Number And  coe.Optional_Extra_ID =	LUR.Optional_Extra_ID
		And coe.PUDate  = LUR.Last_PU_Date   --and    coe.Optional_Extra_ID=59
	) OTA  	
	On OEI.Unit_Number=OTA.Unit_Number   and OEI.Optional_Extra_ID = OTA.Optional_Extra_ID
 
Where  
OEI.Deleted_Flag=0 and OEI.Current_Item_Status in ('d','k') --And OEI.Optional_Extra_ID=59	
and OEI.owning_company_id in (select code from lookup_table where category='BudgetBC Company')

) OPT
Left Join 
(Select con.Contract_number,lvoc.Unit_number as VehicleUnitNumber, con.First_Name +' '+ con.Last_Name as CustomerName, ELoc.Location as  EDOLoc 
	from Contract con 
	inner Join RP__Last_Vehicle_On_Contract lvoc
	on con.Contract_number=lvoc.Contract_Number
	Inner Join Location ELoc
	On lvoc.Expected_Drop_Off_Location_ID =ELoc.Location_ID
	where con.status not in ('VD','CA')	 
	
	--select * from contract where contract_number='1610813'	and status not in ('VD','CA')	 
 
 ) Rental
 On OPT.Contract_Number= Rental.Contract_Number 
Left Join Location CLoc
On OPT.CurrentLoc=CLoc.Location_ID
Left Join Location DLoc
On OPT.DOLoc=DLoc.Location_ID
Left Join Location PLoc
On OPT.PULoc=PLoc.Location_ID
      
Where  ( OPT.Type=  @paramOpExtraType or @paramOpExtraType='*') And 
(@paramPULocationID = '*' or CONVERT(INT, @tmpLocID) =OPT.CurrentLoc)

order by Optional_Extra,   Unit_Number






RETURN @@ROWCOUNT


--select * from Optional_Extra_Inventory where unit_number='201116D'

--select * from Contract_Optional_Extra where unit_number='201116D'




GO
