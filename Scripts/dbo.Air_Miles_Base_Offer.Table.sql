USE [GISData]
GO
/****** Object:  Table [dbo].[Air_Miles_Base_Offer]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Air_Miles_Base_Offer](
	[Base_Offer_Code] [varchar](2) NOT NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Terminate_Date] [datetime] NOT NULL,
	[Off_Name] [varchar](20) NULL,
	[Unit_Quantity] [int] NULL,
	[Unit_Type] [varchar](20) NULL
) ON [PRIMARY]
GO
