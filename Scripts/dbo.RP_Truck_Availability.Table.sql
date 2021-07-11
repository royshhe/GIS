USE [GISData]
GO
/****** Object:  Table [dbo].[RP_Truck_Availability]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RP_Truck_Availability](
	[Location_ID] [smallint] NOT NULL,
	[Vehicle_Class_Code] [char](1) NOT NULL,
	[Calendar_Date] [datetime] NOT NULL,
	[AM_Inventory] [smallint] NOT NULL,
	[PM_Inventory] [smallint] NOT NULL,
	[OV_Inventory] [smallint] NOT NULL,
	[AM_Availability] [smallint] NOT NULL,
	[PM_Availability] [smallint] NOT NULL,
	[OV_Availability] [smallint] NOT NULL,
 CONSTRAINT [PK_RP_Truck_Availability] PRIMARY KEY CLUSTERED 
(
	[Location_ID] ASC,
	[Vehicle_Class_Code] ASC,
	[Calendar_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
