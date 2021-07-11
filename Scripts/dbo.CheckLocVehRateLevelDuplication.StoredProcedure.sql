USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CheckLocVehRateLevelDuplication]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create Procedure [dbo].[CheckLocVehRateLevelDuplication]

as

select count(*)
from dbo.LocationVehicleRateLevel
group by  Location_ID,Vehicle_Class_Code,Location_Vehicle_Rate_Type,Valid_From,Valid_To,Rate_Selection_Type
having count(*)>1



GO
