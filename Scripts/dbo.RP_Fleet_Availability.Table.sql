USE [GISData]
GO
/****** Object:  Table [dbo].[RP_Fleet_Availability]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RP_Fleet_Availability](
	[Rpt_date] [datetime] NOT NULL,
	[Current_location] [smallint] NULL,
	[Vehicle_Class_Code] [char](1) NOT NULL,
	[Fleet_Total] [int] NULL
) ON [PRIMARY]
GO
