USE [GISData]
GO
/****** Object:  Table [dbo].[Contract_Audit]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contract_Audit](
	[Issue_ID] [int] IDENTITY(1,1) NOT NULL,
	[User_ID] [char](20) NULL,
	[Type] [char](2) NULL,
	[Issue] [char](2) NULL,
	[Issue_Date] [datetime] NULL,
	[Contract_Number] [int] NULL,
	[Description] [varchar](350) NULL,
	[Amount_affected] [decimal](9, 2) NULL,
	[Remarks] [varchar](120) NULL,
 CONSTRAINT [PK_Contract_Audit] PRIMARY KEY CLUSTERED 
(
	[Issue_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
