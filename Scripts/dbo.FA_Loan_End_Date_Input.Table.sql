USE [GISData]
GO
/****** Object:  Table [dbo].[FA_Loan_End_Date_Input]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_Loan_End_Date_Input](
	[Unit_Number] [int] NOT NULL,
	[Loan_end_date] [datetime] NULL,
 CONSTRAINT [PK_FA_Loan_End_Date_Input] PRIMARY KEY CLUSTERED 
(
	[Unit_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
