USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle_Location_Restriction]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle_Location_Restriction](
	[Unit_Number] [int] NOT NULL,
	[Location_ID] [smallint] NOT NULL,
 CONSTRAINT [PK_Vehicle_Location_Restrictn] PRIMARY KEY CLUSTERED 
(
	[Unit_Number] ASC,
	[Location_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vehicle_Location_Restriction]  WITH NOCHECK ADD  CONSTRAINT [FK_Location5] FOREIGN KEY([Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Vehicle_Location_Restriction] CHECK CONSTRAINT [FK_Location5]
GO
ALTER TABLE [dbo].[Vehicle_Location_Restriction]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle3] FOREIGN KEY([Unit_Number])
REFERENCES [dbo].[Vehicle] ([Unit_Number])
GO
ALTER TABLE [dbo].[Vehicle_Location_Restriction] CHECK CONSTRAINT [FK_Vehicle3]
GO
