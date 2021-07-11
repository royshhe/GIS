USE [GISData]
GO
/****** Object:  Table [dbo].[RP_Sunny_Cloudy]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RP_Sunny_Cloudy](
	[RP_date] [smalldatetime] NOT NULL,
	[Type] [varchar](50) NULL,
 CONSTRAINT [PK_RP_Sunny_Cloudy] PRIMARY KEY CLUSTERED 
(
	[RP_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO