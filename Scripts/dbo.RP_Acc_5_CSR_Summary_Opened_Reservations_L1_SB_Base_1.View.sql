USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_5_CSR_Summary_Opened_Reservations_L1_SB_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
VIEW NAME: RP_Acc_5_CSR_Summary_Opened_Reservations_L1_SB_Base_1
PURPOSE: Select all the information needed for Opened Reservations Subreport 

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Opened Reservations Subreport of CSR Summary Activity Report
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Acc_5_CSR_Summary_Opened_Reservations_L1_SB_Base_1]
AS
SELECT  
	Business_Transaction.RBR_Date, 
    	Reservation_Change_History.Pick_Up_Location_ID, 
    	Reservation_Change_History.Changed_By AS Reservation_CSR_Name,
     	Vehicle_Class.Vehicle_Type_ID, 
    	Contract.Confirmation_Number, 
    	Business_Transaction.Contract_Number, 
    	Reservation.Last_Changed_On AS Last_Reservation_Update, 
    	Business_Transaction.User_ID AS Contract_CSR_Name
FROM 	Reservation_Change_History WITH(NOLOCK)
     	INNER JOIN
    	Reservation 	
		ON Reservation_Change_History.Confirmation_Number = Reservation.Confirmation_Number
     	INNER JOIN
    	Business_Transaction 
	INNER JOIN
    	Contract 
		ON Business_Transaction.Contract_Number = Contract.Contract_Number
     	INNER JOIN
    	Vehicle_Class 
		ON Contract.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
     		ON Reservation.Confirmation_Number = Contract.Confirmation_Number
WHERE 	
	(Business_Transaction.Transaction_Type = 'con') 
	AND 
    	(Business_Transaction.Transaction_Description = 'check out') 
    	AND 
	(NOT (Contract.Status = 'vd')) 
	AND 	
	(Reservation_Change_History.Changed_On =    	(SELECT MIN(rch.changed_on)
      							FROM reservation_change_History rch
      							WHERE rch.confirmation_Number = contract.confirmation_Number))
	AND 
	(Reservation.Source_Code = 'GIS')





















GO
