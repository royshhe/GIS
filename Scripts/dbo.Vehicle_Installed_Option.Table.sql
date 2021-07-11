USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle_Installed_Option]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle_Installed_Option](
	[Vehicle_Option_ID] [smallint] NOT NULL,
	[Unit_Number] [int] NOT NULL,
 CONSTRAINT [PK_Vehicle_Installed_Option] PRIMARY KEY CLUSTERED 
(
	[Vehicle_Option_ID] ASC,
	[Unit_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vehicle_Installed_Option]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle9] FOREIGN KEY([Unit_Number])
REFERENCES [dbo].[Vehicle] ([Unit_Number])
GO
ALTER TABLE [dbo].[Vehicle_Installed_Option] CHECK CONSTRAINT [FK_Vehicle9]
GO
