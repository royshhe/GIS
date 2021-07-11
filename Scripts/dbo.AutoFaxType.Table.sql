USE [GISData]
GO
/****** Object:  Table [dbo].[AutoFaxType]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AutoFaxType](
	[control_ID] [int] IDENTITY(1,1) NOT NULL,
	[type_ID] [int] NOT NULL,
	[type_description] [char](100) NULL,
	[last_updated_by] [char](20) NULL,
	[last_updated_on] [datetime] NULL,
	[timestamp] [timestamp] NULL,
 CONSTRAINT [PK_autofaxtype] PRIMARY KEY CLUSTERED 
(
	[type_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
