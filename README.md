# Latent Architecture and Decision-Making Under Uncertainty

## Framework

The repository serves as a record of independent work to formalize a structural theory, proposing that consistent individual variations in the weight given to context-invariant representations (as a sufficiency standard for action when faced with uncertainty) form a latent architectural feature that systematically influences decision outcomes.

This is offered as a structural-level explanation.

This argument concerns an individual’s consistent standard for recognizing when enough structure has been gathered to take action, rather than the ongoing, real-time handling and accumulation of evidence.

## Method

The repository serves as an ongoing record of the sequence, not a completed empirical result. Projects here are at different stages of development.

## Project 1: The Impact of Coherence-Destabilization and Error-Introduction on Confidence

### Current status: experimental simulation / viability test.

This simulation investigates if two methods, which achieve the same level of objective accuracy but operate differently, result in varying impacts on confidence. One method adds noise to a decision’s evidence. It thus preserves coherence while introducing errors. The other method adds conflicting evidence, disrupting coherence. The also examines whether these differences in confidence costs are consistent among individuals.

### Motivation:

Standard models of confidence typically treat uncertainty as a unitary construct. They also conceptualise confidence as a function of post-decisional accuracy accummulation. However, in many cognitive settings, equivalent behavioural accuracy can arise from qualitatively different generative mechanisms. 

### Prediction: 
If confidence stems partly from a coherence signal, not just evidence strength, then manipulations that disrupt coherence should reduce confidence more than noise that matches accuracy. This holds true even for correct decisions.

## Folder Content

- [x] simulate_data.R: This creates fake subject and trial data for both manipulation types. Subject-specific parameters (lambda_coherence, lambda_noise) control how much each manipulation impacts a subject’s confidence.

- [x] fit_model.R: This R script implements a hierarchical ordinal Bayesian model via brms (cumulative “probit”/“logit”). The model is designed to test if the effect of manipulation type on confidence remains significant when accuracy is controlled for, and to investigate if individual subject slopes align with simulated variations.

- [x] subject_params.csv, trial_data.csv

## What this does and doesn’t show

The model detects a persistent confidence gap, even after accounting for accuracy, which worsens with coherence disruption. It also identifies consistent differences among individuals in the magnitude of this gap. In principle, this demonstrates that a standard hierarchical model can statistically detect the predicted signature, assuming the data aligns with the theory.

This does not prove the theory’s accuracy, nor is it a test of the model’s ability to isolate the intended latent construct from data that doesn’t reveal how it was generated. The verification of this isolation is a future plan, not a concluded action.

As a component of a larger hypothesis, this project serves as a working demonstration of formalizing and simulating, not a final version.

## Status and next steps

- [x] Formalize a model for confidence generation, incorporating distinct pathways for separable noise and coherence-conflict.
- [x] Generate data that matches accuracy for different manipulation types.
- [x] Fit a hierarchical ordinal model and verify that the predicted asymmetry is present in the fixed effects.
- [ ] Verification of formal parameter retrieval (actual slopes compared to original simulated parameters)
- [ ] Apply to actual behavioural data
- [ ] Compare models to process-level alternatives
