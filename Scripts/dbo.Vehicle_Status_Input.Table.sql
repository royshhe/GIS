USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle_Status_Input]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle_Status_Input](
	[Unit_Number] [int] NOT NULL,
	[Status_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_Vehicle_Status_Input] PRIMARY KEY CLUSTERED 
(
	[Unit_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
