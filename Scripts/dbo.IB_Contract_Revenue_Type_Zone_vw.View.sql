USE [GISData]
GO
/****** Object:  View [dbo].[IB_Contract_Revenue_Type_Zone_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
VIEW NAME: IB_Contract_Revenue_vw
PURPOSE:group  All the Contract Reveunes according to Transaction type, IB Zone
	 
AUTHOR:	
DATE CREATED:
USED BY:
MOD HISTORY:
Name 		Date		Comments
*/



CREATE VIEW [dbo].[IB_Contract_Revenue_Type_Zone_vw]
AS
SELECT  IB_Contract_Reveue.Contract_number,  
	IB_Contract_Reveue.Unit_number,                      
	IB_Contract_Reveue.RBR_Date, 
	IB_Contract_Reveue.Contract_Currency_ID, 
	IB_Contract_Reveue.LOR_Percentage,
	VehicleOwnership.IB_Zone AS Vehicle_Owner_IB_Zone, 
	IB_Contract_Reveue.Vehicle_Ownership AS Vehicle_Owner_Company, PU_Location_Owning_Company.Owning_Company_ID AS Renting_Compay, 
	DO_Location_Owning_Company.Owning_Company_ID AS Receiving_Company, VehicleOwnership.Vendor_code AS Vehicle_Ownership_Vendor_Code, 
	VehicleOwnership.Customer_code AS Vehicle_Ownership_Customer_code, 
	PU_Location_Owning_Company.Vendor_code AS Renting_Compay_Vendor_Code, 
	PU_Location_Owning_Company.Customer_code AS Renting_Compay_Customer_Code, 
	DO_Location_Owning_Company.Vendor_code AS Receiving_Company_Vendor_Code, 
	DO_Location_Owning_Company.Customer_code AS Receiving_Company_Customer_Code, IB_Contract_Reveue.Pickup_Location, 
	IB_Contract_Reveue.Dropoff_Location, 
	CASE 
		WHEN VehicleOwnership.IB_Zone = 'LC' AND Pickup_Location.IB_Zone = 'LC' AND   DropOff_location.IB_Zone <> 'LC' THEN 'One Way' 
		WHEN VehicleOwnership.IB_Zone <> 'LC' AND Pickup_Location.IB_Zone <> 'LC' AND 
		                      DropOff_location.IB_Zone = 'LC' THEN 'One Way' 
		WHEN VehicleOwnership.IB_Zone = 'LC' AND Pickup_Location.IB_Zone <> 'LC' AND 
		                      DropOff_location.IB_Zone <> 'LC' AND 
		                      Pickup_Location.Owning_Company_ID = DropOff_location.Owning_Company_ID THEN 'Local Rental' 
		WHEN VehicleOwnership.IB_Zone <> 'LC' AND 
		                      Pickup_Location.IB_Zone = 'LC' AND DropOff_location.IB_Zone = 'LC' THEN 'Local Rental' 
		WHEN VehicleOwnership.IB_Zone = 'LC' AND 
		                      Pickup_Location.IB_Zone <> 'LC' AND DropOff_location.IB_Zone <> 'LC' AND 
		                      Pickup_Location.Owning_Company_ID <> DropOff_location.Owning_Company_ID THEN 'Rent Back' 
		WHEN VehicleOwnership.IB_Zone = 'LC' AND 
		                      Pickup_Location.IB_Zone <> 'LC' AND DropOff_location.IB_Zone = 'LC' THEN 'Rent Back' 
		WHEN VehicleOwnership.IB_Zone <> 'LC' AND 
		                      Pickup_Location.IB_Zone = 'LC' AND DropOff_location.IB_Zone <> 'LC' THEN 'Rent Back' 
		END AS Transaction_Type, 
		
		                      CASE 
		WHEN VehicleOwnership.IB_Zone = 'LC' AND Pickup_Location.IB_Zone = 'LC' AND 
		                      DropOff_location.IB_Zone <> 'LC' THEN DropOff_location.IB_Zone 
		WHEN VehicleOwnership.IB_Zone <> 'LC' AND Pickup_Location.IB_Zone <> 'LC' AND
		                       DropOff_location.IB_Zone = 'LC' THEN VehicleOwnership.IB_Zone 
		WHEN VehicleOwnership.IB_Zone = 'LC' AND Pickup_Location.IB_Zone <> 'LC' AND
		                       DropOff_location.IB_Zone <> 'LC' AND 
		                      Pickup_Location.Owning_Company_ID = DropOff_location.Owning_Company_ID THEN Pickup_Location.IB_Zone 
		WHEN VehicleOwnership.IB_Zone <> 'LC'
		                       AND Pickup_Location.IB_Zone = 'LC' AND 
		                      DropOff_location.IB_Zone = 'LC' THEN VehicleOwnership.IB_Zone 
		WHEN VehicleOwnership.IB_Zone = 'LC' AND Pickup_Location.IB_Zone <> 'LC' AND 
		                      DropOff_location.IB_Zone <> 'LC' AND 
		                      Pickup_Location.Owning_Company_ID <> DropOff_location.Owning_Company_ID THEN Pickup_Location.IB_Zone 
		WHEN VehicleOwnership.IB_Zone = 'LC'
		                       AND Pickup_Location.IB_Zone <> 'LC' AND 
		                      DropOff_location.IB_Zone = 'LC' THEN Pickup_Location.IB_Zone 
		WHEN VehicleOwnership.IB_Zone <> 'LC' AND Pickup_Location.IB_Zone = 'LC' AND 
		                      DropOff_location.IB_Zone <> 'LC' THEN
				(CASE WHEN  IB_Contract_Reveue.Vehicle_Ownership =DO_Location_Owning_Company.Owning_Company_ID THEN DropOff_location.IB_Zone 
				           ELSE VehicleOwnership.IB_Zone 
				END)
		END AS IB_Zone,

	IB_Contract_Reveue.Revenue_Account, 
	IB_Contract_Reveue.Amount
       

FROM   dbo.IB_Contract_Revenue_vw IB_Contract_Reveue INNER JOIN
                      dbo.Location Pickup_Location ON IB_Contract_Reveue.Pickup_Location = Pickup_Location.Location_ID INNER JOIN
                      dbo.Location DropOff_location ON IB_Contract_Reveue.Dropoff_Location = DropOff_location.Location_ID INNER JOIN
                      dbo.Owning_Company VehicleOwnership ON IB_Contract_Reveue.Vehicle_Ownership = VehicleOwnership.Owning_Company_ID INNER JOIN
                      dbo.Owning_Company PU_Location_Owning_Company ON 
                      Pickup_Location.Owning_Company_ID = PU_Location_Owning_Company.Owning_Company_ID INNER JOIN
                      dbo.Owning_Company DO_Location_Owning_Company ON 
                      DropOff_location.Owning_Company_ID = DO_Location_Owning_Company.Owning_Company_ID





GO
