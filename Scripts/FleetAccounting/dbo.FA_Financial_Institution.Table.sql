USE [GISData]
GO
/****** Object:  Table [dbo].[FA_Financial_Institution]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_Financial_Institution](
	[Fin_Code] [char](10) NOT NULL,
	[Loan_Include_Tax] [bit] NULL,
	[Setup_Fee] [decimal](9, 2) NULL,
	[Bank_GL_Account] [varchar](20) NULL,
	[AP_Vendor_Code] [varchar](20) NULL,
	[Line_Of_Credit] [bit] NULL,
 CONSTRAINT [PK_FA_Financial_Institution] PRIMARY KEY CLUSTERED 
(
	[Fin_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
