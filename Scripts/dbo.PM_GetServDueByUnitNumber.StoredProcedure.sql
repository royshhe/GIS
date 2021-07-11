USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[PM_GetServDueByUnitNumber]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PM_GetServDueByUnitNumber] --130135
	@UnitNumber varchar(10)
AS

Select   Service, ServiceType, Last_Service_Date, LastKMReading, Current_Km, Tracking_Type, NextServiceDate, NextServiceKM, Status from PM_Service_Listing_vw PSL
where PSL.Status in ('Due', 'Over due')
and PSL.Unit_number=convert(int,@UnitNumber)
GO
