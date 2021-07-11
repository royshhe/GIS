USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctPVRTExemptFlag]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO



/*
PROCEDURE NAME: GetCtrctPVRTExemptFlag
PURPOSE: To retrieve the PVRT_Exempt flag for a given contract
AUTHOR: Cindy Yee
DATE CREATED: Nov 12, 1999
CALLED BY: InterimBill, HandHeld
REQUIRES:
ENSURES: returns '0' or '1'; if ctrct has no valid VOC record, returns '0' by default
MOD HISTORY:
Name    Date        Comments
-- Handheld and interim billing PVRT exempt
*/
CREATE PROCEDURE [dbo].[GetCtrctPVRTExemptFlag]	--  1679788
	@CtrctNum Varchar(11)
AS
DECLARE	@iCtrctNum Int,
	@sPVRTExemptNum Varchar(15),
	@sPVRTExemptFlag  Varchar(5),
	@sPVRTExempt Varchar(5)

	SELECT	@iCtrctNum = Cast(NULLIF(@CtrctNum,'') as Int),
		
		@sPVRTExempt = '0'	-- default

	-- return the pvrt exempt flag for the vehicle class code that is 
	-- currently checked out;  the currently checked out vehicle class is
	-- defined by the most recently checked out vehicle

	SET ROWCOUNT 1

	--SELECT	@sPVRTExempt = ISNULL(LT.Value, '0') 
	--FROM	Vehicle_On_Contract VOC
	--	JOIN Vehicle V
	--	  ON VOC.Unit_Number = V.Unit_Number
	--	LEFT OUTER JOIN Lookup_Table LT
	--	  ON V.Vehicle_Class_Code = LT.Code
	--	 AND LT.Category = 'PVRT Exempt'
	--WHERE	VOC.Contract_Number = @iCtrctNum
	--AND	VOC.Checked_Out = (	SELECT	MAX(Checked_Out)
	--				FROM	Vehicle_On_Contract VOC
	--				WHERE	VOC.Contract_Number = @iCtrctNum )
					
	-- Roy He; Use Passenger_Vehicle Flag instead				
	SELECT @sPVRTExemptFlag= (Case When VMY.Passenger_Vehicle= 1 Then '0'
							  Else '1'
						 End)
	FROM  dbo.Vehicle_On_Contract AS VOC 
	INNER JOIN dbo.Vehicle AS V 
		ON VOC.Unit_Number = V.Unit_Number 
	INNER JOIN dbo.Vehicle_Model_Year AS VMY 
		ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID				
    WHERE	VOC.Contract_Number = @iCtrctNum
	AND	VOC.Checked_Out = (	SELECT	MAX(Checked_Out)
					FROM	Vehicle_On_Contract VOC
					WHERE	VOC.Contract_Number = @iCtrctNum )     
	Select @sPVRTExemptNum= PVRT_Exempt_Num from Contract WHERE Contract_Number = @iCtrctNum 
	
	if  @sPVRTExemptFlag='1' or (  @sPVRTExemptNum is not null and @sPVRTExemptNum<>'')
		Select @sPVRTExempt='1'

	SET ROWCOUNT 0

	SELECT	@sPVRTExempt

	RETURN @@ROWCOUNT
	





GO
