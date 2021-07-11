USE [GISData]
GO
/****** Object:  Table [dbo].[FA_Loan_History]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_Loan_History](
	[Unit_Number] [int] NOT NULL,
	[Fin_Code] [char](10) NOT NULL,
	[Principal_Rate_ID] [int] NOT NULL,
	[Override_Principal_Rate] [decimal](10, 7) NULL,
	[Loan_Amount] [decimal](9, 2) NULL,
	[Trans_Month] [decimal](9, 2) NULL,
	[Finance_Start_Date] [datetime] NOT NULL,
	[Finance_End_Date] [datetime] NULL,
	[Payout_Amount] [decimal](9, 2) NULL,
	[Payout_Date] [datetime] NULL,
	[Loan_Setup_Fee] [decimal](9, 2) NULL,
	[Last_Update_On] [datetime] NULL,
 CONSTRAINT [PK_FA_Loan_History] PRIMARY KEY CLUSTERED 
(
	[Unit_Number] ASC,
	[Fin_Code] ASC,
	[Principal_Rate_ID] ASC,
	[Finance_Start_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
