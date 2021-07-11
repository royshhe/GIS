USE [GISData]
GO
/****** Object:  Table [dbo].[GISPermissionIDs]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GISPermissionIDs](
	[permission_id] [int] NOT NULL,
	[permission_description] [char](50) NOT NULL,
	[last_updated_by] [char](20) NOT NULL,
	[last_updated_on] [datetime] NOT NULL,
	[timestamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_PermissionIDs] PRIMARY KEY NONCLUSTERED 
(
	[permission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_PermissionIDs]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_PermissionIDs] ON [dbo].[GISPermissionIDs]
(
	[permission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
