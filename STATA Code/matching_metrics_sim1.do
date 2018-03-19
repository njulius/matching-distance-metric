// Matching Metric Simulation do file
// 
// This contains essentially a single iteration of the desired Monte-Carlo simulation

. set obs 5000

. set seed 39548 // for reproducibility

// DGP
// x1 ~ N(0,4), x2 ~ N(0,2)
// y = wT + x1 + 0.25x2

. generate x1 = rnormal(0,4)

. generate x2 = rnormal(0,2)

. generate y0 = x1 + 0.25*x2

// WLOG, since the data is randomly generated to begin with, assign treatment to every other observation

. egen w = fill(1 0 1 0)

// generate y = (y0 if w = 0), (y0 + T if w = 1)

. generate y = y0

. replace y = (y0 + 5) if w == 1 // T hardcoded = 5

// call to get AI ate
// teffects nnmatch (y x1 x2) (w), ate metric(ivariance) biasadj(x1 x2)

// generate weighting matrix
// attaches 4 times as much weight to x1 as to x2

. matrix weight = (1,0 \ 0,0.25)

// call to get ate using weight matrix
// teffects nnmatch (y x1 x2) (w), ate metric(matrix weight) biasadj(x1 x2)
