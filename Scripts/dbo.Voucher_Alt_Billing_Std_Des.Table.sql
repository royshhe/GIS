USE [GISData]
GO
/****** Object:  Table [dbo].[Voucher_Alt_Billing_Std_Des]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Voucher_Alt_Billing_Std_Des](
	[Contract_Number] [int] NOT NULL,
	[Contract_Billing_Party_ID] [int] NOT NULL,
	[Voucher_Std_Des_ID] [smallint] NOT NULL,
 CONSTRAINT [PK_Voucher_Alt_Billing_Std_Des] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Contract_Billing_Party_ID] ASC,
	[Voucher_Std_Des_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Voucher_Alt_Billing_Std_Des]  WITH CHECK ADD  CONSTRAINT [FK_Voucher_Alternate_Billing1] FOREIGN KEY([Contract_Number], [Contract_Billing_Party_ID])
REFERENCES [dbo].[Voucher_Alternate_Billing] ([Contract_Number], [Contract_Billing_Party_ID])
GO
ALTER TABLE [dbo].[Voucher_Alt_Billing_Std_Des] CHECK CONSTRAINT [FK_Voucher_Alternate_Billing1]
GO
