USE [GISData]
GO
/****** Object:  View [dbo].[RP_Acc_5_CSR_Summary_Contract_Check_In_ALL_L1_SB_Base_1]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





-------------------------------------------------------------------------------------------------------------------------
--  Programmer:  Jack Jian
--  Date:	            Jun 22, 2001
--  Description:   collect all contract info for report CSR_SUMM, this will create a new sub-report
-------------------------------------------------------------------------------------------------------------------------


CREATE VIEW [dbo].[RP_Acc_5_CSR_Summary_Contract_Check_In_ALL_L1_SB_Base_1]
AS
	SELECT    Business_Transaction.RBR_Date, 
--		    Contract.Pick_Up_Location_ID, 
		    RP__CSR_Who_Opened_The_Contract.location_id as Pick_Up_Location_ID,   
		    RP__CSR_Who_Opened_The_Contract.User_ID AS CSR_Name, 
		    Vehicle_Class.Vehicle_Type_ID, 
		    Business_Transaction.Contract_Number, 
		    Contract.Confirmation_Number, 
		    Contract.Reservation_Revenue, 
		    ROUND(DATEDIFF(mi, Contract.Pick_Up_On,  RP__Last_Vehicle_On_Contract.Actual_Check_In) / 1440.0, 1)    AS Contract_Rental_Days, 

		    SUM( 
			CASE WHEN Contract_Charge_Item.Charge_Type IN (10,  11, 20, 50, 51, 52) 
				    THEN Contract_Charge_Item.Amount - Contract_Charge_Item.GST_Amount_Included
								           - Contract_Charge_Item.PST_Amount_Included 
								           - Contract_Charge_Item.PVRT_Amount_Included
		                        ELSE 0 
 			END
		         ) AS Contract_Revenue

	FROM Contract WITH(NOLOCK)
	INNER JOIN
	    Business_Transaction 
		ON  Contract.Contract_Number = Business_Transaction.Contract_Number
	INNER JOIN
	    RP__CSR_Who_Opened_The_Contract 
		ON  Contract.Contract_Number = RP__CSR_Who_Opened_The_Contract.Contract_Number
	INNER JOIN
	    Vehicle_Class 
		ON  Contract.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code
	INNER JOIN
	    Contract_Charge_Item 
		ON Contract.Contract_Number = Contract_Charge_Item.Contract_Number
	INNER JOIN
	    RP__Last_Vehicle_On_Contract 
		ON  Contract.Contract_Number = RP__Last_Vehicle_On_Contract.Contract_Number

	WHERE (NOT (Contract.Status = 'vd')) AND 
		    (Business_Transaction.Transaction_Type = 'con') AND 
		    (Business_Transaction.Transaction_Description = 'Check In') 

	GROUP BY Business_Transaction.RBR_Date, 
--		    Contract.Pick_Up_Location_ID, 
		    RP__CSR_Who_Opened_The_Contract.location_id ,
		    RP__CSR_Who_Opened_The_Contract.User_ID, 
		    Vehicle_Class.Vehicle_Type_ID, 
		    Business_Transaction.Contract_Number, 
		    Contract.Confirmation_Number, 
		    Contract.Reservation_Revenue, 
		    RP__Last_Vehicle_On_Contract.Actual_Check_In, 
		    Contract.Pick_Up_On







GO
