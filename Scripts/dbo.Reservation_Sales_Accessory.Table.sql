USE [GISData]
GO
/****** Object:  Table [dbo].[Reservation_Sales_Accessory]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation_Sales_Accessory](
	[Confirmation_Number] [int] NOT NULL,
	[Sales_Accessory_ID] [smallint] NOT NULL,
	[Sold_At_Location_ID] [smallint] NOT NULL,
	[Included_In_Rate] [char](1) NOT NULL,
	[GST_Exempt] [bit] NOT NULL,
	[PST_Exempt] [bit] NOT NULL,
	[Price] [decimal](9, 2) NOT NULL,
	[Quantity] [smallint] NOT NULL
) ON [PRIMARY]
GO
