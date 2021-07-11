USE [GISData]
GO
/****** Object:  Table [dbo].[Renter_Primary_Billing]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Renter_Primary_Billing](
	[Contract_Number] [int] NOT NULL,
	[Contract_Billing_Party_ID] [int] NOT NULL,
	[Credit_Card_Key] [int] NULL,
	[Renter_Authorization_Method] [varchar](15) NOT NULL,
 CONSTRAINT [PK_Renter_Primary_Billing] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Contract_Billing_Party_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [_dta_index_Renter_Primary_Billing_5_1797581442__K1_K3]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_Renter_Primary_Billing_5_1797581442__K1_K3] ON [dbo].[Renter_Primary_Billing]
(
	[Contract_Number] ASC,
	[Credit_Card_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [IX_Renter_Primary_Billing1]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_Renter_Primary_Billing1] ON [dbo].[Renter_Primary_Billing]
(
	[Credit_Card_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Renter_Primary_Billing]  WITH CHECK ADD  CONSTRAINT [FK_Credit_Card1] FOREIGN KEY([Credit_Card_Key])
REFERENCES [dbo].[Credit_Card] ([Credit_Card_Key])
GO
ALTER TABLE [dbo].[Renter_Primary_Billing] CHECK CONSTRAINT [FK_Credit_Card1]
GO
ALTER TABLE [dbo].[Renter_Primary_Billing]  WITH NOCHECK ADD  CONSTRAINT [FK_Renter_Primary_Billing1] FOREIGN KEY([Contract_Number], [Contract_Billing_Party_ID])
REFERENCES [dbo].[Contract_Billing_Party] ([Contract_Number], [Contract_Billing_Party_ID])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[Renter_Primary_Billing] NOCHECK CONSTRAINT [FK_Renter_Primary_Billing1]
GO
