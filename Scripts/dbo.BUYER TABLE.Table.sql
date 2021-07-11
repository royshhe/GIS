USE [GISData]
GO
/****** Object:  Table [dbo].[BUYER TABLE]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BUYER TABLE](
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[Address] [nvarchar](50) NULL,
	[City] [nvarchar](30) NULL,
	[Province] [nvarchar](30) NULL,
	[Country] [nvarchar](50) NULL,
	[Post Code] [nvarchar](20) NULL,
	[Telephone] [nvarchar](20) NULL,
	[Fax] [nvarchar](20) NULL,
	[Remarks] [ntext] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
