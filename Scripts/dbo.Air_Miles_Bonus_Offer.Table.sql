USE [GISData]
GO
/****** Object:  Table [dbo].[Air_Miles_Bonus_Offer]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Air_Miles_Bonus_Offer](
	[Bonus_Offer_Code] [varchar](4) NOT NULL,
	[Effecive_Date] [datetime] NOT NULL,
	[Terminate_Date] [datetime] NOT NULL,
	[Multiply_Factor] [int] NULL,
	[Mile_Points] [int] NULL
) ON [PRIMARY]
GO
