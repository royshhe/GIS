USE [GISData]
GO
/****** Object:  Table [dbo].[FA_Switchboard_Items]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_Switchboard_Items](
	[SwitchboardID] [int] NOT NULL,
	[ItemNumber] [smallint] NOT NULL,
	[ItemText] [nvarchar](255) NULL,
	[Command] [smallint] NULL,
	[Argument] [nvarchar](255) NULL,
 CONSTRAINT [PK_FA_Switchboard_Items] PRIMARY KEY CLUSTERED 
(
	[SwitchboardID] ASC,
	[ItemNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
