USE [GISData]
GO
/****** Object:  View [dbo].[RP_Flt_8_Vehicle_Control_L1_Base_VM]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO






/*
VIEW NAME: RP_Flt_8_Vehicle_Control_L1_Base_VM
PURPOSE: Get the information about the last vehicle movement.

AUTHOR:	Joseph Tseung
DATE CREATED: 2000/03/08
USED BY: RP_Flt_8_Vehicle_Control_L2_Main
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung   2000/03/29	add the Movement Out field
*/
CREATE VIEW [dbo].[RP_Flt_8_Vehicle_Control_L1_Base_VM]
AS
SELECT 	Unit_Number, 
	Movement_Out,
	Location_ID = CASE WHEN Movement_IN IS NULL
			THEN Sending_Location_ID
			ELSE Receiving_Location_ID
		      END,
	Km = CASE WHEN Km_In >= Km_Out
		THEN Km_In
		ELSE Km_Out
	     END
FROM 	Vehicle_Movement WITH(NOLOCK)
WHERE 	Movement_Out =  (SELECT MAX(vm.Movement_Out)
      			  FROM Vehicle_Movement vm
      			  WHERE vm.unit_Number = Vehicle_Movement.Unit_Number)















GO
