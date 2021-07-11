USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Search]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[Contract_Search]
AS
SELECT     C.Contract_Number, C.Foreign_Contract_Number, C.Confirmation_Number, VOC.Checked_Out, VOC.Actual_Check_In, VOC.Expected_Check_In, 
                      VOC.Unit_Number, V.Foreign_Vehicle_Unit_Number, VLH.Licence_Plate_Number, V.Current_Licence_Plate, V.Owning_Company_ID, C.Last_Name, 
                      C.First_Name, C.Company_Name, C.Pick_Up_On, L.Location AS Pick_Up_Location, LT.[Value] AS Status, V.MVA_Number
FROM         dbo.Contract C INNER JOIN
                      dbo.Location L ON C.Pick_Up_Location_ID = L.Location_ID INNER JOIN
                      dbo.Lookup_Table LT ON C.Status = LT.Code AND LT.Category = 'Contract Status' LEFT OUTER JOIN
                      dbo.Vehicle_On_Contract VOC INNER JOIN
                      dbo.Vehicle V ON VOC.Unit_Number = V.Unit_Number LEFT OUTER JOIN
                      dbo.Vehicle_Licence_History VLH ON VOC.Unit_Number = VLH.Unit_Number AND VOC.Checked_Out BETWEEN VLH.Attached_On AND 
                      ISNULL(VLH.Removed_On, '2078-12-31 23:59') ON C.Contract_Number = VOC.Contract_Number


GO
