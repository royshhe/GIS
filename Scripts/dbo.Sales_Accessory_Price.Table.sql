USE [GISData]
GO
/****** Object:  Table [dbo].[Sales_Accessory_Price]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sales_Accessory_Price](
	[Sales_Accessory_ID] [smallint] NOT NULL,
	[Sales_Accessory_Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NULL,
	[Price] [decimal](9, 2) NOT NULL,
	[Last_Changed_By] [varchar](20) NOT NULL,
	[Last_Changed_On] [datetime] NOT NULL,
	[GST_Exempt] [bit] NOT NULL,
	[PST_Exempt] [bit] NOT NULL,
 CONSTRAINT [PK_Sales_Accessory_Price] PRIMARY KEY CLUSTERED 
(
	[Sales_Accessory_ID] ASC,
	[Sales_Accessory_Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Sales_Accessory_Price]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Accessory2] FOREIGN KEY([Sales_Accessory_ID])
REFERENCES [dbo].[Sales_Accessory] ([Sales_Accessory_ID])
GO
ALTER TABLE [dbo].[Sales_Accessory_Price] CHECK CONSTRAINT [FK_Sales_Accessory2]
GO
