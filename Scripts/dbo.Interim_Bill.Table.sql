USE [GISData]
GO
/****** Object:  Table [dbo].[Interim_Bill]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Interim_Bill](
	[Contract_Number] [int] NOT NULL,
	[Contract_Billing_Party_ID] [int] NOT NULL,
	[Interim_Bill_Date] [datetime] NOT NULL,
	[Current_KM] [int] NULL,
	[Coverage_Amount] [decimal](9, 2) NULL,
	[Void] [bit] NULL,
 CONSTRAINT [PK_Interim_Bill] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Contract_Billing_Party_ID] ASC,
	[Interim_Bill_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Interim_Bill]  WITH NOCHECK ADD  CONSTRAINT [FK_Direct_Bill_Primary_Billng1] FOREIGN KEY([Contract_Number], [Contract_Billing_Party_ID])
REFERENCES [dbo].[Direct_Bill_Primary_Billing] ([Contract_Number], [Contract_Billing_Party_ID])
GO
ALTER TABLE [dbo].[Interim_Bill] CHECK CONSTRAINT [FK_Direct_Bill_Primary_Billng1]
GO
