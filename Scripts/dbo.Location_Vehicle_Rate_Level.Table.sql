USE [GISData]
GO
/****** Object:  Table [dbo].[Location_Vehicle_Rate_Level]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Location_Vehicle_Rate_Level](
	[Location_Vehicle_Class_ID] [smallint] NOT NULL,
	[Rate_ID] [int] NOT NULL,
	[Rate_Level] [char](1) NOT NULL,
	[Location_Vehicle_Rate_Type] [varchar](20) NOT NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NULL,
	[Rate_Selection_Type] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Location_Vehicle_Rate_Level] PRIMARY KEY CLUSTERED 
(
	[Location_Vehicle_Class_ID] ASC,
	[Rate_ID] ASC,
	[Rate_Level] ASC,
	[Location_Vehicle_Rate_Type] ASC,
	[Valid_From] ASC,
	[Rate_Selection_Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_LocationVehicleRateLevel_RateID]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_LocationVehicleRateLevel_RateID] ON [dbo].[Location_Vehicle_Rate_Level]
(
	[Rate_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Location_Vehicle_Rate_Level]  WITH NOCHECK ADD  CONSTRAINT [FK_Location_Vehicle_Class1] FOREIGN KEY([Location_Vehicle_Class_ID])
REFERENCES [dbo].[Location_Vehicle_Class] ([Location_Vehicle_Class_ID])
GO
ALTER TABLE [dbo].[Location_Vehicle_Rate_Level] CHECK CONSTRAINT [FK_Location_Vehicle_Class1]
GO
ALTER TABLE [dbo].[Location_Vehicle_Rate_Level]  WITH NOCHECK ADD  CONSTRAINT [FK_Location_Vehicle_Rate_Level_Rate_Level] FOREIGN KEY([Rate_ID], [Valid_From], [Rate_Level])
REFERENCES [dbo].[Rate_Level] ([Rate_ID], [Effective_Date], [Rate_Level])
GO
ALTER TABLE [dbo].[Location_Vehicle_Rate_Level] NOCHECK CONSTRAINT [FK_Location_Vehicle_Rate_Level_Rate_Level]
GO
