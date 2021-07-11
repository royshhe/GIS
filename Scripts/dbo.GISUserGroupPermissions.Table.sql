USE [GISData]
GO
/****** Object:  Table [dbo].[GISUserGroupPermissions]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GISUserGroupPermissions](
	[group_name] [char](50) NOT NULL,
	[screen_number] [int] NOT NULL,
	[permission_id] [int] NOT NULL,
	[last_updated_by] [char](20) NOT NULL,
	[last_updated_on] [datetime] NOT NULL,
	[timestamp] [timestamp] NULL,
 CONSTRAINT [PK_GISUserGroupPermissions] PRIMARY KEY CLUSTERED 
(
	[group_name] ASC,
	[screen_number] ASC,
	[permission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GISUserGroupPermissions]  WITH CHECK ADD  CONSTRAINT [FK_GISUserGroupPermissions_GISUserGroups] FOREIGN KEY([group_name])
REFERENCES [dbo].[GISUserGroups] ([group_name])
GO
ALTER TABLE [dbo].[GISUserGroupPermissions] CHECK CONSTRAINT [FK_GISUserGroupPermissions_GISUserGroups]
GO
