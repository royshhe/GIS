USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehClassListing]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[GetVehClassListing]
as

SELECT DISTINCT Vehicle_Class_Code, Maestro_code, Vehicle_Class_Name, Description, ImageName,VCPhoto, VCNameImage,VCCapImage, Number_Passengers, Large_bags, Small_bags,DisplayOrder
FROM         dbo.Vehicle_Class
WHERE     (SellOnline = 1)
ORDER BY DisplayOrder


Return 1
GO
