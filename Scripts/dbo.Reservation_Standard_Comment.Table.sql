USE [GISData]
GO
/****** Object:  Table [dbo].[Reservation_Standard_Comment]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation_Standard_Comment](
	[Reservation_Comment_ID] [smallint] IDENTITY(1,1) NOT NULL,
	[Reservation_Comment] [varchar](255) NOT NULL,
	[Maestro_Spec_Equip_Code] [char](3) NULL,
	[Maestro_Spec_Equip_Quantity] [smallint] NULL,
 CONSTRAINT [PK_Reservation_Standard_Commnt] PRIMARY KEY CLUSTERED 
(
	[Reservation_Comment_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
