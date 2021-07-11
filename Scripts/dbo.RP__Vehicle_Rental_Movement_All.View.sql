USE [GISData]
GO
/****** Object:  View [dbo].[RP__Vehicle_Rental_Movement_All]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from [RP_Flt_15_Vehicle_Rental_Movement_All]
--Future Movement caused by Rental
CREATE  VIEW [dbo].[RP__Vehicle_Rental_Movement_All]
AS


SELECT CONVERT(datetime, CONVERT(varchar(12), Contract.Pick_Up_On, 112)) AS Res_PU_Date, 	
	        CONVERT(datetime, CONVERT(varchar(12), Contract.Drop_Off_On, 112)) AS Rpt_Date, 
    		Vehicle.Vehicle_Class_Code, 
			Contract.Pick_Up_Location_ID AS   PU_ID, 
			Contract.Drop_Off_Location_ID AS  DO_ID, 
   			Contract.Contract_Number as DocNumber
			FROM 	Contract WITH(NOLOCK)
			JOIN
			RP__Last_Vehicle_On_Contract WITH(NOLOCK)
				ON 
				RP__Last_Vehicle_On_Contract.Contract_Number = Contract.Contract_Number
     				AND Contract.Status = 'CO' 
				AND DATEDIFF(dd, GETDATE(), Contract.Drop_Off_On) >= 0 
			JOIN
    			Vehicle  WITH(NOLOCK)
				ON 
    				RP__Last_Vehicle_On_Contract.Unit_Number = Vehicle.Unit_Number 
			JOIN
			Lookup_Table WITH(NOLOCK)
				ON
				Lookup_Table.Code = Vehicle.Owning_Company_ID
				AND Lookup_Table.Category = 'BudgetBC Company' 
		Where Contract.Pick_Up_Location_ID <>Contract.Drop_Off_Location_ID

Union 


	SELECT  CONVERT(datetime, CONVERT(varchar(12), Contract.Pick_Up_On, 112)) AS Cont_PU_Date, 
    CONVERT(datetime, CONVERT(varchar(12), Contract.Drop_Off_On, 112)) AS Rpt_Date, 
	Contract.Vehicle_Class_Code,
  		Contract.Pick_Up_Location_ID AS   PU_ID, 
		Contract.Drop_Off_Location_ID AS  DO_ID, 
   		Contract.Contract_Number as DocNumber

FROM 	Contract WITH(NOLOCK)
	JOIN
	Location WITH(NOLOCK)
		ON Contract.Pick_Up_Location_ID = Location.Location_ID
	JOIN
    	Lookup_Table WITH(NOLOCK)
		ON Lookup_Table.Code = Location.Owning_Company_ID 
		AND Lookup_Table.Category = 'BudgetBC Company'
		 
WHERE 	Contract.Status = 'OP' 
      	AND DATEDIFF(dd, GETDATE(), Contract.Drop_Off_On) >= 0 	
	AND DATEDIFF(dd, DATEADD(dd, 179, GETDATE()), Contract.Pick_Up_On) < 0
   	And Contract.Pick_Up_Location_ID <>Contract.Drop_Off_Location_ID

Union

SELECT	CONVERT(datetime, CONVERT(varchar(12), Reservation.Pick_Up_On, 112)) AS Res_PU_Date, 
	CONVERT(datetime, CONVERT(varchar(12), Reservation.Drop_Off_On, 112)) AS Rpt_Date,  
  	Reservation.Vehicle_Class_Code, 
  	Reservation.Pick_Up_Location_ID PU_ID,
	Reservation.Drop_Off_Location_ID  DO_ID, 
    Reservation.Confirmation_Number as DocNumber

FROM 	Reservation  WITH(NOLOCK)
	JOIN
	Location WITH(NOLOCK)
		ON Reservation.Pick_Up_Location_ID = Location.Location_ID
	JOIN
    	Lookup_Table WITH(NOLOCK)
		ON Lookup_Table.Code = Location.Owning_Company_ID 
		AND Lookup_Table.Category = 'BudgetBC Company'    		

WHERE	Reservation.Status = 'A'
    AND DATEDIFF(dd, GETDATE(), Reservation.Drop_Off_On) >= 0 
	AND DATEDIFF(dd, DATEADD(dd, 179, GETDATE()), Reservation.Pick_Up_On) < 0
    And Reservation.Pick_Up_Location_ID <>Reservation.Drop_Off_Location_ID

GO
