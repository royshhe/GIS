USE [GISData]
GO
/****** Object:  Table [dbo].[LocationVehicleClassBaseRate]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LocationVehicleClassBaseRate](
	[LocationVCBaseRateID] [int] IDENTITY(1,1) NOT NULL,
	[LocationID] [int] NULL,
	[VehicleClassID] [char](1) NULL,
	[WeekDayBaseRateAmount] [smallmoney] NULL,
	[WeekendBaseRateAmount] [money] NULL,
	[WeeklyBaseRateAmount] [smallmoney] NULL,
	[EffectiveDate] [datetime] NULL,
	[TerminateDate] [datetime] NULL,
 CONSTRAINT [PK_LocationVehicleClassBaseRate] PRIMARY KEY CLUSTERED 
(
	[LocationVCBaseRateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
