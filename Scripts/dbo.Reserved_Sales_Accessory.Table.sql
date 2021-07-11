USE [GISData]
GO
/****** Object:  Table [dbo].[Reserved_Sales_Accessory]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reserved_Sales_Accessory](
	[Confirmation_Number] [int] NOT NULL,
	[Sales_Accessory_ID] [smallint] NOT NULL,
	[Quantity] [smallint] NOT NULL,
 CONSTRAINT [PK_Reserved_Sales_Accessory] PRIMARY KEY CLUSTERED 
(
	[Confirmation_Number] ASC,
	[Sales_Accessory_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reserved_Sales_Accessory] ADD  CONSTRAINT [DF__Reserved___Quant__19169DBB]  DEFAULT (0) FOR [Quantity]
GO
ALTER TABLE [dbo].[Reserved_Sales_Accessory]  WITH NOCHECK ADD  CONSTRAINT [FK_Reservation4] FOREIGN KEY([Confirmation_Number])
REFERENCES [dbo].[Reservation] ([Confirmation_Number])
GO
ALTER TABLE [dbo].[Reserved_Sales_Accessory] CHECK CONSTRAINT [FK_Reservation4]
GO
ALTER TABLE [dbo].[Reserved_Sales_Accessory]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Accessory5] FOREIGN KEY([Sales_Accessory_ID])
REFERENCES [dbo].[Sales_Accessory] ([Sales_Accessory_ID])
GO
ALTER TABLE [dbo].[Reserved_Sales_Accessory] CHECK CONSTRAINT [FK_Sales_Accessory5]
GO
