USE [GISData]
GO
/****** Object:  Table [dbo].[FA_Loan_Principal_Rate]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_Loan_Principal_Rate](
	[Rate_ID] [smallint] IDENTITY(1,1) NOT NULL,
	[Rate_Code] [varchar](50) NOT NULL,
	[Fin_Code] [char](25) NOT NULL,
	[Program] [bit] NOT NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Terminate_Date] [datetime] NOT NULL,
	[Order] [char](10) NULL,
 CONSTRAINT [PK_FA_Loan_Principal_Rate] PRIMARY KEY CLUSTERED 
(
	[Rate_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_FA_Loan_Principal_Rate] UNIQUE NONCLUSTERED 
(
	[Rate_Code] ASC,
	[Fin_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FA_Loan_Principal_Rate] ADD  CONSTRAINT [DF_FA_Loan_Principle_Rate_Terminate_Date]  DEFAULT ('2078-12-31 23:59:59') FOR [Terminate_Date]
GO
