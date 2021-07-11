USE [GISData]
GO
/****** Object:  Table [dbo].[PM_Schedule]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PM_Schedule](
	[Schedule_ID] [int] IDENTITY(1,1) NOT NULL,
	[Schedule_Name] [varchar](50) NULL,
	[Tracked_By_Date] [bit] NULL,
	[Tracked_By_Meter] [bit] NULL,
	[Meter_Type] [char](10) NULL,
 CONSTRAINT [PK_VM_PM_Schedule] PRIMARY KEY CLUSTERED 
(
	[Schedule_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
