USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle_Licence]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle_Licence](
	[Licence_Plate_Number] [varchar](20) NOT NULL,
	[Licencing_Province_State] [varchar](20) NOT NULL,
	[Delete_Flag] [bit] NOT NULL,
	[Created_On] [datetime] NULL,
	[Last_Change_By] [varchar](20) NULL,
	[Last_Change_On] [datetime] NULL,
 CONSTRAINT [PK_Vehicle_Licence] PRIMARY KEY CLUSTERED 
(
	[Licence_Plate_Number] ASC,
	[Licencing_Province_State] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Vehicle_Licence] ADD  CONSTRAINT [DF__Vehicle_L__Delet__569F9A3F]  DEFAULT (0) FOR [Delete_Flag]
GO
