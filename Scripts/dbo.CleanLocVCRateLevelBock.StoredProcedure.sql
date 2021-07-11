USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CleanLocVCRateLevelBock]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[CleanLocVCRateLevelBock]

as

DELETE FROM Location_Vehicle_Rate_Block


GO
