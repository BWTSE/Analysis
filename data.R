library(curl)

d.orig <- read.csv(curl("https://raw.githubusercontent.com/BrokenWindowsInvestigation/Submissions/master/data.csv?token=AB26LHNUC7ALHHGG2SU43W3AK4Z42"))

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
  as.numeric(unclass(factor(column, level = categories)))
}

# convert bool to int true = 1, false = 2
encode.bool <- function(column) {
  encode.categorical(column, c("true", "false"))
}

# convert categories to int 1..n in the order given
encode.orderedcategorical <- function(column, categories) {
  as.ordered(encode.categorical(column, categories))
}

# Convert year float to  int months
encode.yearToMonth <- function(column) {
  round(column * 12)
}

# Change likert scales from -3 to 3 to 1 to 7
encode.likert <- function(column) {
  as.ordered(column + 4)
}

# Build dataframe
d <- data.frame(
  id                            = encode.unique(d.orig$session), 
  
  O_time_seconds                = d.orig$time,
  O_reused_logic_constructor_b  = encode.bool(d.orig$reused_logic_constructor),
  O_reused_logic_validation_b   = encode.bool(d.orig$reused_logic_validation),
  O_reused_logic_equals_b       = encode.bool(d.orig$reused_logic_equals),
  O_reused_logic_hashcode_b     = encode.bool(d.orig$reused_logic_hashcode),
  O_has_equals_b                = encode.bool(d.orig$has_equals),
  O_has_hashcode_b              = encode.bool(d.orig$has_hashcode),
  
  O_documentation_oc3           = encode.orderedcategorical(d.orig$documentation, c("Incorrect", "None", "Correct")),
  
  O_var_names_copied_all        = d.orig$var_names_copied_all,
  O_var_names_copied_good       = d.orig$var_names_copied_good,
  O_var_names_new_all           = d.orig$var_names_new_all,
  O_var_names_new_good          = d.orig$var_names_new_good,
  O_var_names_edited_all        = d.orig$var_names_edited_all,
  O_var_names_edited_good       = d.orig$var_names_edited_good,
  O_sonarqube_issues            = d.orig$sonarqube_issues,
  
  group_c2                      = encode.categorical(d.orig$group, c("students", "consultants")),
  education_level_oc7           = encode.orderedcategorical(d.orig$education_level, c("None", "Some bachelor studies", "Bachelor degree", "Some master studies", "Master degree", "Some Ph.D. studies", "Ph. D.")),
  education_field_c2            = encode.categorical(d.orig$education_field, c("Computer Science", "Software Engineering")),
  work_exp_field_c6             = encode.categorical(d.orig$work_domain, c("None", "Automotive", "Finance", "Web", "Adtech", "Research")),
  
  prof_prog_exp_months          = encode.yearToMonth(d.orig$work_experience_java),
  prof_java_exp_months          = encode.yearToMonth(d.orig$work_experience_java.1),
  
  wp_pair_program_b             = encode.bool(d.orig$workplace_pair_programming),
  wp_peer_review_b              = encode.bool(d.orig$workplace_peer_review),
  wp_td_tracking_b              = encode.bool(d.orig$workplace_td_tracking),
  wp_coding_stds_b              = encode.bool(d.orig$workplace_coding_standards),
  
  task_completion_oc4           = encode.orderedcategorical(d.orig$task_completion, c("Not submitted", "Does not compile", "Incorrect solution", "Completed")),
  
  sys_qual_score                = encode.likert(d.orig$quality_pre_task),
  own_work_qual_score           = encode.likert(d.orig$quality_post_task),

  modified_lines                = d.orig$modified_lines,
  
  was_high_debt_b               = encode.bool(d.orig$high_debt_version),
  
  scenario_c2                   = encode.categorical(d.orig$scenario, c("booking", "tickets")),
  
  order                         = d.orig$order + 1,
  large_structure_change_b      = encode.bool(d.orig$large_structure_change)
)

rm(encode.bool, encode.categorical, encode.likert, encode.unique, encode.yearToMonth, encode.orderedcategorical)
