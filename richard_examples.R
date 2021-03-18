

data.original <- read.csv("~/Downloads/data.csv")

library(brms)
library(ggplot2)

# filter out the rows we want to use
data.onlyCompleted = subset(data.original, task_completion == "Completed")

# standardize
encode.standard <- function(column) {
  (column - mean(column)) / sd(column)
}

# converts to a unique id i..n for each value
encode.unique <- function(column) {
  H <- new.env()
  i <- 1
  nextID <- 1
  newColumn <- vector( length = length(column))
  while (i <= length(column)) {
    if (is.null(H[[column[i]]])) {
      H[[column[i]]] = nextID
      nextID = nextID + 1
    }
    newColumn[i] = H[[column[i]]]
    i = i + 1
  }
  newColumn
}

# convert categories to int 1..n in the order given
encode.categorical <- function(column, categories) {
  unclass(factor(column, level = categories))
}

# convert bool to int true = 1, false = 2
encode.bool <- function(column) {
  encode.categorical(column, c("true", "false"))
}

# Convert year float to  int months
encode.yearToMonth <- function(column) {
  round(column * 12)
}

# Change likert scales from -3 to 3 to 1 to 7
encode.likert <- function(column) {
  column + 4
}

# Build dataframe
data <- data.onlyCompleted
data.clean <- data.frame(
  id                            = encode.unique(data$session), 
  
  O_time_seconds                = data$time,
  O_reused_logic_constructor_b  = encode.bool(data$reused_logic_constructor),
  O_reused_logic_validation_b   = encode.bool(data$reused_logic_validation),
  O_reused_logic_equals_b       = encode.bool(data$reused_logic_equals),
  O_reused_logic_hashcode_b     = encode.bool(data$reused_logic_hashcode),
  O_has_equals_b                = encode.bool(data$has_equals),
  O_has_hashcode_b              = encode.bool(data$has_hashcode),
  
  O_documentation_c3            = encode.categorical(data$documentation, c("Incorrect", "None", "Correct")),
  
  O_var_names_copied_all        = data$var_names_copied_all,
  O_var_names_copied_good       = data$var_names_copied_good,
  O_var_names_new_all           = data$var_names_new_all,
  O_var_names_new_good          = data$var_names_new_good,
  O_var_names_edited_all        = data$var_names_edited_all,
  O_var_names_edited_good       = data$var_names_edited_good,
  O_sonarqube_issues            = data$sonarqube_issues,
  
  group_c2                      = encode.categorical(data$group, c("students", "consultants")),
  education_level_oc7           = encode.categorical(data$education_level, c("None", "Some bachelor studies", "Bachelor degree", "Some master studies", "Master degree", "Some Ph.D. studies", "Ph. D.")),
  education_field_c2            = encode.categorical(data$education_field, c("Computer Science", "Software Engineering")),
  work_exp_field_c6             = encode.categorical(data$work_domain, c("None", "Automotive", "Finance", "Web", "Adtech", "Research")),
  
  prof_prog_exp_months          = encode.yearToMonth(data$work_experience_java),
  prof_java_exp_months          = encode.yearToMonth(data$work_experience_java.1),
  
  wp_pair_program_b             = encode.bool(data$workplace_pair_programming),
  wp_peer_review_b              = encode.bool(data$workplace_peer_review),
  wp_td_tracking_b              = encode.bool(data$workplace_td_tracking),
  wp_coding_stds_b              = encode.bool(data$workplace_coding_standards),
  
  task_completion_oc4           = encode.categorical(data$task_completion, c("Not submitted", "Does not compile", "Incorrect solution", "Completed")),
  
  sys_qual_score                = encode.likert(data$quality_pre_task),
  own_work_qual_score           = encode.likert(data$quality_post_task),
  
  modified_lines                = data$modified_lines,
  
  was_high_debt_b               = encode.bool(data$high_debt_version),
  
  scenario_c2                   = encode.categorical(data$scenario, c("booking", "tickets"))
  
  # order                         = data$order + 1
)
rm(data)


## Analysis

d$ts_s <- scale(d$O_time_seconds)

m0_p <- brm(
  O_time_seconds ~ 1,
  data = d,
  family = poisson()
)

m0_nb <- brm(
  O_time_seconds ~ 1,
  data = d,
  family = negbinomial()
)

