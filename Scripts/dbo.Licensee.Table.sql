USE [GISData]
GO
/****** Object:  Table [dbo].[Licensee]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Licensee](
	[Rental Zone Id] [float] NULL,
	[Rental Loc Id] [float] NULL,
	[Rental Loc Desc] [nvarchar](255) NULL,
	[Co Date] [smalldatetime] NULL,
	[Correct reservation date] [smalldatetime] NULL,
	[Distribution Channel] [nvarchar](255) NULL,
	[Res Count] [float] NULL,
	[Complete Res No] [nvarchar](255) NULL
) ON [PRIMARY]
GO
