USE [GISData]
GO
/****** Object:  Table [dbo].[VehicleDep]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VehicleDep](
	[Unit_Number] [int] NULL,
	[Depreciation_Start_Date] [datetime] NULL,
	[Depreciation_Rate_Percentage] [float] NULL
) ON [PRIMARY]
GO
