USE [GISData]
GO
/****** Object:  Table [dbo].[SystemSettingValues]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SystemSettingValues](
	[SettingID] [int] NOT NULL,
	[ValueName] [varchar](50) NOT NULL,
	[SettingValue] [varchar](100) NULL,
	[Description] [varchar](100) NULL,
 CONSTRAINT [PK_SystemSettingValues] PRIMARY KEY CLUSTERED 
(
	[SettingID] ASC,
	[ValueName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
