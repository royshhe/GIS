USE [GISData]
GO
/****** Object:  Table [dbo].[Contract_Audit_Period]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contract_Audit_Period](
	[Audit_Period_ID] [int] IDENTITY(1,1) NOT NULL,
	[Location_ID] [nchar](10) NULL,
	[Period_Start_Date] [datetime] NULL,
	[Period_End_Date] [datetime] NULL,
 CONSTRAINT [PK_Contract_Audit_Period] PRIMARY KEY CLUSTERED 
(
	[Audit_Period_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
