USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Adhoc_Customer_Profile_On_CheckOut]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











/*
PROCEDURE NAME: RP_SP_Adhoc_Vehicle_At_Foreign
PURPOSE: Select information about the owning company of all BRAC vehicles for 
	 Main report of Vehicle Control Report
AUTHOR:	Joseph Tseung
DATE CREATED: 2000/03/09
USED BY:  Main report of Vehicle Control Report
MOD HISTORY:
Name 		Date		Comments

*/
CREATE PROCEDURE [dbo].[RP_SP_Adhoc_Customer_Profile_On_CheckOut] --'*','*','*','01 jul 2011','01 aug 2011'
(
	@paramVehicleTypeID varchar(10) = '*',
	@paramVehicleClassID char(1) = '*',
	@paramPickUpLocationID varchar(25) = '*',
	@paramStartBusDate varchar(25) = 'Mar 01 2002',
	@paramEndBusDate varchar(25) = 'Mar 31 2002'
)
AS
declare  @StartDate datetime, @EndDate datetime
select  @StartDate=CONVERT(DATETIME, @paramStartBusDate )
select @EndDate=CONVERT(DATETIME, @paramEndBusDate )

-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpLocID varchar(20)

if @paramPickUpLocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramPickUpLocationID
	END 
-- end of fixing the problem


SELECT	cp.Contract_Number, 
		cp.Confirmation_Number, 
		Pick_up_location, 
		Pick_Up_On, 
		Drop_off_Location, 
		Drop_Off_On, 
		Last_Name, 
		First_Name, 
		Addition_type,
		Gender, 
		age, 
		Jurisdiction,	 
        Phone_Number, 
        Address_1, 
        Address_2, 
        City, 
        Province_State, 
        lt.value as Country, 
        Postal_Code, 
        Email_Address, 
        Company_Name, 
        Company_Phone_Number, 
        Local_Phone_Number, 
        Local_Address_1, 
        VC.Vehicle_Class_name,
        Swiped_Flag, 
        case when convert(varchar,logged_on,111) =convert(varchar,bt.transaction_date,111)
				then comments
				else ''
			end as comments,
        bt.rbr_date
--select *
FROM	RP_Adhoc_Customer_Profile_On_Checkout CP		INNER JOIN
    	Business_Transaction bt ON bt.Contract_Number = cp.Contract_Number INNER JOIN 
    	Vehicle_Class VC	ON cp.Vehicle_Class_Code=VC.vehicle_class_code left outer join
    	(select code,value from lookup_table where category='country' ) LT on LT.code=cp.country
    	
				
where	(bt.Transaction_Type = 'con') 	AND 
    	(bt.Transaction_Description = 'Check Out') and
		CP.Status not in ('vd', 'ca')  and 
		
	(@paramVehicleTypeID = '*' or VC.Vehicle_Type_ID = @paramVehicleTypeID)
	AND
 	(@paramVehicleClassID = '*' OR VC.Vehicle_Class_Code = @paramVehicleClassID)
	and
	(@paramPickUpLocationID = '*' or pick_up_location_id = @tmpLocID)
	and bt.rbr_date between @StartDate and @EndDate
	
ORDER BY cp.Contract_Number,Addition_type
                      
RETURN @@ROWCOUNT



GO