loo(m0_p,m0_nb) # nb sign better than poisson already with only \alpha est

# Set a unique prior

p <- get_prior(O_time_seconds ~ 1,
               data = d,
               family = negbinomial())
p$prior[1] <- "normal(0,5)"

m0_pri <- brm(
  O_time_seconds ~ 1,
  data = d,
  prior = p,
  family = negbinomial()
)


### first predictor

p <- get_prior(
  O_time_seconds ~ 1 + was_high_debt_b,
  data = d,
  family = negbinomial()
)

p$prior[1] <- "normal(0,0.1)"
p$prior[3] <- "normal(0,2.5)"

m1_ppc <- brm(
  O_time_seconds ~ 1 + was_high_debt_b,
  data = d,
  prior = p,
  sample_prior = "only",
  family = negbinomial()
)

pp_check(m1_ppc) + scale_x_continuous(trans="log10")

d$modified_lines_s <- scale(d$modified_lines)

p <- get_prior(O_time_seconds ~ 0 + was_high_debt_b + modified_lines_s + 
                 (1 | scenario_c2),
               data = d,
               family = negbinomial())

p$prior[1] <- "normal(0,0.1)"
# p$prior[4] <- "normal(0,1)"
p$prior[4] <- "exponential(1)"

m2 <- brm(
  O_time_seconds ~ was_high_debt_b + modified_lines_s + (1 | scenario_c2),
  data = d,
  prior = p,
  #sample_prior = "only",
  family = negbinomial(),
  control = list(adapt_delta = 0.99999),
  iter = 5e3
)

d$prof_prog_exp_months_s <- scale(d$prof_prog_exp_months)

p <- get_prior(O_time_seconds ~ 1 + was_high_debt_b + scenario_c2 + 
                 prof_prog_exp_months_s + work_exp_field_c6 + (1 | id),
               data = d,
               family = negbinomial()
)

p$prior[1] <- "normal(0, 0.1)"
p$prior[6] <- "normal(0, 1)"
p$prior[7] <- "exponential(1)"

d$work_exp_field_c6 <- as.numeric(d$work_exp_field_c6)

m3 <- brm(
  O_time_seconds ~ 1 + was_high_debt_b + scenario_c2 + 
    prof_prog_exp_months_s + work_exp_field_c6  + (1 + work_exp_field_c6 | id),
  data = d,
  # prior = p,
  # sample_prior = "only",
  family = negbinomial(),
  control = list(adapt_delta = 0.999),
  iter = 5e3
)

ndf <- data.frame(
  was_high_debt_b = 1,
  scenario_c2 = 1,
  prof_prog_exp_months_s = 0,
  work_exp_field_c6 = seq(1:5)
)

post <- posterior_predict(m3, newdata = ndf, re_formula = NA)

## bernoulli

p <- get_prior(
  mvbind(O_reused_logic_constructor_b,
         O_reused_logic_validation_b,
         O_reused_logic_hashcode_b,
         O_reused_logic_equals_b) ~ 1 + was_high_debt_b + (1 |c| id),
  family = bernoulli(),
  data = d
)

p$prior[1] <- "normal(0, 0.1)"
p$prior[2] <- "lkj(2)"
p$prior[c(4,7,13,19,25)] <- "normal(0, 1)"
p$prior[c(8:10, 14:16, 20:22, 26:28)] <- "exponential(1)"

m4 <- brm(
  mvbind(O_reused_logic_constructor_b,
         O_reused_logic_validation_b,
         O_reused_logic_hashcode_b,
         O_reused_logic_equals_b) ~ 1 + was_high_debt_b + (1 |c| id),
  family = bernoulli(),
  data = d,
  prior = p,
  iter = 5e3
)

pp_check(m4, resp = "Oreusedlogicconstructorb")

# library(rethinking)
# 
# m_rt <- ulam(
#   alist(
#     O_time_seconds ~ dgampois(lambda, phi),
#     lambda <- alpha + b_m * modified_lines_s + b_w * was_high_debt_b + b,
#     alpha ~ normal(0, 2.5),
#     c(b_m, b_w) ~ normal(0, 0.5),
#     phi ~ exponential(1)
#   ), data = d, cores = 4, chains = 4, cmdstan = TRUE
# )















