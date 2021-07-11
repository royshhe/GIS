USE [GISData]
GO
/****** Object:  Table [dbo].[GIS_Security_Audit_Log]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GIS_Security_Audit_Log](
	[Log_ID] [int] IDENTITY(1,1) NOT NULL,
	[Transaction_By] [varchar](20) NOT NULL,
	[Transaction_On] [datetime] NULL,
	[Action_Type] [char](2) NOT NULL,
	[Action_Detail] [varchar](255) NULL,
 CONSTRAINT [PK_GISSAL_Log_ID] PRIMARY KEY CLUSTERED 
(
	[Log_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GIS_Security_Audit_Log] ADD  CONSTRAINT [DF__GIS_Secur__Trans__088BFB8E]  DEFAULT (getdate()) FOR [Transaction_On]
GO
