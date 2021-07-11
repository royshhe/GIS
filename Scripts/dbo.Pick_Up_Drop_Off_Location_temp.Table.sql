USE [GISData]
GO
/****** Object:  Table [dbo].[Pick_Up_Drop_Off_Location_temp]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pick_Up_Drop_Off_Location_temp](
	[Pick_Up_Location_ID] [smallint] NOT NULL,
	[Drop_Off_Location_ID] [smallint] NOT NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NULL,
	[Authorized] [bit] NOT NULL,
	[Authorized_Charge] [decimal](7, 2) NULL,
	[Unauthorized_Charge] [decimal](7, 2) NOT NULL
) ON [PRIMARY]
GO
