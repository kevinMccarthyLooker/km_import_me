#vvvv old examples of invoking functions
#{
# view: age_times_3 {extends:[split_input_remote_multiply] dimension: input {sql:${uas2.age}^^3;;}}
# view: id_times_100{extends:[split_input_remote_multiply] dimension: input {sql:${users_view.id}^^100;;}}
# view: Age_Over_5{extends:[divide] dimension: input {sql:${users_view.age}^^5;;}}
#... explore...
  # join: age_times_3 {sql:;; relationship: one_to_one}
  # join: id_times_100 {view_label:"Users View" sql:;; relationship: one_to_one}
  # join: Age_Over_5 {view_label:"Users View" sql:;; relationship: one_to_one}
#}


#acronymize replaced with a version that uses measures for input... by way of testing. Converted to a flexible input system
# view: acronymize1 {extends:[acronymize] dimension:input {sql:'Test'^^'another test'^^'Xavier';;}dimension:output{view_label:"Users"}}
#   join: acronymize1 {sql:;; relationship: one_to_one}


#^^^^^ old examples of invoking functions
