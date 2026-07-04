# Monte Carlo Simulation of Darcy Flow in Porous Media
A Julia implementation of Monte Carlo simulation applied to subsurface fluid flow,
inspired by geothermal energy systems

## Background

Darcy's Law describes fluid flow through porous rock:

Q = -k × A × (dP/dx) / μ

In real subsurface systems, rock permeability (k) is highly uncertain.
This simulation quantifies that uncertainty using Monte Carlo methods.

## Results

Running 10,000 simulations with log-normal permeability distribution:
Mean flow rate: 2.046864e-05 m³/s
Pessimistic P10: 2.151672e-06 m³/s
Optimistic P90: 4.651635e-05 m³/s
Range factor: 21.6x
