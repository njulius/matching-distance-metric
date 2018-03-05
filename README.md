# Matching Estimators with a general distance metric

Code pertaining to simulations of matching with data-driven selection of the distance measure.

# R versus STATA

Abadie & Imbens provide a matching estimator implementation in STATA (`nnmatch`), but not in R. King et al have provided `MatchIt` in R, but it does not allow custom distance measures in a way conducive to my analysis, so I'm forced to use STATA (where, conveniently, `nnmatch` already accepts arbitrary PD weighting matrices).
