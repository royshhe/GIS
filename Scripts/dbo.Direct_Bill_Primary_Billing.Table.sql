USE [GISData]
GO
/****** Object:  Table [dbo].[Direct_Bill_Primary_Billing]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Direct_Bill_Primary_Billing](
	[Contract_Number] [int] NOT NULL,
	[Contract_Billing_Party_ID] [int] NOT NULL,
	[PO_Number] [varchar](50) NOT NULL,
	[Issue_Interim_Bills] [bit] NOT NULL,
 CONSTRAINT [PK_Direct_Bill_Primary_Billing] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Contract_Billing_Party_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Direct_Bill_Primary_Billing] ADD  CONSTRAINT [DF_Direct_Bill_Issue_Inter]  DEFAULT (0) FOR [Issue_Interim_Bills]
GO
ALTER TABLE [dbo].[Direct_Bill_Primary_Billing]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract_Billing_Party4] FOREIGN KEY([Contract_Number], [Contract_Billing_Party_ID])
REFERENCES [dbo].[Contract_Billing_Party] ([Contract_Number], [Contract_Billing_Party_ID])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[Direct_Bill_Primary_Billing] NOCHECK CONSTRAINT [FK_Contract_Billing_Party4]
GO
