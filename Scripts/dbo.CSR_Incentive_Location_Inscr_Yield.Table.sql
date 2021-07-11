USE [GISData]
GO
/****** Object:  Table [dbo].[CSR_Incentive_Location_Inscr_Yield]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CSR_Incentive_Location_Inscr_Yield](
	[Location_Yield_ID] [int] IDENTITY(1,1) NOT NULL,
	[Yield_Type] [varchar](10) NULL,
	[Location_ID] [smallint] NOT NULL,
	[Vehicle_Type] [varchar](10) NULL,
	[Payout_Tier_Start] [money] NULL,
	[Payout_Tier_End] [money] NULL,
	[Commission] [decimal](5, 2) NULL,
	[Effective_Date] [datetime] NULL,
	[Terminate_Date] [datetime] NULL,
 CONSTRAINT [PK_CSR_Incentive_Location_Inscr_Yield] PRIMARY KEY CLUSTERED 
(
	[Location_Yield_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
