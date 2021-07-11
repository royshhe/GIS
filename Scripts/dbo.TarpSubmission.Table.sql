USE [GISData]
GO
/****** Object:  Table [dbo].[TarpSubmission]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TarpSubmission](
	[Batch] [varchar](10) NULL,
	[DBR_CODE] [varchar](20) NULL,
	[MM] [char](10) NULL,
	[DD] [char](10) NULL,
	[YY] [char](10) NULL,
	[Contract_Number] [varchar](50) NULL,
	[Percentage] [decimal](18, 0) NULL,
	[BCD_Number] [char](10) NULL,
	[TnM] [decimal](9, 2) NULL,
	[Comm_Amt] [decimal](9, 2) NULL,
	[IATA_number] [varchar](50) NULL,
	[Name] [varchar](50) NULL,
	[Res_number] [varchar](20) NULL,
	[Rate_code] [varchar](20) NULL
) ON [PRIMARY]
GO
