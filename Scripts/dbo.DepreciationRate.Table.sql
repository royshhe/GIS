USE [GISData]
GO
/****** Object:  Table [dbo].[DepreciationRate]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DepreciationRate](
	[DepreciationRateID] [int] NOT NULL,
	[VehicleModelYear] [smallint] NULL,
	[DepreciationRate] [decimal](18, 0) NULL,
	[DepreciationType] [varchar](50) NULL,
	[EffectiveDate] [datetime] NULL,
	[TerminateDate] [datetime] NULL
) ON [PRIMARY]
GO
