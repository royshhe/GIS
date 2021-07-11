USE [GISData]
GO
/****** Object:  Table [dbo].[Sales_Accessory_Sale_Item]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sales_Accessory_Sale_Item](
	[Sales_Accessory_ID] [smallint] NOT NULL,
	[Location_ID] [smallint] NOT NULL,
	[Valid_From] [datetime] NOT NULL,
	[Sales_Contract_Number] [int] NOT NULL,
	[Sequence_Number] [smallint] NOT NULL,
	[Quantity] [smallint] NOT NULL,
	[Amount] [decimal](9, 2) NOT NULL,
	[GST_Exempt] [bit] NOT NULL,
	[PST_Exempt] [bit] NOT NULL,
	[GST_Amount] [decimal](9, 2) NOT NULL,
	[PST_Amount] [decimal](9, 2) NOT NULL,
	[Business_Transaction_ID] [int] NOT NULL,
 CONSTRAINT [PK_Sales_Accessory_Sale_Item_1] PRIMARY KEY CLUSTERED 
(
	[Sales_Accessory_ID] ASC,
	[Sales_Contract_Number] ASC,
	[Sequence_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Sales_Accessory_Sale_Item] ADD  CONSTRAINT [DF__Sales_Acc__Amoun__78AB64D7]  DEFAULT (0) FOR [Amount]
GO
ALTER TABLE [dbo].[Sales_Accessory_Sale_Item] ADD  CONSTRAINT [DF__Sales_Acc__GST_E__799F8910]  DEFAULT (1) FOR [GST_Exempt]
GO
ALTER TABLE [dbo].[Sales_Accessory_Sale_Item] ADD  CONSTRAINT [DF__Sales_Acc__PST_E__7A93AD49]  DEFAULT (1) FOR [PST_Exempt]
GO
ALTER TABLE [dbo].[Sales_Accessory_Sale_Item]  WITH NOCHECK ADD  CONSTRAINT [FK_Business_Transaction8] FOREIGN KEY([Business_Transaction_ID])
REFERENCES [dbo].[Business_Transaction] ([Business_Transaction_ID])
GO
ALTER TABLE [dbo].[Sales_Accessory_Sale_Item] CHECK CONSTRAINT [FK_Business_Transaction8]
GO
ALTER TABLE [dbo].[Sales_Accessory_Sale_Item]  WITH NOCHECK ADD  CONSTRAINT [FK_Location_Sales_Accessory1] FOREIGN KEY([Sales_Accessory_ID], [Location_ID], [Valid_From])
REFERENCES [dbo].[Location_Sales_Accessory] ([Sales_Accessory_ID], [Location_ID], [Valid_From])
GO
ALTER TABLE [dbo].[Sales_Accessory_Sale_Item] CHECK CONSTRAINT [FK_Location_Sales_Accessory1]
GO
ALTER TABLE [dbo].[Sales_Accessory_Sale_Item]  WITH NOCHECK ADD  CONSTRAINT [FK_Sales_Accessory_Sale_Contract1] FOREIGN KEY([Sales_Contract_Number])
REFERENCES [dbo].[Sales_Accessory_Sale_Contract] ([Sales_Contract_Number])
GO
ALTER TABLE [dbo].[Sales_Accessory_Sale_Item] CHECK CONSTRAINT [FK_Sales_Accessory_Sale_Contract1]
GO
