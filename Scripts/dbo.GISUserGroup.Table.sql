USE [GISData]
GO
/****** Object:  Table [dbo].[GISUserGroup]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GISUserGroup](
	[user_id] [char](20) NOT NULL,
	[group_name] [char](50) NOT NULL,
	[last_updated_by] [char](50) NOT NULL,
	[last_updated_on] [datetime] NOT NULL,
	[timestamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_GISUserGroup] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC,
	[group_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GISUserGroup]  WITH NOCHECK ADD  CONSTRAINT [FK_GISUserGroup_GISUserGroups] FOREIGN KEY([group_name])
REFERENCES [dbo].[GISUserGroups] ([group_name])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[GISUserGroup] NOCHECK CONSTRAINT [FK_GISUserGroup_GISUserGroups]
GO
ALTER TABLE [dbo].[GISUserGroup]  WITH NOCHECK ADD  CONSTRAINT [FK_GISUserGroup_GISUsers] FOREIGN KEY([user_id])
REFERENCES [dbo].[GISUsers] ([user_id])
GO
ALTER TABLE [dbo].[GISUserGroup] NOCHECK CONSTRAINT [FK_GISUserGroup_GISUsers]
GO
