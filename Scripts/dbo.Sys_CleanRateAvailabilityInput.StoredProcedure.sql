USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[Sys_CleanRateAvailabilityInput]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create Procedure [dbo].[Sys_CleanRateAvailabilityInput]

as

DELETE FROM Rate_Availability_Input



GO
