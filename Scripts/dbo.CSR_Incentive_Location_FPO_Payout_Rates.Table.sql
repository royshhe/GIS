USE [GISData]
GO
/****** Object:  Table [dbo].[CSR_Incentive_Location_FPO_Payout_Rates]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CSR_Incentive_Location_FPO_Payout_Rates](
	[Location_FPO_Payout_Rate_ID] [int] IDENTITY(1,1) NOT NULL,
	[Location_ID] [smallint] NOT NULL,
	[Vehicle_Type] [varchar](10) NULL,
	[Market_Saturation_Start] [decimal](9, 2) NULL,
	[Market_Saturation_End] [decimal](9, 2) NULL,
	[Payout_Rate] [money] NULL,
	[Effective_Date] [datetime] NULL,
	[Terminate_Date] [datetime] NULL,
 CONSTRAINT [PK_CSR_Incentive_Location_FPO_Payout_Rates] PRIMARY KEY CLUSTERED 
(
	[Location_FPO_Payout_Rate_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
