USE [GISData]
GO
/****** Object:  Table [dbo].[Sales_Accessory_Sale_Payment]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sales_Accessory_Sale_Payment](
	[Sales_Contract_Number] [int] NOT NULL,
	[RBR_Date] [datetime] NOT NULL,
	[Collected_On] [datetime] NOT NULL,
	[Payment_Type] [varchar](20) NOT NULL,
	[Amount] [decimal](9, 2) NOT NULL,
	[Business_Transaction_ID] [int] NOT NULL,
 CONSTRAINT [PK_Sales_Accessory_Sale_Paymnt] PRIMARY KEY CLUSTERED 
(
	[Sales_Contract_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Sales_Accessory_Sale_Payment]  WITH CHECK ADD  CONSTRAINT [FK_Business_Transaction7] FOREIGN KEY([Business_Transaction_ID])
REFERENCES [dbo].[Business_Transaction] ([Business_Transaction_ID])
GO
ALTER TABLE [dbo].[Sales_Accessory_Sale_Payment] CHECK CONSTRAINT [FK_Business_Transaction7]
GO
ALTER TABLE [dbo].[Sales_Accessory_Sale_Payment]  WITH NOCHECK ADD  CONSTRAINT [FK_RBR_Date3] FOREIGN KEY([RBR_Date])
REFERENCES [dbo].[RBR_Date] ([RBR_Date])
GO
ALTER TABLE [dbo].[Sales_Accessory_Sale_Payment] CHECK CONSTRAINT [FK_RBR_Date3]
GO
ALTER TABLE [dbo].[Sales_Accessory_Sale_Payment]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Accesory_Sale_Paymnt2] FOREIGN KEY([Sales_Contract_Number])
REFERENCES [dbo].[Sales_Accessory_Sale_Contract] ([Sales_Contract_Number])
GO
ALTER TABLE [dbo].[Sales_Accessory_Sale_Payment] CHECK CONSTRAINT [FK_Sales_Accesory_Sale_Paymnt2]
GO
