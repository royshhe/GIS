USE [GISData]
GO
/****** Object:  View [dbo].[IB_Contracts_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
VIEW NAME: IB_Contracts_vw
PURPOSE: Select contracts that involved at least one vehicle for which 
       	- pick up location is foreign 
 	OR	
       	- drop off location is foreign 
	 		
AUTHOR:	
DATE CREATED:
USED BY:
MOD HISTORY:
Name 		Date		Comments
Rhe		2006-10-01      Created
Rhe		2006-10-11	Modified Remove revenue splitting between different unit number where there is more than one unit, 
				all the units will get 100% revenue,  duplicate will be removed manually
		
*/
CREATE VIEW [dbo].[IB_Contracts_vw]
AS
--DATEDIFF(mi, c.Pick_Up_On,rlv.Actual_Check_In) / 1440.000	as Contract_Rental_Days,

 
SELECT DISTINCT     
			dbo.Contract.Contract_Number, 
			 dbo.Contract.Vehicle_Class_Code, 
			dbo.Vehicle_On_Contract.Pick_Up_Location_ID, 
			dbo.Vehicle_On_Contract.Actual_Drop_Off_Location_ID,  
			
			--TEMPORARY FIXING FOR THE CURRENCY CONVERTION
			(CASE 
				WHEN dbo.Location.IB_ZONE='US' THEN   
				2
				ELSE
				dbo.Contract.Contract_Currency_ID 
			END)Contract_Currency_ID,
			
			dbo.Vehicle_On_Contract.Unit_Number, 
			dbo.Vehicle.Owning_Company_ID,
			(CASE  
				WHEN DATEDIFF(mi,  dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) <>0
			  	THEN  1  --Convert(decimal(9,2),Convert(decimal(9,2),DATEDIFF(mi, dbo.Vehicle_On_Contract.Checked_Out, dbo.Vehicle_On_Contract.Actual_Check_In))/Convert(decimal(9,2), DATEDIFF(mi,  dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In)) )
				ELSE	1
			END) as LOR_Percentage
			 

FROM         dbo.Contract  
		INNER JOIN
		dbo.Vehicle_On_Contract 
			ON dbo.Contract.Contract_Number = dbo.Vehicle_On_Contract.Contract_Number 
		INNER JOIN
		dbo.Location 
			ON dbo.Contract.Pick_Up_Location_ID = dbo.Location.Location_ID 


		INNER JOIN
		dbo.Vehicle
			ON dbo.Vehicle_On_Contract.Unit_Number = dbo.Vehicle.Unit_Number
		INNER JOIN
                      	dbo.RP__Last_Vehicle_On_Contract 
			ON dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number

WHERE (Vehicle_On_Contract.Pick_Up_Location_ID IN
       			(SELECT Location.Location_ID
     			FROM 	Location 
				INNER JOIN
		        		Owning_Company 
					ON Location.Owning_Company_ID = Owning_Company.Owning_Company_ID
         				INNER JOIN
        				Lookup_Table 
					ON Owning_Company.Owning_Company_ID <> Lookup_Table.Code
     			WHERE (Lookup_Table.Category = 'BudgetBC Company')))
	OR
   	(Vehicle_On_Contract.Actual_Drop_Off_Location_ID IN
       			(SELECT Location.Location_ID
     			FROM 	Location 
				INNER JOIN
        				Owning_Company 
					ON Location.Owning_Company_ID = Owning_Company.Owning_Company_ID
         				INNER JOIN
        				Lookup_Table 
        					ON Owning_Company.Owning_Company_ID <> Lookup_Table.Code
     				WHERE (Lookup_Table.Category = 'BudgetBC Company'))
		)




UNION 

-- Select contracts that during the lifecycle of the contract have have involved a foreign vehicle

SELECT DISTINCT   
			dbo.Contract.Contract_Number, 
			dbo.Contract.Vehicle_Class_Code, 
			dbo.Vehicle_On_Contract.Pick_Up_Location_ID, 
			dbo.Vehicle_On_Contract.Actual_Drop_Off_Location_ID,   

