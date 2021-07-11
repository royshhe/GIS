USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[PM_GetServHist]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 


CREATE PROCEDURE [dbo].[PM_GetServHist]-- 130135
	@UnitNumber varchar(10) 
AS


SELECT-- PSH.Unit_Number, 
	   SCat.Value AS Service, 
	   PSH.KM_Reading AS  KMReading, 
	   PSH.Service_Date,
	   PSH.Service_Performed_By, 
       PSH.Document_Number,
       PSH.Remarks 
FROM  dbo.PM_Service_History AS PSH 
INNER JOIN (Select * from dbo.Lookup_Table where category='PM Service')  AS SCat 
	ON PSH.Service_Code = SCat.Code 
 
 Where  PSH.Unit_number=convert(int,@UnitNumber)
 Order by  PSH.Service_Date desc
 
 
 
GO
