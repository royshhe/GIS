USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[PM_GetVehSerDueListing]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[PM_GetVehSerDueListing]
	 
AS

Select * from PM_Service_Listing_vw PSL
where PSL.Status in ('Due', 'Over due')
--and PSL.Unit_number=convert(int,@UnitNumber)
GO
