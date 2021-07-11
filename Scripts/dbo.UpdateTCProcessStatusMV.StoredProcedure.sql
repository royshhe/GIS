USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateTCProcessStatusMV]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Update Movement TC Process Status
CREATE Procedure [dbo].[UpdateTCProcessStatusMV]  --'1609151', 'T1'
	
As

--select * from Vehicle_Movement
Update Toll_Charge
Set Processed =1 
--SELECT distinct TC.Toll_Charge_Date, TC.Charge_Amount, TC.Licence_Plate 
FROM  (SELECT		VLH.Licence_Plate_Number,
					 
					MV.Movement_Out, 
					MV.Movement_IN, 
					VLH.Attached_On, 
					VLH.Removed_On 
					 
		FROM  dbo.Vehicle_Movement MV 
		INNER JOIN dbo.Vehicle_Licence_History VLH ON MV.Unit_Number = VLH.Unit_Number 
			AND MV.Movement_Out BETWEEN VLH.Attached_On AND ISNULL(VLH.Removed_On, CONVERT(Datetime, '31 Dec 2078 23:59'))  
		
		) AS MV INNER JOIN
			   dbo.Toll_Charge AS TC ON 
			   TC.Toll_Charge_Date BETWEEN MV.Movement_Out AND ISNULL(MV.Movement_IN, '2078-12-31 23:59')
			   AND MV.Licence_Plate_Number = TC.Licence_Plate
			Where TC.Processed=0	
			
 
GO
