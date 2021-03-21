library(curl)

data.original <- read.csv(curl("https://raw.githubusercontent.com/BrokenWindowsInvestigation/Submissions/master/data.csv?token=AB26LHNZN57NNIJI7CVUKCTAK4NCQ"))

# filter out the rows we want to use
data.onlyCompleted = subset(data.original, task_completion == "Completed")

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
  
  O_documentation_oc3           = encode.orderedcategorical(data$documentation, c("Incorrect", "None", "Correct")),
  
  O_var_names_copied_all        = data$var_names_copied_all,
  O_var_names_copied_good       = data$var_names_copied_good,
  O_var_names_new_all           = data$var_names_new_all,
  O_var_names_new_good          = data$var_names_new_good,
  O_var_names_edited_all        = data$var_names_edited_all,
  O_var_names_edited_good       = data$var_names_edited_good,
  O_sonarqube_issues            = data$sonarqube_issues,
  
  group_c2                      = encode.categorical(data$group, c("students", "consultants")),
  education_level_oc7           = encode.orderedcategorical(data$education_level, c("None", "Some bachelor studies", "Bachelor degree", "Some master studies", "Master degree", "Some Ph.D. studies", "Ph. D.")),
  education_field_c2            = encode.categorical(data$education_field, c("Computer Science", "Software Engineering")),
  work_exp_field_c6             = encode.categorical(data$work_domain, c("None", "Automotive", "Finance", "Web", "Adtech", "Research")),
  
  prof_prog_exp_months          = scale(encode.yearToMonth(data$work_experience_java)),
  prof_java_exp_months          = scale(encode.yearToMonth(data$work_experience_java.1)),
  
  wp_pair_program_b             = encode.bool(data$workplace_pair_programming),
  wp_peer_review_b              = encode.bool(data$workplace_peer_review),
  wp_td_tracking_b              = encode.bool(data$workplace_td_tracking),
  wp_coding_stds_b              = encode.bool(data$workplace_coding_standards),
  
  task_completion_oc4           = encode.orderedcategorical(data$task_completion, c("Not submitted", "Does not compile", "Incorrect solution", "Completed")),
  
  sys_qual_score                = encode.likert(data$quality_pre_task),
  own_work_qual_score           = encode.likert(data$quality_post_task),
  
  modified_lines                = scale(data$modified_lines),
  
  was_high_debt_b               = encode.bool(data$high_debt_version),
  
  scenario_c2                   = encode.categorical(data$scenario, c("booking", "tickets")),
  
  order                         = data$order + 1
)
rm(data)

d <- data.clean
rm(data.clean, data.onlyCompleted, data.original)


rm(encode.bool, encode.categorical, encode.likert, encode.unique, encode.yearToMonth, encode.orderedcategorical)
