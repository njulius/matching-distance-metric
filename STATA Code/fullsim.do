// Full MCS of Matching Metric thing
// Nsims = 1000
// Nobs = 1000

postfile buffer aihat aivar njhat njvar aibhat aibvar njbhat njbvar using output, replace

forvalues i=1/20000 {

// Each loop here is a simulation

	// Generate Data
		quietly drop _all
		quietly set obs 1000
		quietly generate x1 = rnormal(0,4)
		quietly generate x2 = rnormal(0,2)
		quietly generate y0 = x1 + 0.25*x2
		quietly egen w = fill(1 0 1 0)
		quietly generate y = y0
		quietly replace y = (y0 + 5) if w == 1

	// Data is now generated.

	// Perform AI Matching: Inverse Variance, No Bias Correct
		quietly teffects nnmatch (y x1 x2) (w), ate metric(ivariance)
		matrix A = e(b) 
		scalar aihat = A[1,1]
		matrix B = e(V)	
		scalar aivar = B[1,1]

	// Perform AI Matching: Constructed Weight Matrix, No Bias Correct
		matrix weight = (1,0 \ 0,0.25)
		quietly teffects nnmatch (y x1 x2) (w), ate metric(matrix weight)
		matrix C = e(b) 
		scalar njhat = C[1,1]
		matrix D = e(V) 
		scalar njvar = D[1,1]

	// Perform AI Matching: Inverse Variance, Bias Correct
		quietly teffects nnmatch (y x1 x2) (w), ate metric(ivariance) biasadj(x1 x2)
		matrix E = e(b)
		scalar aibhat = E[1,1]
		matrix F = e(V)
		scalar aibvar = F[1,1]

	// Perform AI Matching: Constructed Weight Matrix, Bias Correct
		quietly teffects nnmatch (y x1 x2) (w), ate metric(matrix weight) biasadj(x1 x2)
		matrix G = e(b)
		scalar njbhat = G[1,1]
		matrix H = e(V)
		scalar njbvar = H[1,1]

	// Need to make an output container that has all the scalars from the matrices above.

	post buffer (aihat) (aivar) (njhat) (njvar) (aibhat) (aibvar) (njbhat) (njbvar)

}

postclose buffer

use output, clear

summarize
