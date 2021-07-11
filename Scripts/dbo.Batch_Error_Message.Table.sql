USE [GISData]
GO
/****** Object:  Table [dbo].[Batch_Error_Message]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Batch_Error_Message](
	[Error_Number] [int] IDENTITY(1,1) NOT NULL,
	[Error_Level] [char](1) NOT NULL,
	[Message1] [varchar](255) NULL,
	[Message2] [varchar](255) NULL,
	[Message3] [varchar](255) NULL,
	[System_Only] [bit] NOT NULL,
	[Message4] [varchar](255) NULL,
 CONSTRAINT [PK_Batch_Error_Message] PRIMARY KEY CLUSTERED 
(
	[Error_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Batch_Error_Message] ADD  CONSTRAINT [DF_Batch_Error_System_Only]  DEFAULT (0) FOR [System_Only]
GO
