USE [GISData]
GO
/****** Object:  Table [dbo].[VehicleClassBlackOut]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VehicleClassBlackOut](
	[BlackOutID] [int] IDENTITY(1,1) NOT NULL,
	[Location_ID] [int] NULL,
	[DestinationHubID] [int] NULL,
	[Vehicle_Class_Code] [char](1) NULL,
	[BlackoutStartDate] [datetime] NULL,
	[BlackoutEndDate] [datetime] NULL,
 CONSTRAINT [PK_VehicleClassBlackOut] PRIMARY KEY CLUSTERED 
(
	[BlackOutID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
