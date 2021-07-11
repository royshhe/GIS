USE [GISData]
GO
/****** Object:  Table [dbo].[Contract_Audit_Issue_Type]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contract_Audit_Issue_Type](
	[Issues_ID] [char](2) NOT NULL,
	[Type_ID] [char](2) NULL,
 CONSTRAINT [PK_Contract_Audit_Issue_Type] PRIMARY KEY CLUSTERED 
(
	[Issues_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
