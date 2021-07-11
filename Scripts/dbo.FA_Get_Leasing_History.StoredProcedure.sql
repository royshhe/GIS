USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_Get_Leasing_History]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[FA_Get_Leasing_History]
@UnitNumber int
as

SELECT     Lessee_id,Initial_Cost,Interest_Rate, Principle_Rate,


CONVERT(VarChar, Lease_Start_Date, 111) Lease_Start_Date,
CONVERT(VarChar, Lease_End_Date, 111) Lease_End_Date,
Private_Lease
FROM         dbo.FA_Vehicle_Lease_History
where Unit_number=@UnitNumber
GO
