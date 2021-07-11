USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehicleClassModelOptions]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[GetVehicleClassModelOptions]

	@VehicleClassCode char(1)
 AS

SELECT     dbo.Lookup_Table.[Value] AS ModelOption
FROM         dbo.Vehicle_Class_Model_Option INNER JOIN
                      dbo.Lookup_Table ON dbo.Vehicle_Class_Model_Option.Model_Option = dbo.Lookup_Table.Code
WHERE     (dbo.Lookup_Table.Category = 'Vehicle Option') AND (dbo.Vehicle_Class_Model_Option.Vehicle_Class_Code = @VehicleClassCode)

return 1
GO
