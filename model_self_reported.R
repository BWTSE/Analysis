d.srqu = subset(d, task_completion_oc4 == 4)
d.srqu$prof_prog_exp_months.s = scale(d.srqu$prof_prog_exp_months)
d.srqu$prof_java_exp_months.s = scale(d.srqu$prof_java_exp_months)
d.srqu$var_name_copied_good_ratio = scale(d.srqu$O_var_names_copied_good / d.srqu$O_var_names_copied_all)
d.srqu$var_name_copied_new_ratio = scale(d.srqu$O_var_names_new_good / d.srqu$O_var_names_new_all)

srqu0 <- brm(
  own_work_qual_score ~ 1
  + O_reused_logic_constructor_b
  + O_reused_logic_validation_b
  + O_reused_logic_hashcode_b
  + O_reused_logic_equals_b
  + O_sonarqube_issues
  + var_name_copied_good_ratio
  + var_name_copied_new_ratio
  # + was_high_debt_b
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
  data = d.srqu,
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
  file = "fits/srqu0",
  file_refit = "on_change"
)
