USE [GISData]
GO
/****** Object:  Table [dbo].[Override_Movement_Completion]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Override_Movement_Completion](
	[Unit_Number] [int] NOT NULL,
	[Movement_Out] [datetime] NOT NULL,
	[Override_Contract_Number] [int] NOT NULL,
	[Receiving_Location_ID] [smallint] NOT NULL,
	[Movement_In] [datetime] NOT NULL,
	[Km_In] [int] NULL,
	[Fuel_Level] [char](6) NULL,
	[Litres_of_Fuel_Remaining] [smallint] NULL,
 CONSTRAINT [PK_Override_Movement_Completn] PRIMARY KEY NONCLUSTERED 
(
	[Unit_Number] ASC,
	[Movement_Out] ASC,
	[Override_Contract_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Override_Movement_Completion]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract16] FOREIGN KEY([Override_Contract_Number])
REFERENCES [dbo].[Contract] ([Contract_Number])
GO
ALTER TABLE [dbo].[Override_Movement_Completion] CHECK CONSTRAINT [FK_Contract16]
GO
ALTER TABLE [dbo].[Override_Movement_Completion]  WITH NOCHECK ADD  CONSTRAINT [FK_Location24] FOREIGN KEY([Receiving_Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Override_Movement_Completion] CHECK CONSTRAINT [FK_Location24]
GO
ALTER TABLE [dbo].[Override_Movement_Completion]  WITH CHECK ADD  CONSTRAINT [FK_Vehicle_Movement4] FOREIGN KEY([Unit_Number], [Movement_Out])
REFERENCES [dbo].[Vehicle_Movement] ([Unit_Number], [Movement_Out])
GO
ALTER TABLE [dbo].[Override_Movement_Completion] CHECK CONSTRAINT [FK_Vehicle_Movement4]
GO
