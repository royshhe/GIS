USE [GISData]
GO
/****** Object:  Table [dbo].[GIS_Security_Admin]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GIS_Security_Admin](
	[Admin_ID] [varchar](20) NOT NULL,
	[Admin_Password] [varchar](20) NULL,
	[NTLogOn_ID] [varchar](20) NULL,
	[Created_On] [datetime] NULL,
	[Created_By] [varchar](20) NULL,
	[Status] [char](1) NOT NULL,
	[Last_Updated_By] [varchar](20) NULL,
	[Last_Updated_On] [datetime] NULL,
	[Application] [varchar](50) NULL,
	[Security_Level] [varchar](50) NULL,
 CONSTRAINT [PK_GISSA_Admin_ID] PRIMARY KEY CLUSTERED 
(
	[Admin_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GIS_Security_Admin] ADD  CONSTRAINT [DF__GIS_Secur__Last___04BB6AAA]  DEFAULT (getdate()) FOR [Last_Updated_On]
GO
