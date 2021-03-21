
d.reuse = subset(d, task_completion_oc4 == 4)
d.reuse$prof_prog_exp_months.s = scale(d.reuse$prof_prog_exp_months)
d.reuse$prof_java_exp_months.s = scale(d.reuse$prof_java_exp_months)

reuse0 <- brm(
  mvbind(
    O_reused_logic_constructor_b,
    O_reused_logic_validation_b,
    O_reused_logic_hashcode_b,
    O_reused_logic_equals_b
  ) ~ 1
  + was_high_debt_b
  # + mo(education_level_oc7)
  # + education_field_c2
  # + work_exp_field_c6
  # + prof_prog_exp_months.s
  # + prof_java_exp_months.s
  # + wp_peer_review_b
  # + wp_pair_program_b
  # + wp_td_tracking_b
  # + wp_coding_stds_b
  # + scenario_c2
  # + mo(sys_qual_score)+(1 | c | id),
  family = bernoulli(),
  data = d.reuse,
  prior = c(
    prior(normal(0, 0.1), class = "b"),
    prior(normal(0, 1), class = "Intercept"),
    prior(exponential(1), class = "sd", resp = Oreusedlogicconstructorb),
    prior(exponential(1), class = "sd", resp = Oreusedlogicequalsb),
    prior(exponential(1), class = "sd", resp = Oreusedlogichashcodeb),
    prior(exponential(1), class = "sd", resp = Oreusedlogicvalidationb),
    
    # prior(dirichlet(2), class = "simo", coef = "moeducation_level_oc71", resp = Oreusedlogicconstructorb),
    # prior(dirichlet(2), class = "simo", coef = "moeducation_level_oc71", resp = Oreusedlogicequalsb),
    # prior(dirichlet(2), class = "simo", coef = "moeducation_level_oc71", resp = Oreusedlogichashcodeb),
    # prior(dirichlet(2), class = "simo", coef = "moeducation_level_oc71", resp = Oreusedlogicvalidationb),
    
    # prior(dirichlet(2), class = "simo", coef = "mosys_qual_score1", resp = Oreusedlogicconstructorb),
    # prior(dirichlet(2), class = "simo", coef = "mosys_qual_score1", resp = Oreusedlogicequalsb),
    # prior(dirichlet(2), class = "simo", coef = "mosys_qual_score1", resp = Oreusedlogichashcodeb),
    # prior(dirichlet(2), class = "simo", coef = "mosys_qual_score1", resp = Oreusedlogicvalidationb),
    prior(lkj(1), class = "L")
  ),
  # empty = TRUE, # If you only want to check prior definitions
  # sample_prior = "only",
  backend = "cmdstanr",
  chains = 4,
  cores = 4,
  iter = 5e3,
  file = "fits/reuse0",
  file_refit = "on_change"
)
