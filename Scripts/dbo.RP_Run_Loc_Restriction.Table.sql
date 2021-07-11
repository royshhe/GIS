USE [GISData]
GO
/****** Object:  Table [dbo].[RP_Run_Loc_Restriction]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RP_Run_Loc_Restriction](
	[Loc_Restriction_ID] [int] IDENTITY(1,1) NOT NULL,
	[User_ID] [char](20) NOT NULL,
	[Location_ID] [int] NOT NULL,
 CONSTRAINT [PK_RP_Run_Loc_Restriction] PRIMARY KEY CLUSTERED 
(
	[Loc_Restriction_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
