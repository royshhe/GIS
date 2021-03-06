USE [GISData]
GO
/****** Object:  Table [dbo].[FA_Loan_Month_End]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_Loan_Month_End](
	[FA_Month] [datetime] NOT NULL,
	[Fin_Code] [char](10) NOT NULL,
	[Loan_AMO_Date] [datetime] NULL,
 CONSTRAINT [PK_FA_Loan_Month_End] PRIMARY KEY CLUSTERED 
(
	[FA_Month] ASC,
	[Fin_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
