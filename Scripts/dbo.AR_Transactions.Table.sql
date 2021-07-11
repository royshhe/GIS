USE [GISData]
GO
/****** Object:  Table [dbo].[AR_Transactions]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AR_Transactions](
	[Business_Transaction_ID] [int] NOT NULL,
	[Sequence] [tinyint] NOT NULL,
	[Customer_Account] [varchar](12) NOT NULL,
	[Amount] [decimal](9, 2) NOT NULL,
	[Purchase_Order_Number] [varchar](20) NULL,
	[Credit_Card_Key] [int] NULL,
	[Loss_Of_Use_Claim_Number] [varchar](15) NULL,
	[Adjuster_First_Name] [varchar](20) NULL,
	[Adjuster_Last_Name] [varchar](20) NULL,
	[Authorization_Number] [varchar](20) NULL,
	[Total_Contract_Amount] [decimal](9, 2) NULL,
	[Total_Contract_Taxes] [decimal](9, 2) NULL,
	[Budget_Claim_Number] [varchar](20) NULL,
	[Ticket_Number] [varchar](20) NULL,
	[Issuing_Jurisdiction] [varchar](20) NULL,
	[Must_Be_Invoice] [bit] NOT NULL,
 CONSTRAINT [PK_AR_Transactions] PRIMARY KEY CLUSTERED 
(
	[Business_Transaction_ID] ASC,
	[Sequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AR_Transactions] ADD  CONSTRAINT [DF_AR_Transact_Must_Be_Inv]  DEFAULT (0) FOR [Must_Be_Invoice]
GO
ALTER TABLE [dbo].[AR_Transactions]  WITH NOCHECK ADD  CONSTRAINT [FK_AR_Transact_Business_Tr] FOREIGN KEY([Business_Transaction_ID])
REFERENCES [dbo].[Business_Transaction] ([Business_Transaction_ID])
GO
ALTER TABLE [dbo].[AR_Transactions] CHECK CONSTRAINT [FK_AR_Transact_Business_Tr]
GO
ALTER TABLE [dbo].[AR_Transactions]  WITH NOCHECK ADD  CONSTRAINT [FK_AR_Transact_Traffic_Vio] FOREIGN KEY([Ticket_Number], [Issuing_Jurisdiction])
REFERENCES [dbo].[Traffic_Violation_Ticket] ([Ticket_Number], [Issuing_Jurisdiction])
GO
ALTER TABLE [dbo].[AR_Transactions] CHECK CONSTRAINT [FK_AR_Transact_Traffic_Vio]
GO
ALTER TABLE [dbo].[AR_Transactions]  WITH NOCHECK ADD  CONSTRAINT [FK_AR_Transactions_Credit_Card] FOREIGN KEY([Credit_Card_Key])
REFERENCES [dbo].[Credit_Card] ([Credit_Card_Key])
GO
ALTER TABLE [dbo].[AR_Transactions] CHECK CONSTRAINT [FK_AR_Transactions_Credit_Card]
GO
