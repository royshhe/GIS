USE [GISData]
GO
/****** Object:  Table [dbo].[System_Values]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[System_Values](
	[AR_Debit_Card_Account] [varchar](8) NOT NULL,
	[AR_Canadian_Cash_Account] [varchar](8) NOT NULL,
	[AR_US_Cash_Account] [varchar](8) NOT NULL,
	[GL_US_Exchange_Account] [varchar](32) NOT NULL,
	[GL_Receivables_Clear_Acct] [varchar](32) NOT NULL,
	[GL_Csh_Refnd_Payables_Clr_Acct] [varchar](32) NOT NULL,
	[GL_Ticket_Payables_Clear_Acct] [varchar](32) NOT NULL,
	[GL_CDN_Interbranch_Clear_Acct] [varchar](32) NOT NULL,
	[GL_US_Interbranch_Clear_Acct] [varchar](32) NOT NULL,
	[GL_Deposit_Account] [varchar](32) NOT NULL,
	[AR_Cash_Ticket_Account] [varchar](8) NOT NULL,
	[AR_Cash_Damage_Charge_Account] [varchar](8) NOT NULL,
 CONSTRAINT [PK_System_Values] PRIMARY KEY CLUSTERED 
(
	[AR_Debit_Card_Account] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
