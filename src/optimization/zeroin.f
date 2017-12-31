      REAL FUNCTION ZEROIN(AX,BX,F,TOL)
      REAL AX, BX, F, TOL
C
C     A ZERO OF THE FUNCTION F(X) IS COMPUTED IN THE INTERVAL AX,BX
C
C  INPUT..
C
C  AX    LEFT ENDPOINT OF INITIAL INTERVAL
C  BX    RIGHT ENDPOINT OF INITIAL INTERVAL
C  F     FUNCTION SUBPROGRAM WHICH EVALUATES F(X) FOR ANY X IN
C        THE INTERVAL  AX,BX
C  TOL   DESIRED LENGTH OF THE INTERVAL OF UNCERTAINTY OF THE 
C        FINAL RESULT ( .GE. 0.0)
C
C
C  OUTPUT..
C
C  ZEROIN ABCISSA APPROXIMATING A ZERO OF F IN THE INTERVAL AX,BX
C
C
C     IT IS ASSUMED THAT F(AX) AND F(BX) HAVE OPPOSITE SIGNS
C  WITHOUT A CHECK. ZEROIN RETURNS A ZERO X IN THE GIVEN INTERVAL
C  AX,BX TO WITHIN A TOLERANCE 4*MACHEPS*ABS(X) + TOL, WHERE MACHEPS
C  IS THE RELATIVE MACHINE PRECISION.
C     THIS FUNCTION SUBPROGRAM IS A SLIGHTLY MODIFIED TRANSLATION OF
C  THE ALGOL 60 PROCEDURE ZERO GIVEN IN RICHARD BRENT, ALGORITHMS FOR
C  MINIMIZATION WITHOUT DERIVATIVES, PRENTICE - HALL, INC. (1973).
C
C
      REAL A,B,C,D,E,EPS,FA,FB,FC,TOL1,XM,P,Q,R,S
C
C  COMPUTE EPS, THE RELATIVE MACHINE PRECISION
C
      EPS = 1.0
   10 EPS = EPS/2.0
      TOL1 = 1.0 + EPS
      IF (TOL1 .GT. 1.0) GO TO 10
C
C  INITIALIZATION
C
      A = AX
      B = BX
      FA = F(A)
      FB = F(B)
C
C  BEGIN STEP
C
   20 C = A
      FC = FA
      D = B - A
      E = D
   30 IF (ABS(FC) .GE. ABS(FB)) GO TO 40
      A = B
      B = C
      C = A
      FA = FB
      FB = FC
      FC = FA
C
C  CONVERGENCE TEST
C
   40 TOL1 = 2.0*EPS*ABS(B) + 0.5*TOL
      XM = .5*(C - B)
      IF (ABS(XM) .LE. TOL1) GO TO 90
      IF (FB .EQ. 0.0) GO TO 90
C
C  IS BISECTION NECESSARY
C
      IF (ABS(E) .LT. TOL1) GO TO 70
      IF (ABS(FA) .LE. ABS(FB)) GO TO 70
C
C  IS QUADRATIC INTERPOLATION POSSIBLE
C
      IF (A .NE. C) GO TO 50
C
C  LINEAR INTERPOLATION
C
      S = FB/FA
      P = 2.0*XM*S
      Q = 1.0 - S
      GO TO 60
C
C  INVERSE QUADRATIC INTERPOLATION
C
   50 Q = FA/FC
      R = FB/FC
      S = FB/FA
      P = S*(2.0*XM*Q*(Q - R) - (B - A)*(R - 1.0))
      Q = (Q - 1.0)*(R - 1.0)*(S - 1.0)
C
C  ADJUST SIGNS
C
   60 IF (P .GT. 0.0) Q = -Q
      P = ABS(P)
C
C  IS INTERPOLATION ACCEPTABLE
C
      IF ((2.0*P) .GE. (3.0*XM*Q - ABS(TOL1*Q))) GO TO 70
      IF (P .GE. ABS(0.5*E*Q)) GO TO 70
      E = D
      D = P/Q
      GO TO 80
C
C  BISECTION
C
   70 D = XM
      E = D
C
C  COMPLETE STEP
C
   80 A = B
      FA = FB
      IF (ABS(D) .GT. TOL1) B = B + D
      IF (ABS(D) .LE. TOL1) B = B + SIGN(TOL1,XM)
      FB = F(B)
      IF ((FB*(FC/ABS(FC))) .GT. 0.0) GO TO 20
      GO TO 30
C
C  DONE
C
   90 ZEROIN = B
      RETURN
      END