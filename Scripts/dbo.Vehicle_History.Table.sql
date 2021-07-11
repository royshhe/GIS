USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle_History]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle_History](
	[Unit_Number] [int] NOT NULL,
	[Vehicle_Status] [char](1) NOT NULL,
	[Effective_On] [datetime] NOT NULL,
 CONSTRAINT [PK_Vehicle_History] PRIMARY KEY CLUSTERED 
(
	[Unit_Number] ASC,
	[Vehicle_Status] ASC,
	[Effective_On] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vehicle_History]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle7] FOREIGN KEY([Unit_Number])
REFERENCES [dbo].[Vehicle] ([Unit_Number])
GO
ALTER TABLE [dbo].[Vehicle_History] CHECK CONSTRAINT [FK_Vehicle7]
GO
