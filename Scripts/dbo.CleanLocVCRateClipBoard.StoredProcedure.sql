USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CleanLocVCRateClipBoard]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[CleanLocVCRateClipBoard]

as

DELETE FROM LocationVehicleRateLevel

GO
