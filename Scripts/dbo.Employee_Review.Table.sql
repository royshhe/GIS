USE [GISData]
GO
/****** Object:  Table [dbo].[Employee_Review]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee_Review](
	[Review_ID] [int] IDENTITY(1,1) NOT NULL,
	[User_ID] [char](20) NULL,
	[Description] [varchar](250) NULL,
	[Reviewed_By] [varchar](50) NULL,
	[Review_Date] [datetime] NULL,
 CONSTRAINT [PK_Employee_Review] PRIMARY KEY CLUSTERED 
(
	[Review_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
