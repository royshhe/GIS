USE [GISData]
GO
/****** Object:  Table [dbo].[Restriction]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Restriction](
	[Restriction_ID] [smallint] IDENTITY(1,1) NOT NULL,
	[Hour_Type] [bit] NOT NULL,
	[Day_Type] [bit] NOT NULL,
	[Time_Type] [bit] NOT NULL,
	[Restriction] [varchar](255) NOT NULL,
 CONSTRAINT [PK_Restriction] PRIMARY KEY CLUSTERED 
(
	[Restriction_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UC_Restriction1] UNIQUE NONCLUSTERED 
(
	[Restriction] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO