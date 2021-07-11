USE [GISData]
GO
/****** Object:  Table [dbo].[Toll_Charge_Refund]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Toll_Charge_Refund](
	[Toll_Charge_Date] [datetime] NOT NULL,
	[Charge_Amount] [decimal](9, 2) NOT NULL,
	[Licence_Plate] [varchar](10) NOT NULL,
	[Direction] [varchar](50) NULL,
	[Toll_Type] [varchar](50) NULL,
	[Issuer] [varchar](10) NOT NULL,
	[Processed] [bit] NOT NULL,
	[Email_Sent] [bit] NOT NULL,
	[Business_Transaction_ID] [int] NULL
) ON [PRIMARY]
GO
