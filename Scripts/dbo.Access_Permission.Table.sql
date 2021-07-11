USE [GISData]
GO
/****** Object:  Table [dbo].[Access_Permission]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Access_Permission](
	[User_Group_id] [char](12) NOT NULL,
	[Screen_id] [char](25) NOT NULL,
	[Screen_permission] [char](8) NOT NULL,
	[Change_by] [char](15) NULL,
	[Last_Upd_Datetime] [datetime] NULL,
	[Field_permission] [varchar](255) NULL,
 CONSTRAINT [PK_Access_Permission] PRIMARY KEY CLUSTERED 
(
	[User_Group_id] ASC,
	[Screen_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
