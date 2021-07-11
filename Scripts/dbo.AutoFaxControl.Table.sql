USE [GISData]
GO
/****** Object:  Table [dbo].[AutoFaxControl]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AutoFaxControl](
	[control_ID] [int] NOT NULL,
	[control_description] [char](50) NOT NULL,
	[control_value] [char](100) NOT NULL,
	[control_active] [char](1) NOT NULL,
	[last_updated_on] [datetime] NOT NULL,
	[last_updated_by] [char](20) NOT NULL,
	[timestamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_autofaxcontrol] PRIMARY KEY CLUSTERED 
(
	[control_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
