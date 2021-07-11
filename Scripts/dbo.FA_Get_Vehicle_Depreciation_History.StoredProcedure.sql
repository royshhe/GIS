USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_Get_Vehicle_Depreciation_History]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[FA_Get_Vehicle_Depreciation_History]
@UnitNumber int
as
SELECT     
CONVERT(VarChar, Depreciation_Start_Date, 111) Depreciation_Start_Date,
CONVERT(VarChar, Depreciation_End_Date, 111) Depreciation_End_Date,
Depreciation_Rate_Amount, 
Depreciation_Rate_Percentage, 
Last_Update_On
FROM         dbo.FA_Vehicle_Depreciation_History
where Unit_number=@UnitNumber
GO
