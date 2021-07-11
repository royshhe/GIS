USE [GISData]
GO
/****** Object:  Table [dbo].[Employee_Departments]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee_Departments](
	[Department_ID] [smallint] IDENTITY(1,1) NOT NULL,
	[Department_Name] [varchar](50) NULL,
	[Description] [varchar](100) NULL,
	[GIS_User] [bit] NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_Employee_Departments] PRIMARY KEY CLUSTERED 
(
	[Department_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
