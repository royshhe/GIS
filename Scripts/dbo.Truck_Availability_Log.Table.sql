USE [GISData]
GO
/****** Object:  Table [dbo].[Truck_Availability_Log]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Truck_Availability_Log](
	[Location_ID] [smallint] NOT NULL,
	[Vehicle_Class_Code] [char](1) NOT NULL,
	[Calendar_Date] [datetime] NOT NULL,
	[AM_Availability] [smallint] NOT NULL,
	[PM_Availability] [smallint] NOT NULL,
	[OV_Availability] [smallint] NOT NULL,
	[UpdateTime] [datetime] NOT NULL
) ON [PRIMARY]
GO
