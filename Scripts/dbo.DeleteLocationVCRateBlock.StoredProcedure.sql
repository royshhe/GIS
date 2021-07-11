USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteLocationVCRateBlock]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create Procedure [dbo].[DeleteLocationVCRateBlock]
as
declare @CompanyCode int        --remove hardcode code
select @CompanyCode=Code from Lookup_Table where Category = 'BudgetBC Company'
	
delete   dbo.Location_Vehicle_Rate_Level
FROM         dbo.Location_Vehicle_Rate_Level INNER JOIN
                      dbo.Location_Vehicle_Class ON 
                      dbo.Location_Vehicle_Rate_Level.Location_Vehicle_Class_ID = dbo.Location_Vehicle_Class.Location_Vehicle_Class_ID INNER JOIN
                      dbo.Vehicle_Class ON dbo.Location_Vehicle_Class.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN
                      dbo.Location ON dbo.Location_Vehicle_Class.Location_ID = dbo.Location.Location_ID INNER JOIN
                      dbo.Vehicle_Rate ON dbo.Location_Vehicle_Rate_Level.Rate_ID = dbo.Vehicle_Rate.Rate_ID
WHERE     (dbo.Location.Owning_Company_ID = @CompanyCode) AND (dbo.Location.Location IN ('B-01 YVR Airport', 'B-03 Downtown', 'B-04 Burrard')) AND 
                      (dbo.Location_Vehicle_Rate_Level.Valid_to >='2004-02-11 16:59:59.000') AND (dbo.Location_Vehicle_Rate_Level.Valid_from < '2004-04-01') AND 
                      (dbo.Vehicle_Rate.Termination_Date = 'Dec 31 2078 11:59PM')

--order by  dbo.Location.Location, dbo.Vehicle_Class.Vehicle_Class_Name,dbo.Location_Vehicle_Rate_Level.Location_Vehicle_Rate_Type,dbo.Location_Vehicle_Rate_Level.Valid_From


GO
