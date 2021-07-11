USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetTollChargeListing]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  Procedure [dbo].[GetTollChargeListing]
as

SELECT  RA.Contract_Number
FROM  (SELECT     VLH.Licence_Plate_Number,
				 CON.Contract_Number, 
				 VOC.Checked_Out, 
				 VOC.Actual_Check_In

FROM         dbo.Vehicle_On_Contract VOC INNER JOIN
                      dbo.Vehicle_Licence_History VLH ON VOC.Unit_Number = VLH.Unit_Number AND VOC.Checked_Out BETWEEN VLH.Attached_On AND 
                      ISNULL(VLH.Removed_On, CONVERT(Datetime, '31 Dec 2078 23:59')) INNER JOIN
                      dbo.Contract CON ON VOC.Contract_Number = CON.Contract_Number INNER JOIN
                      dbo.Location LOC ON CON.Pick_Up_Location_ID = LOC.Location_ID) AS RA INNER JOIN
               dbo.Toll_Charge AS TC ON -- TC.Toll_Charge_Date BETWEEN RA.Attached_On AND ISNULL(RA.Removed_On, '2012-12-31 23:59') AND 
               TC.Toll_Charge_Date BETWEEN RA.Checked_Out AND ISNULL(RA.Actual_Check_In, '2078-12-31 23:59') AND RA.Licence_Plate_Number = TC.Licence_Plate

order by  TC.Toll_Charge_Date

  
GO
