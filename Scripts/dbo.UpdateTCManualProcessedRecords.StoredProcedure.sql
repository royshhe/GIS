USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateTCManualProcessedRecords]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT TC.*
CREATE Procedure [dbo].[UpdateTCManualProcessedRecords]
As
Update	 Toll_Charge Set Processed=1
--select *   
FROM  dbo.Toll_Charge AS TC INNER JOIN
               dbo.TC_Processed AS TCP ON TC.Toll_Charge_Date = TCP.Toll_Charge_Date AND TC.Licence_Plate = TCP.Licence_Plate AND TC.Issuer = TCP.Issuer
Where TC.Processed=0
Delete TC_Processed               
GO
