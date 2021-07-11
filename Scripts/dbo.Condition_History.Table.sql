USE [GISData]
GO
/****** Object:  Table [dbo].[Condition_History]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Condition_History](
	[Unit_Number] [int] NOT NULL,
	[Condition_Status] [char](1) NOT NULL,
	[Effective_On] [datetime] NOT NULL,
 CONSTRAINT [PK_Condition_History] PRIMARY KEY CLUSTERED 
(
	[Unit_Number] ASC,
	[Condition_Status] ASC,
	[Effective_On] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Condition_History]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle6] FOREIGN KEY([Unit_Number])
REFERENCES [dbo].[Vehicle] ([Unit_Number])
GO
ALTER TABLE [dbo].[Condition_History] CHECK CONSTRAINT [FK_Vehicle6]
GO
