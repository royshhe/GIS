USE [GISData]
GO
/****** Object:  View [dbo].[RP_Flt_6_Units_Available_For_Rent_L1_Base_2]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO









/*
VIEW NAME: RP_Flt_6_Units_Available_For_Rent_L1_Base_2
PURPOSE: Get the information about the last vehicle on contract

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Stored Procedure RP_SP_Flt_6_Units_Available_For_Rent
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Flt_6_Units_Available_For_Rent_L1_Base_2]
AS
SELECT 	Unit_Number, 
	Km_In,
	Contract_Number,
	Actual_Check_In
FROM 	Vehicle_On_Contract WITH(NOLOCK)
WHERE 	Actual_Check_In =  (SELECT MAX(voc.Actual_Check_In)
      			  FROM vehicle_On_Contract voc
      			  WHERE voc.unit_Number = Vehicle_On_Contract.Unit_Number
      			  
      			  )
      			  --Add By Roy
      			  And Checked_out<Actual_Check_in
      			  
      			  
      			  --select * from	 vehicle_On_Contract  where
      			  ---- unit_number=      180337
      			  ----and 
      			  --contract_number in (1703002,1707359)




















GO
