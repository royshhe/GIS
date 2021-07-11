USE [GISData]
GO
/****** Object:  Table [dbo].[Error_Log]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Error_Log](
	[Error_Log_ID] [int] IDENTITY(1,1) NOT NULL,
	[Screen_ID] [varchar](20) NOT NULL,
	[Location] [varchar](25) NOT NULL,
	[User_ID] [varchar](50) NOT NULL,
	[Date] [datetime] NOT NULL,
	[Error_Message] [varchar](255) NOT NULL,
 CONSTRAINT [PK_Error_Log] PRIMARY KEY CLUSTERED 
(
	[Error_Log_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
