USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[OL_GetTimeBock]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[OL_GetTimeBock] -- 'DO', 20
@BlockType Varchar(10),
@LocationID	VarChar(10)
AS
-- Value, ID
SELECT  TBK.Block_Time,TBK.Block_Name 
FROM  dbo.Truck_Time_Block AS TBK INNER JOIN
               dbo.Location AS LOC ON TBK.Owning_Company_ID = LOC.Owning_Company_ID                
Where Location_ID = CONVERT(SmallInt, @LocationID) and  TBK.Block_Type=@BlockType
order by   TBK.Block_Time
GO
