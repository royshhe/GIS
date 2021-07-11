USE [GISData]
GO
/****** Object:  Table [dbo].[Sales_Accessory_Cash_Payment]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sales_Accessory_Cash_Payment](
	[Sales_Contract_Number] [int] NOT NULL,
	[Currency_ID] [tinyint] NOT NULL,
	[Cash_Payment_Type] [varchar](10) NOT NULL,
	[Foreign_money_Collected] [decimal](9, 2) NOT NULL,
	[Exchange_Rate] [decimal](9, 4) NULL,
	[Identification_Number] [varchar](20) NULL,
	[Authorization_Number] [varchar](20) NULL,
	[Swiped_Flag] [bit] NULL,
	[Terminal_ID] [varchar](20) NULL,
	[Trx_Receipt_Ref_Num] [varchar](20) NULL,
	[Trx_ISO_Response_Code] [varchar](2) NULL,
	[Trx_Remarks] [varchar](90) NULL,
 CONSTRAINT [PK_Sales_Accessory_Cash_Paymnt] PRIMARY KEY CLUSTERED 
(
	[Sales_Contract_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Sales_Accessory_Cash_Payment]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Accesory_Sale_Paymnt1] FOREIGN KEY([Sales_Contract_Number])
REFERENCES [dbo].[Sales_Accessory_Sale_Payment] ([Sales_Contract_Number])
GO
ALTER TABLE [dbo].[Sales_Accessory_Cash_Payment] CHECK CONSTRAINT [FK_Sales_Accesory_Sale_Paymnt1]
GO
