USE [GISData]
GO
/****** Object:  Table [dbo].[Tour_Drop_Off_Charge]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tour_Drop_Off_Charge](
	[ID] [smallint] IDENTITY(1,1) NOT NULL,
	[Pick_Up_Location_ID] [smallint] NOT NULL,
	[Drop_Off_Location_ID] [smallint] NOT NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NULL,
	[Authorized] [bit] NOT NULL,
	[Authorized_Charge] [decimal](7, 2) NULL,
	[Unauthorized_Charge] [decimal](7, 2) NOT NULL,
 CONSTRAINT [PK_Tour_Drop_Off_Charge] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
