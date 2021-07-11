USE [GISData]
GO
/****** Object:  Table [dbo].[GLChartMapping]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GLChartMapping](
	[Account_Code_Old] [varchar](32) NULL,
	[Account_description_Old] [varchar](40) NULL,
	[Account_type] [smallint] NULL,
	[inactive_flag] [bit] NULL,
	[Account_Code_New] [varchar](32) NULL,
	[Account_description_New] [varchar](40) NULL
) ON [PRIMARY]
GO
