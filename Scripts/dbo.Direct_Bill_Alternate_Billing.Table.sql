USE [GISData]
GO
/****** Object:  Table [dbo].[Direct_Bill_Alternate_Billing]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Direct_Bill_Alternate_Billing](
	[Contract_Number] [int] NOT NULL,
	[Contract_Billing_Party_ID] [int] NOT NULL,
	[PO_Number] [varchar](20) NULL,
 CONSTRAINT [PK_Direct_Bill_Alternate_Billg] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Contract_Billing_Party_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Direct_Bill_Alternate_Billing]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract_Billing_Party1] FOREIGN KEY([Contract_Number], [Contract_Billing_Party_ID])
REFERENCES [dbo].[Contract_Billing_Party] ([Contract_Number], [Contract_Billing_Party_ID])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[Direct_Bill_Alternate_Billing] NOCHECK CONSTRAINT [FK_Contract_Billing_Party1]
GO
