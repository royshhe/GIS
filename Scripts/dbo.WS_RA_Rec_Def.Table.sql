USE [GISData]
GO
/****** Object:  Table [dbo].[WS_RA_Rec_Def]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WS_RA_Rec_Def](
	[RA_Field_Def_ID] [int] NOT NULL,
	[Field_Level] [smallint] NULL,
	[Field_Name] [varchar](50) NULL,
	[Field_Type] [char](10) NULL,
	[Field_ID] [int] NOT NULL,
	[Start_Position] [int] NOT NULL,
	[End_Position] [int] NULL,
	[Field_length] [smallint] NULL,
 CONSTRAINT [PK_WS_RA_Rec_Def] PRIMARY KEY CLUSTERED 
(
	[RA_Field_Def_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_WS_RA_Rec_Def]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_WS_RA_Rec_Def] ON [dbo].[WS_RA_Rec_Def]
(
	[Field_ID] ASC,
	[Start_Position] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
