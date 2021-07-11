USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehClassInfoByCode]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetVehClassInfoByCode]-- 'B',0
	@VehClassCode char(1),
    @CSAOnly  bit=0
AS

 

SELECT DISTINCT Vehicle_Class_Code,Maestro_Code, (Case When @CSAOnly =1 Then  Alias Else  Vehicle_Class_Name End)  Vehicle_Class_Name, Description, ImageName,VCPhoto, VCNameImage,VCCapImage, Number_Passengers, Large_bags, Small_bags, passenger_Vehicle,DisplayOrder
FROM         dbo.Vehicle_Class
Where	Vehicle_Class_Code = @VehClassCode   And ( CSA=@CSAOnly or @CSAOnly=0)
Order By
	Vehicle_Class_Name
Return 1


--Select * from Vehicle_Classs
GO
