USE [GISData]
GO
/****** Object:  Table [dbo].[CSR_Incentive_VC_RentalDay_Rates]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CSR_Incentive_VC_RentalDay_Rates](
	[VC_RentalDay_Rate_ID] [int] IDENTITY(1,1) NOT NULL,
	[Location_ID] [smallint] NOT NULL,
	[Vehicle_Type] [varchar](10) NULL,
	[RentalDay_Start] [decimal](9, 2) NULL,
	[RentalDay_End] [decimal](9, 2) NULL,
	[Payout_Rate] [money] NULL,
	[Effective_Date] [datetime] NULL,
	[Terminate_Date] [datetime] NULL
) ON [PRIMARY]
GO
