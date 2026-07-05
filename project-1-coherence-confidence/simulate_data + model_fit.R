# =========================
# STEP 0: PACKAGES
# =========================
library(tidyverse)
library(brms)

set.seed(123)

# =========================
# STEP 1: SIMULATED TASK
# =========================
n_subjects <- 50
n_trials <- 200

# latent subject parameters
subjects <- tibble(
  subject = 1:n_subjects,
  base_sensitivity = rnorm(n_subjects, 1, 0.2),
  lambda_noise = abs(rnorm(n_subjects, 0.6, 0.15)),
  lambda_coherence = abs(rnorm(n_subjects, 1.2, 0.2)) # hypothesised > lambda_noise
)

# trial-level data
dat <- expand_grid(
  subject = subjects$subject,
  trial = 1:n_trials
) %>%
  left_join(subjects, by = "subject") %>%
  mutate(
    
    # true underlying evidence strength
    evidence = rnorm(n(), 0, 1),
    
    # manipulation assignment
    manipulation_type = sample(c("noise", "coherence_distractor"), n(), replace = TRUE),
    
    # ACCURACY GENERATION
    accuracy_signal = case_when(
      
      manipulation_type == "noise" ~
        evidence + rnorm(n(), 0, lambda_noise),
      
      manipulation_type == "coherence_distractor" ~ {
        distractor <- rnorm(n(), 0.6 * evidence, 1)
        evidence - distractor
      }
    ),
    
    accuracy_prob = plogis(base_sensitivity * accuracy_signal),
    accuracy = rbinom(n(), 1, accuracy_prob)
  )

# =========================
# STEP 2: CALIBRATE COHERENCE CONDITIO
# =========================
# Distractor strength is rescaled so accuracy roughly matches noise condition

# quick heuristic scaling loop
target_diff <- 0
for (i in 1:3) {
  dat <- dat %>%
    mutate(
      accuracy_signal = case_when(
        manipulation_type == "noise" ~
          evidence + rnorm(n(), 0, lambda_noise),
        
        manipulation_type == "coherence_distractor" ~ {
          distractor <- rnorm(n(), 0.6 * evidence, 1)
          evidence - 0.9 * distractor  # tuning knob
        }
      ),
      accuracy_prob = plogis(base_sensitivity * accuracy_signal),
      accuracy = rbinom(n(), 1, accuracy_prob)
    )
}

# =========================
# STEP 3: CONFIDENCE GENERATION 
# =========================

dat <- dat %>%
  mutate(
    
    noise_magnitude = case_when(
      manipulation_type == "noise" ~ abs(rnorm(n(), 0, lambda_noise)),
      TRUE ~ 0
    ),
    
    coherence_conflict = case_when(
      manipulation_type == "coherence_distractor" ~ abs(rnorm(n(), 0, lambda_coherence)),
      TRUE ~ 0
    ),
    
    latent_confidence = 
      base_sensitivity * accuracy_signal +
      (-lambda_noise * noise_magnitude) +
      (-lambda_coherence * coherence_conflict),
    
    # ordinal confidence scale (1–6)
    confidence_continuous = scale(latent_confidence)[,1],
    
    confidence = cut(
      confidence_continuous,
      breaks = quantile(confidence_continuous, probs = seq(0, 1, length.out = 7)),
      include.lowest = TRUE,
      labels = 1:6
    ) %>% as.integer()
  )

# =========================
# STEP 4: BRMS MODEL
# =========================

dat$confidence <- ordered(dat$confidence)

model <- brm(
  confidence ~ manipulation_type * accuracy + (manipulation_type * accuracy | subject),
  data = dat,
  family = cumulative("logit"),
  chains = 2,
  cores = 2,
  iter = 1500
)

summary(model)
