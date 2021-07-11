USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_27_Toll_Charge_Movement]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- Update Movement TC Process Status
CREATE Procedure [dbo].[RP_SP_Acc_27_Toll_Charge_Movement]-- '2012-10-01', '2013-01-24'
	@paramStartDate varchar(20) = '2008-01-01',
	@paramEndDate varchar(20) = '2008-01-10'
	
As
DECLARE
	@startDate datetime,
	@endDate datetime

SELECT	
	@startDate	= CONVERT(datetime, @paramStartDate),
	@endDate	= CONVERT(datetime, @paramEndDate)	

--select * from Vehicle_Movement
--Update Toll_Charge
--Set Processed =1 
SELECT distinct     
					
					TC.Toll_Charge_Date, 
					TCIssuer.Value as Issuer,
					TC.Charge_Amount, 
					TC.Licence_Plate,  					
					MV.Unit_Number,
					MV.Sending_Location, 
					MV.Receiving_Location, 
					MV.Movement_Out, 
					MV.Movement_IN, 
					MV.Driver_Name,
					MV.Remarks_Out,
					MV.Remarks_In,
					MV.Approver_Name
FROM  (SELECT		VLH.Licence_Plate_Number,
					MV.Unit_Number,
					LocOut.Location as Sending_Location,
					LocIn.Location as Receiving_Location, 
					MV.Movement_Out, 
					MV.Movement_IN, 
					MV.Driver_Name,
					MV.Remarks_Out,
					MV.Remarks_In,
					MV.Approver_Name,
					VLH.Attached_On, 
					VLH.Removed_On 
					 
		FROM  dbo.Vehicle_Movement MV 
		INNER JOIN dbo.Vehicle_Licence_History VLH 
			ON MV.Unit_Number = VLH.Unit_Number AND MV.Movement_Out BETWEEN VLH.Attached_On AND ISNULL(VLH.Removed_On, CONVERT(Datetime, '31 Dec 2078 23:59'))  
		INNER JOIN Location LocOut 
			ON MV.Sending_Location_ID= LocOut.Location_ID
		INNER JOIN Location LocIn
		    On MV.Receiving_Location_ID = LocIn.Location_ID			
		
		) AS MV INNER JOIN
			   dbo.Toll_Charge AS TC ON 
			   TC.Toll_Charge_Date BETWEEN MV.Movement_Out AND ISNULL(MV.Movement_IN, '2078-12-31 23:59')
			   AND MV.Licence_Plate_Number = TC.Licence_Plate
		Inner Join (Select Category, Code, Value from Lookup_table where Category='Toll Charge Issuer') TCIssuer
					On TC.Issuer=  TCIssuer.Code
		Where TC.Toll_Charge_Date between @startDate and @endDate	
			
		 
GO
