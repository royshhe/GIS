USE [GISData]
GO
/****** Object:  Table [dbo].[Voucher_Alternate_Billing]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Voucher_Alternate_Billing](
	[Contract_Number] [int] NOT NULL,
	[Contract_Billing_Party_ID] [int] NOT NULL,
	[Currency_ID] [tinyint] NOT NULL,
	[Maximum_Payment] [decimal](9, 2) NULL,
	[Foreign_Currency_Max_Payment] [decimal](9, 2) NULL,
	[Exchange_Rate] [decimal](9, 4) NULL,
	[GST_Included] [bit] NOT NULL,
	[PST_Included] [bit] NOT NULL,
	[PVRT_Included] [bit] NOT NULL,
	[Description] [varchar](255) NOT NULL,
 CONSTRAINT [PK_Voucher_Alternate_Billing] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Contract_Billing_Party_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Voucher_Alternate_Billing] ADD  CONSTRAINT [DF__Voucher_A__GST_I__0CF1894F]  DEFAULT (0) FOR [GST_Included]
GO
ALTER TABLE [dbo].[Voucher_Alternate_Billing] ADD  CONSTRAINT [DF__Voucher_A__PST_I__0DE5AD88]  DEFAULT (0) FOR [PST_Included]
GO
ALTER TABLE [dbo].[Voucher_Alternate_Billing] ADD  CONSTRAINT [DF__Voucher_A__PVRT___0ED9D1C1]  DEFAULT (0) FOR [PVRT_Included]
GO
ALTER TABLE [dbo].[Voucher_Alternate_Billing]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract_Billing_Party3] FOREIGN KEY([Contract_Number], [Contract_Billing_Party_ID])
REFERENCES [dbo].[Contract_Billing_Party] ([Contract_Number], [Contract_Billing_Party_ID])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[Voucher_Alternate_Billing] NOCHECK CONSTRAINT [FK_Contract_Billing_Party3]
GO
