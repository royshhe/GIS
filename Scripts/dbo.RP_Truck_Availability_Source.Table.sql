USE [GISData]
GO
/****** Object:  Table [dbo].[RP_Truck_Availability_Source]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RP_Truck_Availability_Source](
	[Location_ID] [smallint] NULL,
	[Vehicle_Class_Code] [nchar](1) NULL,
	[Pick_Up_On] [datetime] NULL,
	[Drop_Off_On] [datetime] NULL,
	[Source] [varchar](20) NULL
) ON [PRIMARY]
GO
