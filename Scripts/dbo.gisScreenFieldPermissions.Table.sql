USE [GISData]
GO
/****** Object:  Table [dbo].[gisScreenFieldPermissions]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gisScreenFieldPermissions](
	[screen_number] [int] NOT NULL,
	[permission_id] [int] NOT NULL,
	[last_updated_by] [char](20) NULL,
	[last_updated_on] [datetime] NULL,
	[timestamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_gisScreenFieldPermissions] PRIMARY KEY CLUSTERED 
(
	[screen_number] ASC,
	[permission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_gisScreenFieldPermissions]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_gisScreenFieldPermissions] ON [dbo].[gisScreenFieldPermissions]
(
	[screen_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[gisScreenFieldPermissions]  WITH NOCHECK ADD  CONSTRAINT [FK_gisScreenFieldPermissions_GISPermissionIDs] FOREIGN KEY([permission_id])
REFERENCES [dbo].[GISPermissionIDs] ([permission_id])
GO
ALTER TABLE [dbo].[gisScreenFieldPermissions] CHECK CONSTRAINT [FK_gisScreenFieldPermissions_GISPermissionIDs]
GO
