library(brms)


sonarqube_issues <- brm(
  O_sonarqube_issues ~ 1 
  + was_high_debt_b
  #    + mo(education_level_oc7)
  #    + education_field_c2
  #    + work_exp_field_c6
  #    + prof_prog_exp_months
  #    + prof_java_exp_months
  #    + wp_peer_review_b
  #    + wp_pair_program_b
  #    + wp_td_tracking_b
  #    + wp_coding_stds_b
  #    + scenario_c2
  + (1 | id),
  family = negbinomial(),
  data = d,
  prior = c(
    prior(normal(0, 1), class = "b"),
    prior(normal(0, 1), class = "Intercept"),
    prior(exponential(1), class = "sd"),
    prior(gamma(0.01,0.01), class = "shape") #default choice, dk if reasonable
  ),
  control = list(adapt_delta = 0.99),
  backend = "cmdstanr",
  chains = 4,
  cores = 4,
  iter = 5e3
  #empty = TRUE
  #file = "fits/doc0",
  #file_refit = "on_change"),
)

# Convenience

summary(sonarqube_issues)

prior_summary(sonarqube_issues)

posterior_samples(sonarqube_issues)

# Comparison

sonarqube_issues_alt <- brm(
  O_sonarqube_issues ~ 1 
  + was_high_debt_b
  #    + mo(education_level_oc7)
  #    + education_field_c2
  #    + work_exp_field_c6
  #    + prof_prog_exp_months
  #    + prof_java_exp_months
  #    + wp_peer_review_b
  #    + wp_pair_program_b
  #    + wp_td_tracking_b
  #    + wp_coding_stds_b
  #    + scenario_c2
  + (1 | id),
  family = negbinomial(),
  data = d,
  prior = c(
    prior(normal(0, 1), class = "b"),
    prior(normal(0, 1), class = "Intercept"),
    prior(exponential(1), class = "sd"),
    prior(gamma(0.01,0.01), class = "shape") #default choice, dk if reasonable
  ),
  control = list(adapt_delta = 0.99),
  backend = "cmdstanr",
  chains = 4,
  cores = 4,
  iter = 5e3
  #empty = TRUE
  #file = "fits/doc0",
  #file_refit = "on_change"),
)

loo(sonarqube_issues,sonarqube_issues_alt)