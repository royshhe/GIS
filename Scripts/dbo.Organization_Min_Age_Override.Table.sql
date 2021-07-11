USE [GISData]
GO
/****** Object:  Table [dbo].[Organization_Min_Age_Override]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Organization_Min_Age_Override](
	[Organization_ID] [int] NOT NULL,
	[Vehicle_Class_Code] [char](1) NOT NULL,
	[Minimum_Age] [int] NOT NULL,
 CONSTRAINT [PK_Organization_Min_Age_Overrd] PRIMARY KEY CLUSTERED 
(
	[Organization_ID] ASC,
	[Vehicle_Class_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Organization_Min_Age_Override]  WITH CHECK ADD  CONSTRAINT [FK_Organization6] FOREIGN KEY([Organization_ID])
REFERENCES [dbo].[Organization] ([Organization_ID])
GO
ALTER TABLE [dbo].[Organization_Min_Age_Override] CHECK CONSTRAINT [FK_Organization6]
GO
ALTER TABLE [dbo].[Organization_Min_Age_Override]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Class12] FOREIGN KEY([Vehicle_Class_Code])
REFERENCES [dbo].[Vehicle_Class] ([Vehicle_Class_Code])
GO
ALTER TABLE [dbo].[Organization_Min_Age_Override] CHECK CONSTRAINT [FK_Vehicle_Class12]
GO
