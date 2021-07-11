USE [GISData]
GO
/****** Object:  View [dbo].[RP_Flt_6_Units_Available_For_Rent_L1_Base_3]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



/*
VIEW NAME: RP_Flt_6_Units_Available_For_Rent_L1_Base_3
PURPOSE: Get the information about the last movement of the vehicle

AUTHOR:	Joseph Tseung	
DATE CREATED: 2000/02/02
USED BY: Stored Procedure RP_SP_Flt_6_Units_Available_For_Rent
MOD HISTORY:
Name 		Date		Comments
*/
CREATE VIEW [dbo].[RP_Flt_6_Units_Available_For_Rent_L1_Base_3]
AS
SELECT 	Unit_Number, 
	Km_In,
	Movement_In
FROM 	Vehicle_Movement WITH(NOLOCK)
WHERE 	Movement_In =  (SELECT MAX(vm.Movement_In)
      			  FROM Vehicle_Movement vm
      			  WHERE vm.unit_Number = Vehicle_Movement.Unit_Number)










GO
