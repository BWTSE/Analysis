library(brms)

reuse1 <- brm(
  mvbind(O_reused_logic_constructor_b,
         O_reused_logic_validation_b,
         O_reused_logic_hashcode_b,
         O_reused_logic_equals_b) ~ 1 + was_high_debt_b + (1 |c| id),
  family = bernoulli(),
  data = d,
  prior = c(
    prior(normal(0, 0.1), class = "b"),
    prior(normal(0, 1), class = "Intercept"),
    prior(exponential(1), class = "sd", resp = Oreusedlogicconstructorb),
    prior(exponential(1), class = "sd", resp = Oreusedlogicequalsb),
    prior(exponential(1), class = "sd", resp = Oreusedlogichashcodeb),
    prior(exponential(1), class = "sd", resp = Oreusedlogicvalidationb),
    prior(lkj(1), class = "L")
  ),
  backend = "cmdstan",
  chains = 4,
  cores = 4,
  iter = 5e3,
  file = "fits/reuse1"
)

reuse2 <- brm(
  mvbind(O_reused_logic_constructor_b,
         O_reused_logic_validation_b,
         O_reused_logic_hashcode_b,
         O_reused_logic_equals_b) ~ 1 
    + was_high_debt_b 
    + education_level_oc7
    + education_field_c2
    + (1 |c| id),
  family = bernoulli(),
  data = d,
  prior = c(
    prior(normal(0, 0.1), class = "b"),
    prior(normal(0, 1), class = "Intercept"),
    prior(exponential(1), class = "sd", resp = Oreusedlogicconstructorb),
    prior(exponential(1), class = "sd", resp = Oreusedlogicequalsb),
    prior(exponential(1), class = "sd", resp = Oreusedlogichashcodeb),
    prior(exponential(1), class = "sd", resp = Oreusedlogicvalidationb),
    prior(lkj(1), class = "L"),
#    prior(dirichlet(, class = "b", coef = "education_level_oc7", resp = Oreusedlogicconstructorb),
#    prior(dirichlet(), class = "b", coef = "education_level_oc7", resp = Oreusedlogicequalsb),
#    prior(dirichlet(), class = "b", coef = "education_level_oc7", resp = Oreusedlogichashcodeb),
    prior(dirichlet(2,2,2,2,2,2,2), class = "b", coef = "education_level_oc7", resp = Oreusedlogicvalidationb)
  ),
  backend = "rstan",
  chains = 4,
  cores = 4,
  iter = 5e3
)
