USE [GISData]
GO
/****** Object:  Table [dbo].[TarpAudit]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TarpAudit](
	[Batch] [int] NULL,
	[DBR_CODE] [varchar](20) NULL,
	[MM] [char](10) NULL,
	[DD] [char](10) NULL,
	[YY] [char](10) NULL,
	[Contract_Number] [varchar](50) NULL,
	[Percentage] [decimal](18, 0) NULL,
	[TnM] [decimal](9, 2) NULL,
	[Comm_Amt] [decimal](9, 2) NULL,
	[IATA_number] [varchar](50) NULL,
	[Name] [varchar](50) NULL,
	[Res_number] [varchar](20) NULL,
	[GST_Tax] [decimal](9, 2) NULL
) ON [PRIMARY]
GO
