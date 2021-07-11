USE [GISData]
GO
/****** Object:  Table [dbo].[Contract_Billing_Party]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contract_Billing_Party](
	[Contract_Number] [int] NOT NULL,
	[Contract_Billing_Party_ID] [int] NOT NULL,
	[Billing_Type] [char](1) NOT NULL,
	[Billing_Method] [varchar](20) NOT NULL,
	[Customer_Code] [varchar](12) NULL,
	[Amt_Removed_From_Avail_Credit] [decimal](9, 2) NOT NULL,
 CONSTRAINT [PK_Contract_Billing_Party] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Contract_Billing_Party_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [_dta_index_Contract_Billing_Party_5_1995310318__K3_K1_K4_K5]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_Contract_Billing_Party_5_1995310318__K3_K1_K4_K5] ON [dbo].[Contract_Billing_Party]
(
	[Billing_Type] ASC,
	[Contract_Number] ASC,
	[Billing_Method] ASC,
	[Customer_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [_dta_index_Contract_Billing_Party_5_1995310318__K4_K1_K3_K5]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_Contract_Billing_Party_5_1995310318__K4_K1_K3_K5] ON [dbo].[Contract_Billing_Party]
(
	[Billing_Method] ASC,
	[Contract_Number] ASC,
	[Billing_Type] ASC,
	[Customer_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contract_Billing_Party]  WITH NOCHECK ADD  CONSTRAINT [FK_Billing_Method1] FOREIGN KEY([Billing_Method], [Billing_Type])
REFERENCES [dbo].[Billing_Method] ([Billing_Method], [Type])
GO
ALTER TABLE [dbo].[Contract_Billing_Party] CHECK CONSTRAINT [FK_Billing_Method1]
GO
ALTER TABLE [dbo].[Contract_Billing_Party]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract04] FOREIGN KEY([Contract_Number])
REFERENCES [dbo].[Contract] ([Contract_Number])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[Contract_Billing_Party] NOCHECK CONSTRAINT [FK_Contract04]
GO
