USE [GISData]
GO
/****** Object:  Table [dbo].[RP_Run]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RP_Run](
	[Run_ID] [int] IDENTITY(1,1) NOT NULL,
	[Report_Name] [varchar](50) NOT NULL,
	[Run_On] [datetime] NOT NULL
) ON [PRIMARY]
GO
