USE [GISData]
GO
/****** Object:  View [dbo].[Vehicle_First_Held_vw]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create VIEW [dbo].[Vehicle_First_Held_vw]
AS
SELECT     VH.Unit_Number, MIN(VH.Effective_On) AS HeldDate                          
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

WHERE     (CatVehicleStatus.Value = 'Held') --and v.unit_number=151947
Group By  VH.Unit_Number
GO
