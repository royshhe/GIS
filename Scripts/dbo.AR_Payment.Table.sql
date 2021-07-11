USE [GISData]
GO
/****** Object:  Table [dbo].[AR_Payment]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AR_Payment](
	[Contract_Number] [int] NOT NULL,
	[Sequence] [smallint] NOT NULL,
	[Contract_Billing_Party_ID] [int] NOT NULL,
	[Interim_Bill_Date] [datetime] NULL,
 CONSTRAINT [PK_AR_Payment] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Sequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AR_Payment]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract_Billing_Party5] FOREIGN KEY([Contract_Number], [Contract_Billing_Party_ID])
REFERENCES [dbo].[Contract_Billing_Party] ([Contract_Number], [Contract_Billing_Party_ID])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[AR_Payment] NOCHECK CONSTRAINT [FK_Contract_Billing_Party5]
GO
ALTER TABLE [dbo].[AR_Payment]  WITH CHECK ADD  CONSTRAINT [FK_Interim_Bill1] FOREIGN KEY([Contract_Number], [Contract_Billing_Party_ID], [Interim_Bill_Date])
REFERENCES [dbo].[Interim_Bill] ([Contract_Number], [Contract_Billing_Party_ID], [Interim_Bill_Date])
GO
ALTER TABLE [dbo].[AR_Payment] CHECK CONSTRAINT [FK_Interim_Bill1]
GO
