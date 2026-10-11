# Disclaimer

All results in this repository come from simulation only: Icarus Verilog for
the RTL, Yosys for synthesis, and LTspice for the power stage. No physical
hardware was built, and nothing here was measured on a bench. Where the
README says "measured", it means measured in simulation.

The models are idealised in the ways the README's
[out-of-scope section](README.md#what-this-project-doesnt-cover-out-of-scope)
describes:

* The power switch is a voltage-controlled switch with a fixed on-resistance,
  not a real transistor. It has no gate charge, no switching transition
  losses and no dead time, so the efficiency figures are optimistic.
* The converter is asynchronous (a freewheel diode, not a second switch) and
  runs open loop, with no regulation.
* The load is a fixed resistor. No load step or transient response was
  simulated.
* Yosys cell counts are generic and not tied to any real process. They show
  relative scaling between resolutions only, with no real area or timing.

Nothing in this repository is validated for production use. It is provided
as-is, without warranty of any kind. See [LICENSE](LICENSE).
