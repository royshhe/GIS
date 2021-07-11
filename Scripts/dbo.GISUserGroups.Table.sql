USE [GISData]
GO
/****** Object:  Table [dbo].[GISUserGroups]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GISUserGroups](
	[group_name] [char](50) NOT NULL,
	[last_updated_by] [char](255) NULL,
	[last_updated_on] [datetime] NULL,
	[time_stamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_GISUserGroups] PRIMARY KEY NONCLUSTERED 
(
	[group_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
