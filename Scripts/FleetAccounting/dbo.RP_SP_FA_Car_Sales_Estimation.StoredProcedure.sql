USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_FA_Car_Sales_Estimation]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[RP_SP_FA_Car_Sales_Estimation] --  '*', '*', '16,20'
 @paramVehicleTypeID varchar(18) = 'car',
 @paramVehicleClassID char(1) = '*',
 @LocationList as Varchar(100)
As

DECLARE @SQLString nvarchar(500)

Select @SQLString=

'Select VE.*,V.FA_Remarks from 
RP_FA_Vehicle_Sales_Estimation VE inner join Vehicle V on V.unit_number=VE.unit_number
Where VE.Vehicle_Location_ID in ('+  @LocationList+')'
+'  AND  ( ''' +@paramVehicleTypeID +''' =''*'' OR VE.FA_Vehicle_Type_ID = ''' + @paramVehicleTypeID+''')' 
+'  AND  ( '''+@paramVehicleClassID +'''= ''*'' OR  VE.Vehicle_Class_Code ='''+ @paramVehicleClassID+''')'

--print @SQLString
exec (@SQLString)

GO
