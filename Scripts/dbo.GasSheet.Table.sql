USE [GISData]
GO
/****** Object:  Table [dbo].[GasSheet]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GasSheet](
	[Filled_Date] [smalldatetime] NULL,
	[Contract_Number] [int] NULL,
	[Unit_Price] [decimal](9, 2) NULL,
	[Liter_Filed] [decimal](9, 2) NULL
) ON [PRIMARY]
GO
