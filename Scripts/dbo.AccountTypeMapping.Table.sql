USE [GISData]
GO
/****** Object:  Table [dbo].[AccountTypeMapping]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccountTypeMapping](
	[MappingID] [int] NOT NULL,
	[AccountType] [smallint] NULL,
	[ACCTGRPID] [smallint] NULL,
	[ACCTBAL] [char](1) NULL,
	[ACCTTYPE] [char](1) NULL
) ON [PRIMARY]
GO
