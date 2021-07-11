USE [GISData]
GO
/****** Object:  Table [dbo].[AutoFaxMsgType]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AutoFaxMsgType](
	[control_id] [int] IDENTITY(1,1) NOT NULL,
	[type_id] [int] NOT NULL,
	[type_description] [char](30) NULL,
 CONSTRAINT [PK_AutoFaxmsgtype] PRIMARY KEY CLUSTERED 
(
	[type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
