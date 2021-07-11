USE [GISData]
GO
/****** Object:  Table [dbo].[MSlast_job_info]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MSlast_job_info](
	[publisher] [varchar](30) NULL,
	[publisher_db] [varchar](30) NULL,
	[job_id] [int] NULL,
	[publication] [varchar](30) NULL,
	[article] [varchar](30) NULL,
	[description] [varchar](100) NULL
) ON [PRIMARY]
GO
