USE [GISData]
GO
/****** Object:  Table [dbo].[Sales_Accessory_CrCard_Payment]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sales_Accessory_CrCard_Payment](
	[Sales_Contract_Number] [int] NOT NULL,
	[Credit_Card_Key] [int] NOT NULL,
	[Authorization_Number] [varchar](20) NOT NULL,
	[Swiped_Flag] [bit] NOT NULL,
	[Terminal_ID] [varchar](20) NULL,
	[Trx_Receipt_Ref_Num] [varchar](50) NULL,
	[Trx_ISO_Response_Code] [char](2) NULL,
	[Trx_Remarks] [varchar](90) NULL,
 CONSTRAINT [PK_Sales_Accessory_CrCard_Payt] PRIMARY KEY CLUSTERED 
(
	[Sales_Contract_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Sales_Accessory_CrCard_Payment] ADD  CONSTRAINT [DF_Sales_Acces_Swiped_Flag]  DEFAULT (0) FOR [Swiped_Flag]
GO
ALTER TABLE [dbo].[Sales_Accessory_CrCard_Payment]  WITH CHECK ADD  CONSTRAINT [FK_Credit_Card5] FOREIGN KEY([Credit_Card_Key])
REFERENCES [dbo].[Credit_Card] ([Credit_Card_Key])
GO
ALTER TABLE [dbo].[Sales_Accessory_CrCard_Payment] CHECK CONSTRAINT [FK_Credit_Card5]
GO
ALTER TABLE [dbo].[Sales_Accessory_CrCard_Payment]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Accesory_Sale_Paymnt3] FOREIGN KEY([Sales_Contract_Number])
REFERENCES [dbo].[Sales_Accessory_Sale_Payment] ([Sales_Contract_Number])
GO
ALTER TABLE [dbo].[Sales_Accessory_CrCard_Payment] CHECK CONSTRAINT [FK_Sales_Accesory_Sale_Paymnt3]
GO
ALTER TABLE [dbo].[Sales_Accessory_CrCard_Payment]  WITH CHECK ADD  CONSTRAINT [FK_Terminal4] FOREIGN KEY([Terminal_ID])
REFERENCES [dbo].[Terminal] ([Terminal_ID])
GO
ALTER TABLE [dbo].[Sales_Accessory_CrCard_Payment] CHECK CONSTRAINT [FK_Terminal4]
GO
