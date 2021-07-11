USE [GISData]
GO
/****** Object:  Table [dbo].[LocationInscrYield]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LocationInscrYield](
	[LocationYieldID] [int] IDENTITY(1,1) NOT NULL,
	[LocationID] [smallint] NOT NULL,
	[VehicleType] [varchar](10) NULL,
	[PayoutTierStart] [money] NULL,
	[PayoutTierEnd] [money] NULL,
	[Commission] [decimal](18, 0) NULL,
	[EffectiveDate] [datetime] NULL,
	[TerminateDate] [datetime] NULL,
 CONSTRAINT [PK_LocationInscrYield] PRIMARY KEY CLUSTERED 
(
	[LocationYieldID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
