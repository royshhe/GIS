USE [GISData]
GO
/****** Object:  Table [dbo].[UpdateCCTransactionLog]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UpdateCCTransactionLog](
	[AuthNum] [varchar](20) NULL,
	[CCNum] [varchar](20) NULL,
	[Amount] [varchar](20) NULL,
	[RBRDate] [varchar](24) NULL,
	[TerminalId] [varchar](20) NULL,
	[AddedToGIS] [varchar](5) NULL,
	[CtrctNum] [varchar](20) NULL,
	[ConfirmNum] [varchar](20) NULL,
	[SalesCtrctNum] [varchar](20) NULL
) ON [PRIMARY]
GO
