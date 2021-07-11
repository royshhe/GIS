USE [GISData]
GO
/****** Object:  Table [dbo].[GIS_Security_User_Permission]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GIS_Security_User_Permission](
	[Admin_ID] [char](20) NOT NULL,
	[GSMPermission_ID] [int] NOT NULL,
 CONSTRAINT [PK_GIS_Security_User_Permission] PRIMARY KEY CLUSTERED 
(
	[Admin_ID] ASC,
	[GSMPermission_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
