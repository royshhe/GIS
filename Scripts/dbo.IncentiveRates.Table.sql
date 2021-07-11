USE [GISData]
GO
/****** Object:  Table [dbo].[IncentiveRates]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IncentiveRates](
	[IncentiveRateID] [int] IDENTITY(1,1) NOT NULL,
	[LocationID] [int] NOT NULL,
	[FPORate] [smallmoney] NULL,
	[WalkUPRate] [smallmoney] NULL,
	[AdditionalDriverRate] [decimal](18, 2) NULL,
	[ChildSeatRate] [decimal](18, 2) NULL,
	[UnderAgeRate] [decimal](18, 2) NULL,
	[UpSellRate] [decimal](18, 2) NULL,
	[LDWRate] [decimal](18, 2) NULL,
	[PAIRate] [decimal](18, 2) NULL,
	[PECRate] [decimal](18, 2) NULL,
	[DolliesRate] [decimal](18, 2) NULL,
	[GateRate] [decimal](18, 2) NULL,
	[BlanketRate] [decimal](18, 2) NULL,
	[SkiRackRate] [decimal](18, 2) NULL,
	[EffectiveDate] [datetime] NULL,
	[TerminateDate] [datetime] NULL,
 CONSTRAINT [PK_IncentiveRates] PRIMARY KEY CLUSTERED 
(
	[IncentiveRateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
