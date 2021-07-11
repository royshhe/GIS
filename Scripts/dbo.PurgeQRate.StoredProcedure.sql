USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[PurgeQRate]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create Procedure [dbo].[PurgeQRate]
As

select * Into #QRate_Archive from Quoted_Vehicle_Rate where Quoted_Rate_ID not in (select Quoted_Rate_ID from reservation where Quoted_Rate_ID is not null)
and Quoted_Rate_ID not in (select Quoted_Rate_ID from contract where Quoted_Rate_ID is not null) and Quoted_Rate_ID not in (select Quoted_Rate_ID from Quoted_Organization_Rate where Quoted_Rate_ID is not null)

                      
delete Quoted_Rate_Category  
--Select QRC.*
FROM  dbo.Quoted_Rate_Category AS QRC INNER JOIN
              #QRate_Archive AS QRate ON QRC.Quoted_Rate_ID = QRate.Quoted_Rate_ID

Delete Quoted_Rate_Restriction                      
--SELECT QRR.*
FROM  #QRate_Archive AS QRate INNER JOIN
              Quoted_Rate_Restriction AS QRR ON QRate.Quoted_Rate_ID = QRR.Quoted_Rate_ID
               
Delete     Quoted_Time_Period_Rate               
--SELECT QTP.*
FROM  #QRate_Archive AS QRate INNER JOIN
               dbo.Quoted_Time_Period_Rate AS QTP ON QRate.Quoted_Rate_ID = QTP.Quoted_Rate_ID
               
Delete Quoted_Included_Optional_Extra
--SELECT QIOE.*
FROM  #QRate_Archive AS QRate INNER JOIN
               dbo.Quoted_Included_Optional_Extra AS QIOE ON QRate.Quoted_Rate_ID = QIOE.Quoted_Rate_ID
                         

Delete dbo.Quoted_Vehicle_Rate
--SELECT     dbo.Quoted_Vehicle_Rate.*
FROM         #QRate_Archive INNER JOIN
                      dbo.Quoted_Vehicle_Rate ON #QRate_Archive.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID 
 
Drop table #QRate_Archive
GO
