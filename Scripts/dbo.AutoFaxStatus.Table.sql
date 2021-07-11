USE [GISData]
GO
/****** Object:  Table [dbo].[AutoFaxStatus]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AutoFaxStatus](
	[control_id] [int] NOT NULL,
	[ref_control_id] [int] NOT NULL
) ON [PRIMARY]
GO
