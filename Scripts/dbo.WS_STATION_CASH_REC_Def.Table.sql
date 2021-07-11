USE [GISData]
GO
/****** Object:  Table [dbo].[WS_STATION_CASH_REC_Def]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WS_STATION_CASH_REC_Def](
	[Field_Def_ID] [int] NOT NULL,
	[Field_Level] [smallint] NULL,
	[Field_Name] [varchar](50) NULL,
	[Field_Type] [char](10) NULL,
	[Field_ID] [int] NOT NULL,
	[Start_Position] [int] NOT NULL,
	[End_Position] [int] NULL,
	[Field_length] [smallint] NULL
) ON [PRIMARY]
GO
