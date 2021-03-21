doc0 <- brm(
  O_documentation_oc3 ~ 1
  + was_high_debt_b
  # + mo(education_level_oc7)
  # + education_field_c2
  # + work_exp_field_c6
  # + prof_prog_exp_months
  # + prof_java_exp_months
  # + wp_peer_review_b
  # + wp_pair_program_b
  # + wp_td_tracking_b
  # + wp_coding_stds_b
  # + scenario_c2
  # + mo(sys_qual_score)
  + (1 | id),
  family = cumulative(),
  data = d,
  prior = c(
    prior(normal(0, 0.1), class = "b"),
    prior(normal(0, 1), class = "Intercept"),
    prior(exponential(1), class = "sd")
    
    # prior(dirichlet(2), class = "simo", coef = "moeducation_level_oc71"),
    #
    # prior(dirichlet(2), class = "simo", coef = "mosys_qual_score1")
  ),
  # empty = TRUE, # If you only want to check prior definitions
  # sample_prior = "only",
  backend = "cmdstanr",
  chains = 4,
  cores = 4,
  iter = 5e3,
  file = "fits/doc0",
  file_refit = "on_change"
)
