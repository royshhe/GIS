USE [GISData]
GO
/****** Object:  Table [dbo].[BCDBusiness]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BCDBusiness](
	[BCD_Number] [nvarchar](10) NULL,
	[Organization] [nvarchar](50) NULL,
	[TRAC] [decimal](9, 2) NULL,
	[Old_Vol_ Comm] [decimal](9, 2) NULL,
	[New_Vol_com] [decimal](9, 2) NULL,
	[Type] [nvarchar](20) NULL
) ON [PRIMARY]
GO
