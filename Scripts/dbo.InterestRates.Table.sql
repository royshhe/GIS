USE [GISData]
GO
/****** Object:  Table [dbo].[InterestRates]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InterestRates](
	[InterestRateID] [int] IDENTITY(1,1) NOT NULL,
	[InterestRatePurpose] [varchar](50) NULL,
	[FinanceCompanyID] [int] NULL,
	[VehicleModelYearID] [smallint] NULL,
	[UsedCar] [bit] NOT NULL,
	[InterestRate] [decimal](18, 0) NULL,
	[EffectiveDate] [datetime] NULL,
	[TerminateDate] [datetime] NULL
) ON [PRIMARY]
GO
