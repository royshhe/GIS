USE [GISData]
GO
/****** Object:  View [dbo].[Vehicle_Class_Optional_Extra_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

create View [dbo].[Vehicle_Class_Optional_Extra_vw] as



Select  Vehicle_Class_Name,  dbo.Optional_Extra.Optional_Extra from  dbo.Vehicle_Class Cross Join  dbo.Optional_Extra
where Convert(Varchar(1), dbo.Vehicle_Class.Vehicle_Class_Code) + Convert(Varchar(3),dbo.Optional_Extra.Optional_Extra_ID)

 Not in 
(SELECT   Convert(Varchar(1), dbo.Vehicle_Class.Vehicle_Class_Code) + Convert(Varchar(3),dbo.Optional_Extra.Optional_Extra_ID)
FROM         dbo.Vehicle_Class INNER JOIN
                      dbo.Optional_Extra_Restriction ON dbo.Vehicle_Class.Vehicle_Class_Code = dbo.Optional_Extra_Restriction.Vehicle_Class_Code INNER JOIN
                      dbo.Optional_Extra ON dbo.Optional_Extra_Restriction.Optional_Extra_ID = dbo.Optional_Extra.Optional_Extra_ID
)
GO
