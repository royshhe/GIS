USE [GISData]
GO
/****** Object:  Table [dbo].[Sales_Accessory]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sales_Accessory](
	[Sales_Accessory_ID] [smallint] IDENTITY(100,1) NOT NULL,
	[Unit_Description] [varchar](20) NOT NULL,
	[Sales_Accessory] [varchar](20) NOT NULL,
	[Delete_Flag] [bit] NOT NULL,
	[GL_Revenue_Account] [varchar](32) NOT NULL,
	[Last_Updated_By] [varchar](20) NOT NULL,
	[Last_Updated_On] [datetime] NOT NULL,
	[Sell_On_Contract] [bit] NULL,
 CONSTRAINT [PK_Sales_Accessory] PRIMARY KEY CLUSTERED 
(
	[Sales_Accessory_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UC_Sales_Accessory1] UNIQUE NONCLUSTERED 
(
	[Sales_Accessory] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Sales_Accessory] ADD  CONSTRAINT [DF__Sales_Acc__Delet__660BFB01]  DEFAULT (0) FOR [Delete_Flag]
GO
ALTER TABLE [dbo].[Sales_Accessory] ADD  CONSTRAINT [DF_Sales_Accessory_Sell_On_Contract]  DEFAULT (1) FOR [Sell_On_Contract]
GO
