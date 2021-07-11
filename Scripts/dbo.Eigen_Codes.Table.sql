USE [GISData]
GO
/****** Object:  Table [dbo].[Eigen_Codes]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Eigen_Codes](
	[Type] [varchar](10) NOT NULL,
	[Code] [varchar](10) NOT NULL,
	[Description] [varchar](255) NULL,
 CONSTRAINT [PK_Eigen_Codes] PRIMARY KEY CLUSTERED 
(
	[Type] ASC,
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
