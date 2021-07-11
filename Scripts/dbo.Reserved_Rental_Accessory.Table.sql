USE [GISData]
GO
/****** Object:  Table [dbo].[Reserved_Rental_Accessory]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reserved_Rental_Accessory](
	[Confirmation_Number] [int] NOT NULL,
	[Optional_Extra_ID] [smallint] NOT NULL,
	[Quantity] [smallint] NOT NULL,
	[Coupon] [varchar](25) NULL,
	[Description] [varchar](25) NULL,
	[Flat_Rate] [decimal](9, 2) NULL,
 CONSTRAINT [PK_Reserved_Rental_Accessory] PRIMARY KEY CLUSTERED 
(
	[Confirmation_Number] ASC,
	[Optional_Extra_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reserved_Rental_Accessory] ADD  CONSTRAINT [DF__Reserved___Quant__55D59338]  DEFAULT (0) FOR [Quantity]
GO
ALTER TABLE [dbo].[Reserved_Rental_Accessory]  WITH CHECK ADD  CONSTRAINT [FK_Optional_Extra07] FOREIGN KEY([Optional_Extra_ID])
REFERENCES [dbo].[Optional_Extra] ([Optional_Extra_ID])
GO
ALTER TABLE [dbo].[Reserved_Rental_Accessory] CHECK CONSTRAINT [FK_Optional_Extra07]
GO
ALTER TABLE [dbo].[Reserved_Rental_Accessory]  WITH NOCHECK ADD  CONSTRAINT [FK_Reservation6] FOREIGN KEY([Confirmation_Number])
REFERENCES [dbo].[Reservation] ([Confirmation_Number])
GO
ALTER TABLE [dbo].[Reserved_Rental_Accessory] CHECK CONSTRAINT [FK_Reservation6]
GO
