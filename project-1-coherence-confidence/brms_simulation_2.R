library(tidyverse)
library(brms)

# Parameters

n_subjects <- 50
n_trials <- 200

set.seed(123)


# Assign Parameters to subjects
# Subject-level parameters

subjects <- tibble(
  subject = 1:n_subjects,
  base_sensitivity = rnorm(n_subjects, 1, 0.2),
  lambda_noise = rnorm(n_subjects, 0.6, 0.15),
  lambda_coherence = rnorm(n_subjects, 1.2, 0.2)
)


# Assign Trial-level tasks to subjects: simulation

simulation_data <- expand_grid(
  subject = subjects$subject,
  trials <- 1:n_trials
)

# Trial-tasks will comprise 2 Independent conditions: Noise & Coherence_distractor
# Accuracy will remain the same across both conditions
# To generate accuracy, we will need an accuracy signal that will be a function of evidence

simulation_data <- simulation_data %>%
  left_join(
    subjects, by = "subject"
  ) %>%
  mutate(
    evidence = rnorm(n(), 0, 1), # Underlying evidence strength
    condition = sample(c("noise", "coherence_distractor"), n(), replace = TRUE),
    accuracy_signal = case_when(
      condition == "noise" ~ {
       evidence + rnorm(n(), 0, lambda_noise)
      },
      condition == "coherence_distractor" ~ {
        distractor <- rnorm(n(), 0.6 * evidence, 1)
        evidence - distractor
      }
    ),
    
    accuracy_prob = plogis(base_sensitivity * accuracy_signal),
    accuracy = rbinom(n(), 1, accuracy_prob)
  )

# Rescale distractor strength so accuracy roughly matches noise condition

 target_diff <- 0
 for (i in 1:3) {
  simulation_data <- simulation_data %>%
    mutate(
      accuracy_signal = case_when(
        condition == "noise" ~
          evidence + rnorm(n(), 0, lambda_noise),
        
        condition == "coherence_distractor" ~ {
          distractor <- rnorm(n(), 0.6 * evidence, 1)
          evidence - 0.9 * distractor  # tuning knob
        }
      ),
      accuracy_prob = plogis(base_sensitivity * accuracy_signal),
      accuracy = rbinom(n(), 1, accuracy_prob)
    )
}


# Generate Dependent Variable: Latent Confidence
# Latent confidence is a function of the noise magnitude and coherence_conflict
# Latent confidence is disrupted by coherence_conflict > noise_magnitude

simulation_data <- simulation_data %>%
  mutate(
    noise_magnitude = case_when(
    condition == "noise" ~ abs(rnorm(n(), 0, lambda_noise)), 
    TRUE ~ 0
    ),
    
    coherence_conflict = case_when(
      condition == "coherence_distractor" ~ abs(rnorm(n(), 0, lambda_coherence)),
      TRUE ~ 0
    ),
    
    latent_confidence = 
      base_sensitivity * accuracy_signal +
      (-lambda_noise * noise_magnitude) +
      (-lambda_coherence * coherence_conflict),
    
    
    # Convert Latent Confidence into Latent Ordinal Confidence: Scale 1:6
    
    confidence_continuous = scale(latent_confidence)[,1],
    
    confidence = cut(
      confidence_continuous,
      breaks = quantile(confidence_continuous, probs = seq(0, 1, length.out = 7)),
      include.lowest = TRUE,
      labels = 1:6
    ) %>% as.integer()
  )
    
# Fit brms model

simulation_data$confidence <- ordered(simulation_data$confidence)

model <- brm(
  confidence ~ condition * accuracy + (condition * accuracy | subject),
  data = simulation_data,
  family = cumulative("logit"),
  chains = 2,
  cores = 2,
  iter = 2000
)

summary(model)



