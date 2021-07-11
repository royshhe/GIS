USE [GISData]
GO
/****** Object:  Table [dbo].[Contract_Internal_Std_Comment]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contract_Internal_Std_Comment](
	[Standard_Internal_Comment] [varchar](255) NOT NULL,
 CONSTRAINT [PK_Contract_Internal_Std_Comnt] PRIMARY KEY CLUSTERED 
(
	[Standard_Internal_Comment] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
