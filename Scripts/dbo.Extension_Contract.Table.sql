USE [GISData]
GO
/****** Object:  Table [dbo].[Extension_Contract]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Extension_Contract](
	[Contract_Number] [nchar](10) NOT NULL,
 CONSTRAINT [PK_Extension_Contract] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
