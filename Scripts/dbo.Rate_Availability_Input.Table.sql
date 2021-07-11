USE [GISData]
GO
/****** Object:  Table [dbo].[Rate_Availability_Input]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rate_Availability_Input](
	[Rate_Avail_ID] [int] IDENTITY(1,1) NOT NULL,
	[Rate_ID] [int] NOT NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NULL,
 CONSTRAINT [PK_Rate_Availability_Input] PRIMARY KEY CLUSTERED 
(
	[Rate_Avail_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
