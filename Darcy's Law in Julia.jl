using Statistics
using Printf

N = 10_000 # Running 10,000 simulations

# Darcy's Law — three fixed constants
# A = Cross-sectional area of the rock (m²)
#     In reality, this depends on the size of the well and width of fractures
# dP_dx = Pressure gradient (Pa/m)
#     Negative sign means fluid flows from high pressure to low pressure
#     Just like water flows downhill, fluid flows from high to low pressure zones
# μ = Dynamic viscosity of water — how "thick" the fluid is
#     Water at 20°C has a viscosity of approximately 0.001 Pa·s (standard value)
#     Higher viscosity = slower flow
A = 1000.0
dP_dx = -1000.0
μ = 0.01

# Permeability (k) uncertainty settings:
# The true value of k cannot be directly measured — it can only be estimated
# In geology, k follows a log-normal distribution
# because permeability can vary over many orders of magnitude
# 1e-13 m² is a typical sandstone permeability
# 1.2 is the uncertainty spread — larger value means greater uncertainty
log_k_mean = log(1e-13)
log_k_std = 1.2

# Monte Carlo sampling:
# randn(N) generates 10,000 random numbers from a standard normal distribution
# First line converts them into log-space k values
# Second line uses exp() to convert back to real permeability values
# .+ and .* are Julia's vectorised operations — applied to all 10,000 values at once
log_k_samples = log_k_mean .+ log_k_std .* randn(N)
k_samples = exp.(log_k_samples)

# Apply Darcy's Law: Q = -k × A × (dP/dx) / μ
# Calculates flow rate Q for each of the 10,000 permeability samples
Q_samples = (-k_samples .* A .* dP_dx) ./ μ

# Statistical analysis of results
Q_mean = mean(Q_samples)
Q_p10 = quantile(Q_samples, 0.10)  # P10: 10% of simulations fall below this value (pessimistic case)
Q_p90 = quantile(Q_samples, 0.90)  # P90: 90% of simulations fall below this value (optimistic case)

@printf("Mean flow rate: %.6e m³/s\n", Q_mean)
@printf("Pessimistic P10: %.6e m³/s\n", Q_p10)
@printf("Optimistic P90: %.6e m³/s\n", Q_p90)
# Range factor: even when flow rates are very small,
# the difference between optimistic and pessimistic scenarios can span many times
@printf("Range factor: %.1fx\n", Q_p90/Q_p10)
