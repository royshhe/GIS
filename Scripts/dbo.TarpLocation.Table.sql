USE [GISData]
GO
/****** Object:  Table [dbo].[TarpLocation]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TarpLocation](
	[TarpLocationID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Location] [char](50) NOT NULL,
	[DBRCode] [int] NOT NULL,
	[GISLocationID] [int] NOT NULL,
	[MaestroLocCode] [char](10) NULL,
	[MisLocationCode] [char](10) NULL,
	[OwningCompanyID] [int] NOT NULL,
 CONSTRAINT [PK_TarpLocation] PRIMARY KEY CLUSTERED 
(
	[TarpLocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
