USE [GISData]
GO
/****** Object:  Table [dbo].[Reimbursement_Reason]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reimbursement_Reason](
	[Reason] [varchar](255) NOT NULL,
	[GL_Reimbursement_Account_Code] [varchar](32) NULL,
	[IBX_Reason_Code] [varchar](20) NULL,
 CONSTRAINT [PK_Reimbursement_Reason] PRIMARY KEY NONCLUSTERED 
(
	[Reason] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
