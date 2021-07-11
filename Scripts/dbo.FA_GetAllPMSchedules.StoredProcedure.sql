USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_GetAllPMSchedules]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FA_GetAllPMSchedules]

AS

SELECT    Schedule_Name, Schedule_ID , Tracked_By_Date,Tracked_By_meter,Meter_Type
--select *
FROM         dbo.PM_Schedule
Order By Schedule_Name
Return 1
GO
