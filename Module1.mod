MODULE Module1
  CONST robtarget pLathe_10:=[[1800,467,1180],[0.498418,-0.501577,-0.498412,-0.501583],[0,1,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];
  CONST robtarget pLathe_20:=[[2035,467,1180],[0.500005,-0.5,-0.499995,-0.5],[0,1,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];
  CONST robtarget pLathe_30:=[[2035,517,1180],[0.500006,-0.5,-0.499994,-0.5],[0,1,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];
  CONST robtarget pHome:=[[600,417,1180.01],[0,0,1,0],[0,0,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];
  CONST robtarget pInConveyor_20:=[[199.998,72,675.086397233],[0,0,1,0],[1,0,1,0],[9E9,9E9,9E9,9E9,9E9,9E9]];
  CONST robtarget pInConveyor_30:=[[199.998,62,425.086397233],[0,0,1,0],[1,0,1,0],[9E9,9E9,9E9,9E9,9E9,9E9]];
  CONST robtarget pInConveyor_40:=[[199.998,72,425.086397233],[0,0,1,0],[1,0,1,0],[9E9,9E9,9E9,9E9,9E9,9E9]];
  CONST robtarget pOutConveyor_10:=[[0,99.991577148,542.063842773],[0,1,0,0],[-2,0,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];
  CONST robtarget pOutConveyor_20:=[[0,99.991577148,342.063842773],[0,1,0,0],[-2,0,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];
  VAR bool bPartInMachine:=FALSE;
  VAR bool bPartInGripper2:=FALSE;

  PROC FetchnFeedMachine()
    SetDO doStartMachine,0;
    WaitDI diMachineRunning,0;
    IF bPartInMachine=FALSE GOTO Feed;
    MoveJ pLathe_10,v1000,z10,toolGrip2\WObj:=wobjLathe;
    MoveL pLathe_30,v200,fine,toolGrip2\WObj:=wobjLathe;
    SetDO doCloseGripper_2,1;
    WaitDI diGripper_2_Closed,1;
    PulseDO doOpenCloseChuck;
    WaitDI diChuckOpened,1;
    bPartInGripper2:=TRUE;
    MoveL pLathe_20,v200,z1,toolGrip2\WObj:=wobjLathe;
    MoveL pLathe_10,v1000,z1,toolGrip2\WObj:=wobjLathe;
    Feed:
    MoveJ pLathe_10,v1000,z10,toolGrip1\WObj:=wobjLathe;
    MoveL pLathe_20,v200,z0,toolGrip1\WObj:=wobjLathe;
    MoveL pLathe_30,v200,fine,toolGrip1\WObj:=wobjLathe;
    PulseDO doOpenCloseChuck;
    WaitDI diChuckCLosed,1;
    SetDO doCloseGripper_1,0;
    WaitDI diGripper_1_Closed,0;
    bPartInMachine:=TRUE;
    MoveL pLathe_10,v200,z0,toolGrip1\WObj:=wobjLathe;
    MoveJ pHome,v2000,fine,toolGrip1\WObj:=wobj0;
    SetDO doStartMachine,1;
    WaitDI diMachineRunning,1;
  ENDPROC

  PROC GetPiece()
    MoveJ pHome,v2000,z10,toolGrip1\WObj:=wobj0;
    MoveJ pInConveyor_20,v2000,z1,toolGrip1\WObj:=wobjInConveyor;
    WaitDI diPartInPickPos,1;
    MoveL pInConveyor_30,v200,fine,toolGrip1\WObj:=wobjInConveyor;
    SetDO doCloseGripper_1,1;
    WaitDI diGripper_1_Closed,1;
    MoveL pInConveyor_40,v200,z0,toolGrip1\WObj:=wobjInConveyor;
    MoveL pInConveyor_20,v200,z0,toolGrip1\WObj:=wobjInConveyor;
    MoveJ pHome,v2000,z50,toolGrip1\WObj:=wobj0;
  ENDPROC

  PROC LeavePiece()
    IF bPartInGripper2=FALSE RETURN ;
    MoveJ pOutConveyor_10,v2000,z0,toolGrip2\WObj:=wobjOutConveuor;
    MoveL pOutConveyor_20,v200,fine,toolGrip2\WObj:=wobjOutConveuor;
    SetDO doCloseGripper_2,0;
    WaitDI diGripper_2_Closed,0;
    MoveL pOutConveyor_10,v200,z0,toolGrip2\WObj:=wobjOutConveuor;
    MoveJ pHome,v2000,z50,toolGrip1\WObj:=wobj0;
  ENDPROC

  PROC main()
    IF diPartInPickPos=0 PulseDO doNewPart;
    WHILE TRUE DO
      GetPiece;
      FetchnFeedMachine;
      LeavePiece;
    ENDWHILE
  ENDPROC

  PROC rAdd_JH()
    !파일 수정/추가 적용 테스트로 루틴 하나 만들어 봤습니다
    !Stop;
  ENDPROC

ENDMODULE
