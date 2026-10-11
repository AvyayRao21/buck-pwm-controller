# Contributing

This is a solo portfolio project by **Avyay Rao**. It is not set up to take
pull requests. This file records how the work was produced.

## Toolchain

| Tool | Version | Used for |
|---|---|---|
| Icarus Verilog | 0.9.7 | RTL simulation |
| GTKWave | bundled with the Icarus Verilog installer | waveform viewing |
| Yosys | 0.69 | synthesis and cell counts |
| LTspice | 26.0.1 | power-stage simulation |
| Microsoft Excel | | plots and derived tables |

## How AI was used

Claude was used for two things only:

* **Design review.** A partner to question the design and the analysis.
* **The testbench.** `Verilog/tb_pwm_generator.V` was written by Claude.

The RTL, the resolution study, the power-stage design, the simulations and the
loss model are the author's own work. The README's
[AI section](README.md#ai-to-accelerate-workflow) describes how the
AI-assisted output was checked.

Repository scaffolding was done with Claude Code: `.gitignore`, `LICENSE`,
this file, `DISCLAIMER.md`, and fixes to paths, links and formatting in the
README.
