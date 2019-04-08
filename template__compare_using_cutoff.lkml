# include: "main.lkml"
#
# view: YOUR_VIEW_NAME {
#   #list compare_using_cutoff_parameter in your set of extended views
#   extends: [compare_using_cutoff_parameter]
#
#   #created a dimension in your view called field_to_compare, and reference the field you want to us
#   dimension: field_to_compare {sql:$ {MAKE THIS A REFERENCE TO YOUR NUMERIC FIELD};;}
#
# }
