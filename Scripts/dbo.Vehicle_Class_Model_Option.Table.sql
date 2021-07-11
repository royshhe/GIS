USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle_Class_Model_Option]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle_Class_Model_Option](
	[Vehicle_Class_Code] [char](1) NOT NULL,
	[Model_Option] [smallint] NOT NULL,
 CONSTRAINT [PK_Vehicle_Class_Model_Option] PRIMARY KEY CLUSTERED 
(
	[Vehicle_Class_Code] ASC,
	[Model_Option] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
