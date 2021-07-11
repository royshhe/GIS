USE [GISData]
GO
/****** Object:  Table [dbo].[Truck_Inventory]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Truck_Inventory](
	[Location_ID] [smallint] NOT NULL,
	[Vehicle_Class_Code] [char](1) NOT NULL,
	[Calendar_Date] [datetime] NOT NULL,
	[AM_Inventory] [smallint] NOT NULL,
	[PM_Inventory] [smallint] NOT NULL,
	[OV_Inventory] [smallint] NOT NULL,
	[AM_Availability] [smallint] NOT NULL,
	[PM_Availability] [smallint] NOT NULL,
	[OV_Availability] [smallint] NOT NULL,
 CONSTRAINT [PK_Truck_Inventory] PRIMARY KEY CLUSTERED 
(
	[Location_ID] ASC,
	[Vehicle_Class_Code] ASC,
	[Calendar_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Truck_Inventory]  WITH NOCHECK ADD  CONSTRAINT [FK_Location19] FOREIGN KEY([Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Truck_Inventory] CHECK CONSTRAINT [FK_Location19]
GO
ALTER TABLE [dbo].[Truck_Inventory]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Class14] FOREIGN KEY([Vehicle_Class_Code])
REFERENCES [dbo].[Vehicle_Class] ([Vehicle_Class_Code])
GO
ALTER TABLE [dbo].[Truck_Inventory] CHECK CONSTRAINT [FK_Vehicle_Class14]
GO
