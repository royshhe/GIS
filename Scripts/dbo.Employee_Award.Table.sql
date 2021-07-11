USE [GISData]
GO
/****** Object:  Table [dbo].[Employee_Award]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee_Award](
	[Award_ID] [int] IDENTITY(1,1) NOT NULL,
	[User_ID] [char](20) NULL,
	[Award_Date] [datetime] NULL,
	[Description] [varchar](100) NULL,
 CONSTRAINT [PK_Employee_Award] PRIMARY KEY CLUSTERED 
(
	[Award_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
