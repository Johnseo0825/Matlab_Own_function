/* Produced by CVXGEN, 2016-06-02 03:30:17 -0400.  */
/* CVXGEN is Copyright (C) 2006-2012 Jacob Mattingley, jem@cvxgen.com. */
/* The code in this file is Copyright (C) 2006-2012 Jacob Mattingley. */
/* CVXGEN, or solvers produced by CVXGEN, cannot be used for commercial */
/* applications without prior written permission from Jacob Mattingley. */

/* Filename: matrix_support.c. */
/* Description: Support functions for matrix multiplication and vector filling. */
#include "solver.h"
void multbymA(double *lhs, double *rhs) {
  lhs[0] = -rhs[0]*(params.A[0])-rhs[1]*(params.A[3])-rhs[2]*(params.A[6])-rhs[3]*(params.A[9])-rhs[4]*(params.A[12])-rhs[5]*(params.A[15])-rhs[6]*(params.A[18])-rhs[7]*(params.A[21])-rhs[8]*(params.A[24])-rhs[9]*(params.A[27]);
  lhs[1] = -rhs[0]*(params.A[1])-rhs[1]*(params.A[4])-rhs[2]*(params.A[7])-rhs[3]*(params.A[10])-rhs[4]*(params.A[13])-rhs[5]*(params.A[16])-rhs[6]*(params.A[19])-rhs[7]*(params.A[22])-rhs[8]*(params.A[25])-rhs[9]*(params.A[28]);
  lhs[2] = -rhs[0]*(params.A[2])-rhs[1]*(params.A[5])-rhs[2]*(params.A[8])-rhs[3]*(params.A[11])-rhs[4]*(params.A[14])-rhs[5]*(params.A[17])-rhs[6]*(params.A[20])-rhs[7]*(params.A[23])-rhs[8]*(params.A[26])-rhs[9]*(params.A[29]);
}
void multbymAT(double *lhs, double *rhs) {
  lhs[0] = -rhs[0]*(params.A[0])-rhs[1]*(params.A[1])-rhs[2]*(params.A[2]);
  lhs[1] = -rhs[0]*(params.A[3])-rhs[1]*(params.A[4])-rhs[2]*(params.A[5]);
  lhs[2] = -rhs[0]*(params.A[6])-rhs[1]*(params.A[7])-rhs[2]*(params.A[8]);
  lhs[3] = -rhs[0]*(params.A[9])-rhs[1]*(params.A[10])-rhs[2]*(params.A[11]);
  lhs[4] = -rhs[0]*(params.A[12])-rhs[1]*(params.A[13])-rhs[2]*(params.A[14]);
  lhs[5] = -rhs[0]*(params.A[15])-rhs[1]*(params.A[16])-rhs[2]*(params.A[17]);
  lhs[6] = -rhs[0]*(params.A[18])-rhs[1]*(params.A[19])-rhs[2]*(params.A[20]);
  lhs[7] = -rhs[0]*(params.A[21])-rhs[1]*(params.A[22])-rhs[2]*(params.A[23]);
  lhs[8] = -rhs[0]*(params.A[24])-rhs[1]*(params.A[25])-rhs[2]*(params.A[26]);
  lhs[9] = -rhs[0]*(params.A[27])-rhs[1]*(params.A[28])-rhs[2]*(params.A[29]);
}
void multbymG(double *lhs, double *rhs) {
  lhs[0] = -rhs[0]*(-1);
  lhs[1] = -rhs[1]*(-1);
  lhs[2] = -rhs[2]*(-1);
  lhs[3] = -rhs[3]*(-1);
  lhs[4] = -rhs[4]*(-1);
  lhs[5] = -rhs[5]*(-1);
  lhs[6] = -rhs[6]*(-1);
  lhs[7] = -rhs[7]*(-1);
  lhs[8] = -rhs[8]*(-1);
  lhs[9] = -rhs[9]*(-1);
  lhs[10] = -rhs[0]*(1);
  lhs[11] = -rhs[1]*(1);
  lhs[12] = -rhs[2]*(1);
  lhs[13] = -rhs[3]*(1);
  lhs[14] = -rhs[4]*(1);
  lhs[15] = -rhs[5]*(1);
  lhs[16] = -rhs[6]*(1);
  lhs[17] = -rhs[7]*(1);
  lhs[18] = -rhs[8]*(1);
  lhs[19] = -rhs[9]*(1);
}
void multbymGT(double *lhs, double *rhs) {
  lhs[0] = -rhs[0]*(-1)-rhs[10]*(1);
  lhs[1] = -rhs[1]*(-1)-rhs[11]*(1);
  lhs[2] = -rhs[2]*(-1)-rhs[12]*(1);
  lhs[3] = -rhs[3]*(-1)-rhs[13]*(1);
  lhs[4] = -rhs[4]*(-1)-rhs[14]*(1);
  lhs[5] = -rhs[5]*(-1)-rhs[15]*(1);
  lhs[6] = -rhs[6]*(-1)-rhs[16]*(1);
  lhs[7] = -rhs[7]*(-1)-rhs[17]*(1);
  lhs[8] = -rhs[8]*(-1)-rhs[18]*(1);
  lhs[9] = -rhs[9]*(-1)-rhs[19]*(1);
}
void multbyP(double *lhs, double *rhs) {
  /* TODO use the fact that P is symmetric? */
  /* TODO check doubling / half factor etc. */
  lhs[0] = rhs[0]*(2*params.Q[0])+rhs[1]*(2*params.Q[10])+rhs[2]*(2*params.Q[20])+rhs[3]*(2*params.Q[30])+rhs[4]*(2*params.Q[40])+rhs[5]*(2*params.Q[50])+rhs[6]*(2*params.Q[60])+rhs[7]*(2*params.Q[70])+rhs[8]*(2*params.Q[80])+rhs[9]*(2*params.Q[90]);
  lhs[1] = rhs[0]*(2*params.Q[1])+rhs[1]*(2*params.Q[11])+rhs[2]*(2*params.Q[21])+rhs[3]*(2*params.Q[31])+rhs[4]*(2*params.Q[41])+rhs[5]*(2*params.Q[51])+rhs[6]*(2*params.Q[61])+rhs[7]*(2*params.Q[71])+rhs[8]*(2*params.Q[81])+rhs[9]*(2*params.Q[91]);
  lhs[2] = rhs[0]*(2*params.Q[2])+rhs[1]*(2*params.Q[12])+rhs[2]*(2*params.Q[22])+rhs[3]*(2*params.Q[32])+rhs[4]*(2*params.Q[42])+rhs[5]*(2*params.Q[52])+rhs[6]*(2*params.Q[62])+rhs[7]*(2*params.Q[72])+rhs[8]*(2*params.Q[82])+rhs[9]*(2*params.Q[92]);
  lhs[3] = rhs[0]*(2*params.Q[3])+rhs[1]*(2*params.Q[13])+rhs[2]*(2*params.Q[23])+rhs[3]*(2*params.Q[33])+rhs[4]*(2*params.Q[43])+rhs[5]*(2*params.Q[53])+rhs[6]*(2*params.Q[63])+rhs[7]*(2*params.Q[73])+rhs[8]*(2*params.Q[83])+rhs[9]*(2*params.Q[93]);
  lhs[4] = rhs[0]*(2*params.Q[4])+rhs[1]*(2*params.Q[14])+rhs[2]*(2*params.Q[24])+rhs[3]*(2*params.Q[34])+rhs[4]*(2*params.Q[44])+rhs[5]*(2*params.Q[54])+rhs[6]*(2*params.Q[64])+rhs[7]*(2*params.Q[74])+rhs[8]*(2*params.Q[84])+rhs[9]*(2*params.Q[94]);
  lhs[5] = rhs[0]*(2*params.Q[5])+rhs[1]*(2*params.Q[15])+rhs[2]*(2*params.Q[25])+rhs[3]*(2*params.Q[35])+rhs[4]*(2*params.Q[45])+rhs[5]*(2*params.Q[55])+rhs[6]*(2*params.Q[65])+rhs[7]*(2*params.Q[75])+rhs[8]*(2*params.Q[85])+rhs[9]*(2*params.Q[95]);
  lhs[6] = rhs[0]*(2*params.Q[6])+rhs[1]*(2*params.Q[16])+rhs[2]*(2*params.Q[26])+rhs[3]*(2*params.Q[36])+rhs[4]*(2*params.Q[46])+rhs[5]*(2*params.Q[56])+rhs[6]*(2*params.Q[66])+rhs[7]*(2*params.Q[76])+rhs[8]*(2*params.Q[86])+rhs[9]*(2*params.Q[96]);
  lhs[7] = rhs[0]*(2*params.Q[7])+rhs[1]*(2*params.Q[17])+rhs[2]*(2*params.Q[27])+rhs[3]*(2*params.Q[37])+rhs[4]*(2*params.Q[47])+rhs[5]*(2*params.Q[57])+rhs[6]*(2*params.Q[67])+rhs[7]*(2*params.Q[77])+rhs[8]*(2*params.Q[87])+rhs[9]*(2*params.Q[97]);
  lhs[8] = rhs[0]*(2*params.Q[8])+rhs[1]*(2*params.Q[18])+rhs[2]*(2*params.Q[28])+rhs[3]*(2*params.Q[38])+rhs[4]*(2*params.Q[48])+rhs[5]*(2*params.Q[58])+rhs[6]*(2*params.Q[68])+rhs[7]*(2*params.Q[78])+rhs[8]*(2*params.Q[88])+rhs[9]*(2*params.Q[98]);
  lhs[9] = rhs[0]*(2*params.Q[9])+rhs[1]*(2*params.Q[19])+rhs[2]*(2*params.Q[29])+rhs[3]*(2*params.Q[39])+rhs[4]*(2*params.Q[49])+rhs[5]*(2*params.Q[59])+rhs[6]*(2*params.Q[69])+rhs[7]*(2*params.Q[79])+rhs[8]*(2*params.Q[89])+rhs[9]*(2*params.Q[99]);
}
void fillq(void) {
  work.q[0] = params.c[0];
  work.q[1] = params.c[1];
  work.q[2] = params.c[2];
  work.q[3] = params.c[3];
  work.q[4] = params.c[4];
  work.q[5] = params.c[5];
  work.q[6] = params.c[6];
  work.q[7] = params.c[7];
  work.q[8] = params.c[8];
  work.q[9] = params.c[9];
}
void fillh(void) {
  work.h[0] = 0;
  work.h[1] = 0;
  work.h[2] = 0;
  work.h[3] = 0;
  work.h[4] = 0;
  work.h[5] = 0;
  work.h[6] = 0;
  work.h[7] = 0;
  work.h[8] = 0;
  work.h[9] = 0;
  work.h[10] = 1;
  work.h[11] = 1;
  work.h[12] = 1;
  work.h[13] = 1;
  work.h[14] = 1;
  work.h[15] = 1;
  work.h[16] = 1;
  work.h[17] = 1;
  work.h[18] = 1;
  work.h[19] = 1;
}
void fillb(void) {
  work.b[0] = params.b[0];
  work.b[1] = params.b[1];
  work.b[2] = params.b[2];
}
void pre_ops(void) {
}
