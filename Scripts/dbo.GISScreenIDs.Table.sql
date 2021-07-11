USE [GISData]
GO
/****** Object:  Table [dbo].[GISScreenIDs]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GISScreenIDs](
	[screen_number] [int] IDENTITY(1,1) NOT NULL,
	[screen_id] [char](50) NOT NULL,
	[screen_type] [int] NOT NULL,
	[screen_description] [char](100) NOT NULL,
	[MenuItem] [char](100) NULL,
	[MenuSubItem] [char](100) NULL,
	[screen_cat] [char](100) NULL,
	[screen_path] [char](255) NULL,
	[last_updated_by] [char](20) NOT NULL,
	[last_updated_on] [datetime] NOT NULL,
	[timestamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_GISScreenIDs] PRIMARY KEY CLUSTERED 
(
	[screen_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_GISScreenIDs] UNIQUE NONCLUSTERED 
(
	[screen_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
