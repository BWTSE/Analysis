library(brms)

# Convenience

summary(var_names)

prior_summary(var_names)

posterior_samples(var_names)

# Different approach


var_names0 <- brm(
  mvbf(bf(
    O_var_names_new_good| trials(O_var_names_new_all) ~ 1
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
    + (1 | c | id),
    family = binomial()
  ), bf(
    O_var_names_copied_good| trials(O_var_names_copied_all) ~ 1
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
    + (1 | c | id),
    family = binomial()
  )),
  data = d.reuse,
  prior = c(
    prior(normal(0, 0.5), class = "b", resp = Ovarnamescopiedgood),
    prior(normal(0, 0.5), class = "b", resp = Ovarnamesnewgood),
    prior(normal(0, 1.5), class = "Intercept", resp = Ovarnamescopiedgood),
    prior(normal(0, 1.5), class = "Intercept", resp = Ovarnamesnewgood),
    prior(exponential(1), class = "sd", resp = Ovarnamescopiedgood),
    prior(exponential(1), class = "sd", resp = Ovarnamesnewgood)
  ),
  backend = "cmdstanr",
  # sample_prior = "only",
  chains = 4,
  cores = 4,
  iter = 5e3
  #empty = TRUE
  #file = "fits/doc0",
  #file_refit = "on_change"),
)

var_names0 <- brm(
  mvbf(bf(
    O_var_names_new_good| trials(O_var_names_new_all) ~ 1
    + was_high_debt_b
    + O_var_names_copied_all
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
    + (1 | c | id),
    family = binomial()
  ), bf(
    O_var_names_copied_good| trials(O_var_names_copied_all) ~ 1
    + was_high_debt_b
    + O_var_names_copied_all
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
    + (1 | c | id),
    family = binomial()
  )),
  data = d.reuse,
  prior = c(
    prior(normal(0, 0.5), class = "b", resp = Ovarnamescopiedgood),
    prior(normal(0, 0.5), class = "b", resp = Ovarnamesnewgood),
    prior(normal(0, 1.5), class = "Intercept", resp = Ovarnamescopiedgood),
    prior(normal(0, 1.5), class = "Intercept", resp = Ovarnamesnewgood),
    prior(exponential(1), class = "sd", resp = Ovarnamescopiedgood),
    prior(exponential(1), class = "sd", resp = Ovarnamesnewgood)
  ),
  backend = "cmdstanr",
  # sample_prior = "only",
  chains = 4,
  cores = 4,
  iter = 5e3
  #empty = TRUE
  #file = "fits/doc0",
  #file_refit = "on_change"),
)














