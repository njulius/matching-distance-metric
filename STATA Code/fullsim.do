// Full MCS of Matching Metric thing
// Nsims = 1000
// Nobs = 1000

// Need a data collection here, you'll need to figure that out
// https://blog.stata.com/2015/10/06/monte-carlo-simulations-using-stata/
// postfile buffer mhat using mcs, replace (only saves one var per simulation though)

forvalues i=1/1000 {

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
		teffects nnmatch (y x1 x2) (w), ate metric(ivariance)
		matrix A = e(b) \\ A[1,1] contains That
		matrix B = e(V)	\\ B[1,1] contains var of That

	// Perform AI Matching: Constructed Weight Matrix, No Bias Correct
		matrix weight = (1,0 \ 0,0.25)
		teffects nnmatch (y x1 x2) (w), ate metric(matrix weight)
		matrix C = e(b) \\ C[1,1] contains That
		matrix D = e(V) \\ D[1,1] contains var of That

	// Perform AI Matching: Inverse Variance, Bias Correct
		teffects nnmatch (y x1 x2) (w), ate metric(ivariance) biasadj(x1 x2)
		matrix E = e(b)
		matrix F = e(V)

	// Perform AI Matching: Constructed Weight Matrix, Bias Correct
		teffects nnmatch (y x1 x2) (w), ate metric(matrix weight) biasadj(x1 x2)
		matrix G = e(b)
		matrix H = e(V)

	// Need to make an output container that has all the scalars from the matrices above.
		




}

// Data collection and output has to go here
