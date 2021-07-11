USE [GISData]
GO
/****** Object:  Table [dbo].[FA_Loan_Amortization]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_Loan_Amortization](
	[Unit_Number] [int] NOT NULL,
	[AMO_Month] [datetime] NOT NULL,
	[Fin_Code] [char](10) NOT NULL,
	[Finance_Start_Date] [datetime] NOT NULL,
	[Principle_Amount] [decimal](9, 2) NULL,
	[Interest_Amount] [decimal](9, 2) NULL,
	[Balance] [decimal](10, 2) NULL,
	[Last_Updated_On] [datetime] NULL,
 CONSTRAINT [PK_FA_Loan_Amortization] PRIMARY KEY CLUSTERED 
(
	[Unit_Number] ASC,
	[AMO_Month] ASC,
	[Fin_Code] ASC,
	[Finance_Start_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FA_Loan_Amortization]  WITH NOCHECK ADD  CONSTRAINT [FK_FA_Loan_Amortization_Vehicle] FOREIGN KEY([Unit_Number])
REFERENCES [dbo].[Vehicle] ([Unit_Number])
GO
ALTER TABLE [dbo].[FA_Loan_Amortization] CHECK CONSTRAINT [FK_FA_Loan_Amortization_Vehicle]
GO