--TEMPORARY FIXING FOR THE CURRENCY CONVERTION
			(CASE 
				WHEN dbo.Location.IB_ZONE='US' THEN   
				2
				ELSE
				dbo.Contract.Contract_Currency_ID 
			END) Contract_Currency_ID,
			

			dbo.Vehicle_On_Contract.Unit_Number, 
			dbo.Vehicle.Owning_Company_ID,

			(CASE  
				WHEN DATEDIFF(mi,  dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) <>0
			  	THEN  1  --Convert(decimal(9,2),Convert(decimal(9,2),DATEDIFF(mi, dbo.Vehicle_On_Contract.Checked_Out, dbo.Vehicle_On_Contract.Actual_Check_In))/Convert(decimal(9,2), DATEDIFF(mi,  dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In)) )
				ELSE	1
			END) as LOR_Percentage
			 
			
FROM 	Contract WITH(NOLOCK)
	INNER JOIN
	dbo.Location 
		ON dbo.Contract.Pick_Up_Location_ID = dbo.Location.Location_ID 

	INNER JOIN
	
   	Vehicle_On_Contract 
		ON Contract.Contract_Number = Vehicle_On_Contract.Contract_Number
    	INNER JOIN
   	Vehicle 
		ON Vehicle_On_Contract.Unit_Number = Vehicle.Unit_Number 
            
	INNER JOIN
   	Owning_Company 
		ON Owning_Company.Owning_Company_ID = Vehicle.Owning_Company_ID
    	INNER JOIN
  	Lookup_Table 
		ON Lookup_Table.Code <> Owning_Company.Owning_Company_ID
	INNER JOIN
                      	dbo.RP__Last_Vehicle_On_Contract 
			ON dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number
WHERE (Lookup_Table.Category = 'BudgetBC Company')

UNION 

-- Select contract for which Any Payment or Refund has been made at a foreign location
SELECT DISTINCT 
			                    
			dbo.Contract.Contract_Number, 
            dbo.Contract.Vehicle_Class_Code, 
			dbo.Vehicle_On_Contract.Pick_Up_Location_ID, 
			dbo.Vehicle_On_Contract.Actual_Drop_Off_Location_ID,   
			(CASE 
				WHEN PickupLocation.IB_ZONE='US' THEN   
				2
				ELSE
				dbo.Contract.Contract_Currency_ID 
			END) Contract_Currency_ID,					
			
			dbo.Vehicle_On_Contract.Unit_Number, 
			dbo.Vehicle.Owning_Company_ID,  

			(CASE  
				WHEN DATEDIFF(mi,  dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In) <>0
			  	THEN   1  --Convert(decimal(9,2),Convert(decimal(9,2),DATEDIFF(mi, dbo.Vehicle_On_Contract.Checked_Out, dbo.Vehicle_On_Contract.Actual_Check_In))/Convert(decimal(9,2), DATEDIFF(mi,  dbo.Contract.Pick_Up_On, dbo.RP__Last_Vehicle_On_Contract.Actual_Check_In)) )
				ELSE	1
			END) as LOR_Percentage
			 
			
FROM        	 dbo.Location Location1 
		INNER JOIN
		dbo.Contract_Payment_Item 
			ON Location1.Location_ID = dbo.Contract_Payment_Item.Collected_At_Location_ID 
		INNER JOIN
		dbo.Owning_Company 
			ON Location1.Owning_Company_ID = dbo.Owning_Company.Owning_Company_ID 
		INNER JOIN
		dbo.Lookup_Table 
			ON dbo.Owning_Company.Owning_Company_ID <> dbo.Lookup_Table.Code 
		INNER JOIN
		dbo.Contract 
			ON dbo.Contract_Payment_Item.Contract_Number = dbo.Contract.Contract_Number 
		INNER JOIN
		dbo.Vehicle_On_Contract 
			ON dbo.Contract.Contract_Number = dbo.Vehicle_On_Contract.Contract_Number 
		INNER JOIN
		dbo.Vehicle 
			ON dbo.Vehicle_On_Contract.Unit_Number = dbo.Vehicle.Unit_Number
		INNER JOIN
			dbo.RP__Last_Vehicle_On_Contract 
			ON dbo.Contract.Contract_Number = dbo.RP__Last_Vehicle_On_Contract.Contract_Number
		INNER JOIN
                      dbo.Location PickupLocation ON dbo.Contract.Pick_Up_Location_ID = PickupLocation.Location_ID

WHERE     (dbo.Lookup_Table.Category = 'BudgetBC Company')
GO
