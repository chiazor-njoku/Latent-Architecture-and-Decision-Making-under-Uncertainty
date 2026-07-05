# Decision-Making Under Uncertainty

## Framework

This repository serves as a record of independent work to formalize a structural theory, proposing that consistent individual variations in the weight given to context-invariant representations (as a sufficiency standard for action under uncertainty) form a latent architectural feature that systematically influences decision outcomes.

This argument concerns an individual’s consistent standard for recognizing when enough representational structure has been constructed to take action, rather than the ongoing, real-time handling and accumulation of evidence.

## Method

The repository serves as an ongoing record of a formalise → simulate sequence, it, as such, does not contain completed empirical work. Projects here are at different stages of development. Projects in this repository are components of a larger hypothesis.

## Repository Content

### Project 1: The Impact of Coherence-Destabilization and Error-Introduction on Confidence

#### Current status: experimental simulation / viability test.

This simulation investigates the effects of representational coherence-destabilization and error-introduction on confidence. There are two manipulation methods: (1) High signal-to-noise ratio of evidence strength, while coherence is preserved. (2) Conflict introduction to representation coherence, thereby disrupting internal coherence. This simulation also examines whether these differences in confidence costs vary among individuals.

### Motivation:

Standard models of confidence typically treat uncertainty as a unitary construct. They also conceptualise confidence as a function of post-decisional accuracy accummulation. However, in many cognitive settings, equivalent behavioural accuracy can arise from qualitatively different generative mechanisms. 

### Prediction: 
If confidence stems partly from a coherence signal, not just decision-evidence strength, then manipulations that disrupt internal representational coherence should reduce confidence more than manipulations that introduce noise, even when task accuracy remains the same across both conditions. This holds true even for correct decisions.

## Status and next steps

- [x] Formalize a model for confidence generation, incorporating distinct pathways for separable noise and coherence-conflict.
- [x] Generate data that matches accuracy for different manipulation types.
- [x] Fit a hierarchical ordinal model and verify that the predicted asymmetry is present in the fixed effects.
- [ ] Verification of formal parameter retrieval (actual slopes compared to original simulated parameters)
- [ ] Apply to actual behavioural data
- [ ] Compare models to process-level alternatives
