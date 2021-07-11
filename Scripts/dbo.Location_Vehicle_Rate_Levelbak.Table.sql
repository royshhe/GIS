USE [GISData]
GO
/****** Object:  Table [dbo].[Location_Vehicle_Rate_Levelbak]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Location_Vehicle_Rate_Levelbak](
	[Location_Vehicle_Class_ID] [smallint] NOT NULL,
	[Rate_ID] [int] NOT NULL,
	[Rate_Level] [char](1) NOT NULL,
	[Location_Vehicle_Rate_Type] [varchar](20) NOT NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NULL,
	[Rate_Selection_Type] [varchar](20) NOT NULL
) ON [PRIMARY]
GO
