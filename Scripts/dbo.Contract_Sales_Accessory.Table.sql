USE [GISData]
GO
/****** Object:  Table [dbo].[Contract_Sales_Accessory]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contract_Sales_Accessory](
	[Contract_Number] [int] NOT NULL,
	[Sales_Accessory_ID] [smallint] NOT NULL,
	[Sequence] [smallint] NOT NULL,
	[Sold_At_Location_ID] [smallint] NOT NULL,
	[Included_In_Rate] [char](1) NOT NULL,
	[GST_Exempt] [bit] NOT NULL,
	[PST_Exempt] [bit] NOT NULL,
	[Price] [decimal](9, 2) NOT NULL,
	[Quantity] [smallint] NOT NULL,
 CONSTRAINT [PK_Contract_Sales_Accesory] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Sales_Accessory_ID] ASC,
	[Sequence] ASC,
	[Included_In_Rate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contract_Sales_Accessory] ADD  CONSTRAINT [DF_Contract_Sales_Accessory_Sequence]  DEFAULT (0) FOR [Sequence]
GO
ALTER TABLE [dbo].[Contract_Sales_Accessory] ADD  CONSTRAINT [DF__Contract___Quant__6148113B]  DEFAULT (1) FOR [Quantity]
GO
ALTER TABLE [dbo].[Contract_Sales_Accessory]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract07] FOREIGN KEY([Contract_Number])
REFERENCES [dbo].[Contract] ([Contract_Number])
GO
ALTER TABLE [dbo].[Contract_Sales_Accessory] CHECK CONSTRAINT [FK_Contract07]
GO
ALTER TABLE [dbo].[Contract_Sales_Accessory]  WITH NOCHECK ADD  CONSTRAINT [FK_Sales_Accessory6] FOREIGN KEY([Sales_Accessory_ID])
REFERENCES [dbo].[Sales_Accessory] ([Sales_Accessory_ID])
GO
ALTER TABLE [dbo].[Contract_Sales_Accessory] CHECK CONSTRAINT [FK_Sales_Accessory6]
GO
