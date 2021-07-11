USE [GISData]
GO
/****** Object:  Table [dbo].[FleetBook]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FleetBook](
	[Unit_Number] [int] NOT NULL,
	[FinacedBy] [int] NULL,
	[InServiceDate] [datetime] NULL,
	[SoldDate] [datetime] NULL,
	[PulledForDesposalDate] [datetime] NULL,
	[DaysInService] [int] NULL,
	[PDIDate] [char](10) NULL,
	[PDIAmount] [money] NULL,
	[Chattel] [money] NULL,
	[VehicleCost] [money] NULL,
	[MonthlyDep] [money] NULL,
	[BookValue] [money] NULL,
	[AccumulatedDep] [money] NULL,
	[SellingPrice] [money] NULL,
	[Last_Update_By] [datetime] NULL,
	[Last_Update_On] [char](10) NULL
) ON [PRIMARY]
GO
