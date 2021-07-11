USE [GISData]
GO
/****** Object:  Table [dbo].[FA_Loan_Principal_Rate_Detail]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_Loan_Principal_Rate_Detail](
	[Rate_ID] [smallint] NOT NULL,
	[Start_Month] [smallint] NOT NULL,
	[End_Month] [smallint] NOT NULL,
	[Principal_Rate] [decimal](11, 9) NULL,
	[Principal_Rate_Amount] [decimal](9, 2) NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NULL,
 CONSTRAINT [PK_FA_Loan_Principal_Rate_Detail] PRIMARY KEY CLUSTERED 
(
	[Rate_ID] ASC,
	[Start_Month] ASC,
	[Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FA_Loan_Principal_Rate_Detail]  WITH CHECK ADD  CONSTRAINT [FK_FA_Loan_Principal_Rate_Detail_FA_Loan_Principal_Rate] FOREIGN KEY([Rate_ID])
REFERENCES [dbo].[FA_Loan_Principal_Rate] ([Rate_ID])
GO
ALTER TABLE [dbo].[FA_Loan_Principal_Rate_Detail] CHECK CONSTRAINT [FK_FA_Loan_Principal_Rate_Detail_FA_Loan_Principal_Rate]
GO
