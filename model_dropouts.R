d.dropouts = d
d.dropouts$prof_prog_exp_months.s = scale(d.dropouts$prof_prog_exp_months)
d.dropouts$prof_java_exp_months.s = scale(d.dropouts$prof_java_exp_months)
d.dropouts$dropout_b = as.integer(d$task_completion_oc4 < 3) + 1

dropout0 <- brm(
  dropout_b ~ 1
  + was_high_debt_b
  + order
  # + mo(education_level_oc7)
  # + education_field_c2
  # + work_exp_field_c6
  # + prof_prog_exp_months
  # + prof_java_exp_months
  # + wp_peer_review_b
  # + wp_pair_program_b
  # + wp_td_tracking_b
  # + wp_coding_stds_b
  + scenario_c2,
  # + mo(sys_qual_score)
  # + (1 | id),
  family = bernoulli(),
  data = d.dropouts,
  prior = c(
    prior(normal(0, 1.5), class = "b"),
    prior(normal(0, 1), class = "Intercept")
    # prior(exponential(1), class = "sd")

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
  file = "fits/dropout0",
  file_refit = "on_change"
)
