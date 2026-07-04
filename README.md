# Metacognitive-Structure-of-Uncertainty-Simulation-Studies
Metacognitive Structure of Uncertainty: Simulation Studies

## Overview

This repository contains a set of simulation and Bayesian modelling studies investigating how metacognitive confidence may be sensitive to the *generative structure of uncertainty*, rather than solely to behavioural accuracy.

A central question motivating this work is whether confidence systems treat different sources of uncertainty—such as stochastic noise and representational conflict—as computationally distinct, even when they produce matched levels of task performance.

This project forms **one component of a broader research programme** examining the relationship between representation, uncertainty, metacognitive evaluation and action

---

## Conceptual Motivation

Standard models of confidence often assume a relatively unitary notion of uncertainty, typically operationalised through variability in evidence or decision noise.

However, in realistic cognitive settings, equivalent behavioural accuracy can arise from qualitatively different generative mechanisms, such as:

- stochastic noise in evidence accumulation
- structured conflict between competing representations

This raises the question:

> Does metacognitive confidence distinguish between these sources of uncertainty, or collapse them into a single scalar estimate of difficulty?

---

## This Repository Focus

This repository specifically implements a **simulation-based identifiability test** of this question.

It does not present a full theory of metacognition. Instead, it isolates a single component:

> Whether standard ordinal models of confidence can recover sensitivity to distinct uncertainty structures when behavioural accuracy is controlled.

---

## Model Structure

The simulation implements a simplified perceptual decision task with two experimental manipulations:

### 1. Noise Condition
- Gaussian noise is added directly to the evidence signal
- This represents stochastic uncertainty in decision input

### 2. Coherence / Conflict Condition
- A secondary, structured evidence stream is introduced
- This stream conflicts with the primary signal
- Parameters are calibrated to match accuracy with the noise condition

---

## Confidence Generation Assumption

Confidence is generated as a function of:

- evidence strength
- magnitude of stochastic noise
- degree of representational conflict

Crucially, noise and conflict are assigned **separate weighting parameters**, allowing for asymmetric contributions to confidence even under matched accuracy.

---

## Statistical Model

Confidence data are analysed using hierarchical Bayesian ordinal regression:

- Model: cumulative logit (or probit)
- Framework: `brms`
- Structure:
