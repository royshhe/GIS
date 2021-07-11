USE [GISData]
GO
/****** Object:  Table [dbo].[Air_Miles_Rewards]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Air_Miles_Rewards](
	[Reward_ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) NULL,
	[Offer_Code] [varchar](4) NULL,
	[Offer_Type] [varchar](5) NULL,
	[Valid_From] [datetime] NULL,
	[Valid_To] [datetime] NULL
) ON [PRIMARY]
GO
