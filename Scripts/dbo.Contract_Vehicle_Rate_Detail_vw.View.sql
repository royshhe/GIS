USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Vehicle_Rate_Detail_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Rental Rates
create View [dbo].[Contract_Vehicle_Rate_Detail_vw]

AS

     SELECT     * from Contract_Vehicle_GIS_Rate_Detail_vw

Union 
All

    Select * from Contract_Vehicle_Quoted_Rate_Detail_vw
GO
