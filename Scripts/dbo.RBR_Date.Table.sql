USE [GISData]
GO
/****** Object:  Table [dbo].[RBR_Date]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RBR_Date](
	[RBR_Date] [datetime] NOT NULL,
	[Budget_Start_Datetime] [datetime] NULL,
	[Budget_Close_Datetime] [datetime] NULL,
	[Closed_By] [varchar](35) NULL,
	[Date_Generated] [datetime] NOT NULL,
	[Date_GL_Generated] [datetime] NULL,
	[Date_AR_Generated] [datetime] NULL,
	[Export_Failed] [bit] NOT NULL,
	[Date_AMEFT_Submitted] [datetime] NULL,
	[Date_CRTrans_Loaded] [datetime] NULL,
	[Date_IRACS_Submitted] [datetime] NULL,
	[Date_IB_Generated] [datetime] NULL,
	[Date_ITB_Invoice_Generated] [datetime] NULL,
	[Date_FPG_CSR_Incentive_Submitted] [datetime] NULL,
	[Date_APEFT_Submitted] [datetime] NULL,
 CONSTRAINT [PK_RBR_Date] PRIMARY KEY CLUSTERED 
(
	[RBR_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RBR_Date] ADD  CONSTRAINT [DF_RBR_Date_Export_Failed]  DEFAULT (0) FOR [Export_Failed]
GO
