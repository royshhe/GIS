USE [GISData]
GO
/****** Object:  Table [dbo].[FA_Loan_Interest_Rate]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_Loan_Interest_Rate](
	[Rate_ID] [smallint] IDENTITY(1,1) NOT NULL,
	[Rate_Code] [varchar](50) NULL,
	[FIN_Code] [char](10) NULL,
	[Interest_Rate] [decimal](11, 9) NULL,
	[Valid_From] [datetime] NULL,
	[Valid_To] [datetime] NULL,
 CONSTRAINT [PK_FA_Loan_Interest_Rate] PRIMARY KEY CLUSTERED 
(
	[Rate_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
