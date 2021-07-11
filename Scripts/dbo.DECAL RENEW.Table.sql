USE [GISData]
GO
/****** Object:  Table [dbo].[DECAL RENEW]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DECAL RENEW](
	[Type] [nvarchar](50) NULL,
	[Order] [nvarchar](255) NULL,
	[Unit] [nvarchar](50) NULL,
	[VIN] [nvarchar](255) NULL,
	[Model] [nvarchar](255) NULL,
	[Color] [nvarchar](255) NULL,
	[Year] [nvarchar](50) NULL,
	[Km] [int] NULL,
	[Reported Date] [smalldatetime] NULL,
	[License] [nvarchar](255) NULL,
	[Ownership] [nvarchar](50) NULL,
	[Manufacture] [nvarchar](255) NULL,
	[Service] [nvarchar](50) NULL,
	[Remarks] [nvarchar](255) NULL
) ON [PRIMARY]
GO
