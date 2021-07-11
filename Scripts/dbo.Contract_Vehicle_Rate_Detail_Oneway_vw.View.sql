USE [GISData]
GO
/****** Object:  View [dbo].[Contract_Vehicle_Rate_Detail_Oneway_vw]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Rental Rates
create View [dbo].[Contract_Vehicle_Rate_Detail_Oneway_vw]

AS

     SELECT     * from Contract_Vehicle_GISRate_Oneway_vw

Union 
All

    Select * from Contract_Vehicle_QuotedRate_Oneway_vw
GO
