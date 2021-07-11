USE [GISData]
GO
/****** Object:  Table [dbo].[EP_Switchboard_ Items]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EP_Switchboard_ Items](
	[SwitchboardID] [int] NOT NULL,
	[ItemNumber] [smallint] NOT NULL,
	[ItemText] [nvarchar](255) NULL,
	[Command] [smallint] NULL,
	[Argument] [nvarchar](255) NULL
) ON [PRIMARY]
GO
