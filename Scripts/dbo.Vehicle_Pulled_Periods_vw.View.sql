USE [GISData]
GO
/****** Object:  View [dbo].[Vehicle_Pulled_Periods_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[Vehicle_Pulled_Periods_vw]
AS

SELECT     VH.Unit_Number, VH.Effective_On AS PFDFrom,
                          (SELECT     TOP 1 Effective_On
                            FROM          (SELECT     Unit_Number, Vehicle_Status, Effective_On
                                                    FROM          dbo.Vehicle_History
                                                    WHERE      (Unit_Number = VH.Unit_Number) AND (Effective_On >VH.Effective_On) ) AS VehicleNextStatus
                            ORDER BY Effective_On) AS PFDTo,
                            
                            (SELECT     TOP 1 Vehicle_Status
                            FROM          (SELECT     Unit_Number, Vehicle_Status, Effective_On
                                                    FROM          dbo.Vehicle_History
                                                    WHERE      (Unit_Number = VH.Unit_Number) AND (Effective_On >VH.Effective_On) ) AS VehicleNextStatus
                            ORDER BY Effective_On) AS StatusAfterPFD
                            
FROM         dbo.Vehicle_History AS VH INNER JOIN
                          (SELECT     Code, Value
                            FROM          dbo.Lookup_Table
                            WHERE      (Category = 'Vehicle Status')) AS CatVehicleStatus ON VH.Vehicle_Status = CatVehicleStatus.Code
					Inner Join Vehicle V on VH.Unit_number=V.Unit_Number
					INNER JOIN
                          (SELECT     Code, Value
                            FROM          dbo.Lookup_Table
                            WHERE      (Category = 'BudgetBC Company')) AS CatOwningCompany
					ON V.Owning_Company_ID = CatOwningCompany.Code
WHERE     (CatVehicleStatus.Value in  ('Pulled For Disposal', 'Damaged: Not Repairable','Written Off' ))
--or VH.Vehicle_Status>='f'



GO
