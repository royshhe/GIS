USE [GISData]
GO
/****** Object:  Table [dbo].[Location_Vehicle_Class]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Location_Vehicle_Class](
	[Location_Vehicle_Class_ID] [smallint] IDENTITY(1,1) NOT NULL,
	[Location_ID] [smallint] NOT NULL,
	[Vehicle_Class_Code] [char](1) NOT NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NULL,
 CONSTRAINT [PK_Location_Vehicle_Class] PRIMARY KEY CLUSTERED 
(
	[Location_Vehicle_Class_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UC_Location_Vehicle_Class1] UNIQUE NONCLUSTERED 
(
	[Location_ID] ASC,
	[Vehicle_Class_Code] ASC,
	[Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Location_Vehicle_Class1]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_Location_Vehicle_Class1] ON [dbo].[Location_Vehicle_Class]
(
	[Location_ID] ASC,
	[Vehicle_Class_Code] ASC,
	[Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Location_Vehicle_Class]  WITH NOCHECK ADD  CONSTRAINT [FK_Location10] FOREIGN KEY([Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Location_Vehicle_Class] CHECK CONSTRAINT [FK_Location10]
GO
ALTER TABLE [dbo].[Location_Vehicle_Class]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Class1] FOREIGN KEY([Vehicle_Class_Code])
REFERENCES [dbo].[Vehicle_Class] ([Vehicle_Class_Code])
GO
ALTER TABLE [dbo].[Location_Vehicle_Class] CHECK CONSTRAINT [FK_Vehicle_Class1]
GO
