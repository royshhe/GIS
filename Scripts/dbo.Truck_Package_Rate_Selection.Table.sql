USE [GISData]
GO
/****** Object:  Table [dbo].[Truck_Package_Rate_Selection]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Truck_Package_Rate_Selection](
	[Rate_Selection_ID] [int] IDENTITY(1,1) NOT NULL,
	[Pickup_Location_ID] [int] NOT NULL,
	[Vehicle_Class_Code] [char](1) NOT NULL,
	[Rate_ID] [int] NOT NULL,
	[Rate_Level] [char](1) NOT NULL,
	[Discount_Option] [bit] NOT NULL,
	[PU_DOW_SUN] [bit] NOT NULL,
	[PU_DOW_MON] [bit] NOT NULL,
	[PU_DOW_TUE] [bit] NOT NULL,
	[PU_DOW_WED] [bit] NOT NULL,
	[PU_DOW_THU] [bit] NOT NULL,
	[PU_DOW_FRI] [bit] NOT NULL,
	[PU_DOW_SAT] [bit] NOT NULL,
	[DO_DOW_SUN] [bit] NOT NULL,
	[DO_DOW_MON] [bit] NOT NULL,
	[DO_DOW_TUE] [bit] NOT NULL,
	[DO_DOW_WED] [bit] NOT NULL,
	[DO_DOW_THU] [bit] NOT NULL,
	[DO_DOW_FRI] [bit] NOT NULL,
	[DO_DOW_SAT] [bit] NOT NULL,
	[LOR_MIN] [int] NULL,
	[LOR_MAX] [int] NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NULL,
 CONSTRAINT [PK_Truck_Package_Rate_Selection] PRIMARY KEY CLUSTERED 
(
	[Rate_Selection_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Truck_Package_Rate_Selection] ADD  CONSTRAINT [DF_Truck_Package_Rate_Selection_PU_DOW_SUN]  DEFAULT (0) FOR [PU_DOW_SUN]
GO
ALTER TABLE [dbo].[Truck_Package_Rate_Selection] ADD  CONSTRAINT [DF_Truck_Package_Rate_Selection_PU_DOW_MON]  DEFAULT (0) FOR [PU_DOW_MON]
GO
ALTER TABLE [dbo].[Truck_Package_Rate_Selection] ADD  CONSTRAINT [DF_Truck_Package_Rate_Selection_PU_DOW_TUE]  DEFAULT (0) FOR [PU_DOW_TUE]
GO
ALTER TABLE [dbo].[Truck_Package_Rate_Selection] ADD  CONSTRAINT [DF_Truck_Package_Rate_Selection_PU_DOW_WED]  DEFAULT (0) FOR [PU_DOW_WED]
GO
ALTER TABLE [dbo].[Truck_Package_Rate_Selection] ADD  CONSTRAINT [DF_Truck_Package_Rate_Selection_PU_DOW_THU]  DEFAULT (0) FOR [PU_DOW_THU]
GO
ALTER TABLE [dbo].[Truck_Package_Rate_Selection] ADD  CONSTRAINT [DF_Truck_Package_Rate_Selection_PU_DOW_FRI]  DEFAULT (0) FOR [PU_DOW_FRI]
GO
ALTER TABLE [dbo].[Truck_Package_Rate_Selection] ADD  CONSTRAINT [DF_Truck_Package_Rate_Selection_PU_DOW_SAT]  DEFAULT (0) FOR [PU_DOW_SAT]
GO
ALTER TABLE [dbo].[Truck_Package_Rate_Selection] ADD  CONSTRAINT [DF_Truck_Package_Rate_Selection_DO_DOW_SUN]  DEFAULT (1) FOR [DO_DOW_SUN]
GO
ALTER TABLE [dbo].[Truck_Package_Rate_Selection] ADD  CONSTRAINT [DF_Truck_Package_Rate_Selection_DO_DOW_MON]  DEFAULT (1) FOR [DO_DOW_MON]
GO
ALTER TABLE [dbo].[Truck_Package_Rate_Selection] ADD  CONSTRAINT [DF_Truck_Package_Rate_Selection_DO_DOW_TUE]  DEFAULT (1) FOR [DO_DOW_TUE]
GO
ALTER TABLE [dbo].[Truck_Package_Rate_Selection] ADD  CONSTRAINT [DF_Truck_Package_Rate_Selection_DO_DOW_WED]  DEFAULT (1) FOR [DO_DOW_WED]
GO
ALTER TABLE [dbo].[Truck_Package_Rate_Selection] ADD  CONSTRAINT [DF_Truck_Package_Rate_Selection_DO_DOW_THU]  DEFAULT (1) FOR [DO_DOW_THU]
GO
ALTER TABLE [dbo].[Truck_Package_Rate_Selection] ADD  CONSTRAINT [DF_Truck_Package_Rate_Selection_DO_DOW_FRI]  DEFAULT (1) FOR [DO_DOW_FRI]
GO
ALTER TABLE [dbo].[Truck_Package_Rate_Selection] ADD  CONSTRAINT [DF_Truck_Package_Rate_Selection_DO_DOW_SAT]  DEFAULT (1) FOR [DO_DOW_SAT]
GO
