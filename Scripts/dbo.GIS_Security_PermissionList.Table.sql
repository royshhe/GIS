USE [GISData]
GO
/****** Object:  Table [dbo].[GIS_Security_PermissionList]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GIS_Security_PermissionList](
	[GSMPermission_ID] [int] NOT NULL,
	[Description] [char](50) NULL,
 CONSTRAINT [PK_GIS_Security_PermissionList] PRIMARY KEY CLUSTERED 
(
	[GSMPermission_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
