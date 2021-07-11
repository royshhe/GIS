USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateTCProcessStatus]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[UpdateTCProcessStatus]  --'1609151', 'T1'
	@ContractNumber Varchar(20),
	@Issuer Varchar(10),
	@BusTrxID Varchar(20)
As
Update Toll_Charge
Set Processed =1,
	Business_Transaction_ID= Convert(int, NULLIF(@BusTrxID, '')) 
--SELECT distinct TC.Toll_Charge_Date, TC.Charge_Amount, TC.Licence_Plate, RA.Contract_Number, RA.Checked_Out, RA.Actual_Check_In, RA.Attached_On, RA.Removed_On, 
 				   --RA.First_Name, RA.Last_Name,   RA.Location, TC.Issuer
FROM  (SELECT		VLH.Licence_Plate_Number,
					convert(varchar(30),CON.Contract_Number) as Contract_number,
					VOC.Checked_Out, 
					VOC.Actual_Check_In, 
					VLH.Attached_On, 
					VLH.Removed_On, 
					CON.First_Name, 
					CON.Last_Name, 
					LOC.Location
		FROM         dbo.Vehicle_On_Contract VOC INNER JOIN
					  dbo.Vehicle_Licence_History VLH ON VOC.Unit_Number = VLH.Unit_Number AND VOC.Checked_Out BETWEEN VLH.Attached_On AND 
					  ISNULL(VLH.Removed_On, CONVERT(Datetime, '31 Dec 2078 23:59')) INNER JOIN
					  dbo.Contract CON ON VOC.Contract_Number = CON.Contract_Number INNER JOIN
					  dbo.Location LOC ON CON.Pick_Up_Location_ID = LOC.Location_ID

		
		) AS RA INNER JOIN
			   dbo.Toll_Charge AS TC ON 
			   TC.Toll_Charge_Date BETWEEN RA.Checked_Out AND ISNULL(RA.Actual_Check_In, '2078-12-31 23:59')
			   AND RA.Licence_Plate_Number = TC.Licence_Plate
			Where TC.Processed=0	And RA.Contract_Number=Convert(int,@ContractNumber) and TC.Issuer=@Issuer
			
			
			--Update	 Toll_Charge set processed=0
GO
