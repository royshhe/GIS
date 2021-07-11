USE [GISData]
GO
/****** Object:  Table [dbo].[Employee_Warning]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee_Warning](
	[Warning_ID] [int] IDENTITY(1,1) NOT NULL,
	[User_ID] [char](20) NULL,
	[Warning_Type] [char](2) NULL,
	[Warning_Date] [datetime] NULL,
	[Description] [varchar](250) NULL,
	[Action] [varchar](250) NULL,
 CONSTRAINT [PK_Employee_Warning] PRIMARY KEY CLUSTERED 
(
	[Warning_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
