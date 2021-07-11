USE [GISData]
GO
/****** Object:  Table [dbo].[BCDMatrixBak]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BCDMatrixBak](
	[Version] [varchar](4) NULL,
	[Station] [int] NULL,
	[RateCode] [varchar](10) NULL,
	[upd] [varchar](1) NULL,
	[BCD#] [varchar](10) NULL,
	[CompanyName] [varchar](50) NULL,
	[KM_Cap] [varchar](5) NULL,
	[Coverage] [varchar](9) NULL,
	[Class1] [decimal](9, 2) NULL,
	[Mil1] [decimal](9, 2) NULL,
	[Cap1] [char](10) NULL,
	[Class2] [decimal](9, 2) NULL,
	[Mil2] [decimal](9, 2) NULL,
	[Cap2] [char](10) NULL,
	[Class3] [decimal](9, 2) NULL,
	[Mil3] [decimal](9, 2) NULL,
	[Cap3] [char](10) NULL,
	[Class4] [decimal](9, 2) NULL,
	[Mil4] [decimal](9, 2) NULL,
	[Cap4] [char](10) NULL,
	[Class5] [decimal](9, 2) NULL,
	[Mil5] [decimal](9, 2) NULL,
	[Cap5] [char](10) NULL,
	[Class6] [decimal](9, 2) NULL,
	[Mil6] [decimal](9, 2) NULL,
	[Cap6] [char](10) NULL,
	[Class7] [decimal](9, 2) NULL,
	[Mil7] [decimal](9, 2) NULL,
	[Cap7] [char](10) NULL,
	[Class8] [decimal](9, 2) NULL,
	[Mil8] [decimal](9, 2) NULL,
	[Cap8] [char](10) NULL
) ON [PRIMARY]
GO
