USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle_Class_Vehicle_Model_Yr]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle_Class_Vehicle_Model_Yr](
	[Vehicle_Model_ID] [smallint] NOT NULL,
	[Vehicle_Class_Code] [char](1) NOT NULL,
 CONSTRAINT [PK_Vehicle_Class_Vehicle] PRIMARY KEY CLUSTERED 
(
	[Vehicle_Model_ID] ASC,
	[Vehicle_Class_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vehicle_Class_Vehicle_Model_Yr]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Class7] FOREIGN KEY([Vehicle_Class_Code])
REFERENCES [dbo].[Vehicle_Class] ([Vehicle_Class_Code])
GO
ALTER TABLE [dbo].[Vehicle_Class_Vehicle_Model_Yr] CHECK CONSTRAINT [FK_Vehicle_Class7]
GO
ALTER TABLE [dbo].[Vehicle_Class_Vehicle_Model_Yr]  WITH NOCHECK ADD  CONSTRAINT [FK_Vehicle_Model_Year1] FOREIGN KEY([Vehicle_Model_ID])
REFERENCES [dbo].[Vehicle_Model_Year] ([Vehicle_Model_ID])
GO
ALTER TABLE [dbo].[Vehicle_Class_Vehicle_Model_Yr] CHECK CONSTRAINT [FK_Vehicle_Model_Year1]
GO
