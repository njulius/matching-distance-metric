# dgpOne

# y = w*t + x_1 + 0.5x_2 + 0.25x_3
# x_i ~ N(0,1) for all i

dgpOne <- function(n1, n0, t) {
  # n1 and n0 specify the number of treated and control units respectively
  # t specifies the treatment effect
  
  n <- n1 + n0
  ratio <- n1/n0
  
  # Generate n controls
  x1 <- rnorm(n, mean = 0, sd = 1)
  x2 <- rnorm(n, mean = 0, sd = 1)
  x3 <- rnorm(n, mean = 0, sd = 1)
  
  y <- x1 + (0.5)*x2 + (0.25)*x3
  
  # Duplicate the control outcomes for everything so they're saved
  # even when we assign treatments
  
  u0 <- y
  
  # Select n1 random indexes to receive treatment
  
  indices <- seq(from = 1, to = n, by = 1)
  
  treated <- sample(indices, size = n1, replace = FALSE)
  
  # Assign treatment to the selected indices
  
  w <- rep(0, times = n)
  
  w[treated] <- 1
  
  # Generate and save conditional treated mean for every unit
  
  u1 <- t + x1 + (0.5)*x2 + (0.25)*x3
  
  # Set y equal to u1 for the treated observations
  
  y[treated] <- u1[treated]
  
  # Bind output
  
  out <- cbind(y, w, x1, x2, x3, u0, u1)
  
  return(out)
  
  # Sanity Check
  
  # as.logical(out[,2]) == (out[,1] == out[,6])
  # should return FALSE in every cell if things worked right

}
