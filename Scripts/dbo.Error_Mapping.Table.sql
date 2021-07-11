USE [GISData]
GO
/****** Object:  Table [dbo].[Error_Mapping]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Error_Mapping](
	[Constraint_Name] [varchar](128) NOT NULL,
	[Error_Message] [varchar](255) NULL,
 CONSTRAINT [PK_Error_Mapping] PRIMARY KEY NONCLUSTERED 
(
	[Constraint_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
