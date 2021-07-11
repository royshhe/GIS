USE [GISData]
GO
/****** Object:  Table [dbo].[Location_Sales_Accessory]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Location_Sales_Accessory](
	[Sales_Accessory_ID] [smallint] NOT NULL,
	[Location_ID] [smallint] NOT NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NULL,
	[Price] [decimal](9, 2) NULL,
	[Last_Changed_By] [varchar](20) NULL,
	[Last_Changed_On] [datetime] NULL,
 CONSTRAINT [PK_Location_Sales_Accessory] PRIMARY KEY CLUSTERED 
(
	[Sales_Accessory_ID] ASC,
	[Location_ID] ASC,
	[Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Location_Sales_Accessory]  WITH NOCHECK ADD  CONSTRAINT [FK_Location13] FOREIGN KEY([Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Location_Sales_Accessory] CHECK CONSTRAINT [FK_Location13]
GO
ALTER TABLE [dbo].[Location_Sales_Accessory]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Accessory3] FOREIGN KEY([Sales_Accessory_ID])
REFERENCES [dbo].[Sales_Accessory] ([Sales_Accessory_ID])
GO
ALTER TABLE [dbo].[Location_Sales_Accessory] CHECK CONSTRAINT [FK_Sales_Accessory3]
GO
