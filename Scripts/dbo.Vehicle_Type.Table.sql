USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle_Type]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle_Type](
	[Vehicle_Type_ID] [varchar](18) NOT NULL,
	[GL_Discount_Account] [varchar](32) NOT NULL,
 CONSTRAINT [PK_Vehicle_Type] PRIMARY KEY CLUSTERED 
(
	[Vehicle_Type_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vehicle_Type] ADD  CONSTRAINT [DF_Vehicle_Typ_GL_Discount]  DEFAULT ('Dummy Discount Account') FOR [GL_Discount_Account]
GO
