USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[Sys_CleanOrganizationRateInput]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create Procedure [dbo].[Sys_CleanOrganizationRateInput]

as

DELETE FROM Organization_Rate_Input



GO
