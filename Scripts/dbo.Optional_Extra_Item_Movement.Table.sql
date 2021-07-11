USE [GISData]
GO
/****** Object:  Table [dbo].[Optional_Extra_Item_Movement]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Optional_Extra_Item_Movement](
	[Optional_Extra_ID] [int] NOT NULL,
	[Unit_Number] [varchar](12) NOT NULL,
	[Movement_In] [datetime] NULL,
	[Movement_Type] [varchar](25) NOT NULL,
	[Sending_Location_ID] [smallint] NOT NULL,
	[Movement_Out] [datetime] NOT NULL,
	[Receiving_Location_ID] [smallint] NULL,
	[Moved_By] [varchar](30) NOT NULL,
	[Remarks_Out] [varchar](255) NULL,
	[Remarks_In] [varchar](255) NULL,
 CONSTRAINT [PK_Optional_Exra_Item_Movement] PRIMARY KEY CLUSTERED 
(
	[Optional_Extra_ID] ASC,
	[Unit_Number] ASC,
	[Movement_Out] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
