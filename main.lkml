

##
include: "users*"


# view: custom_tiers_by_min_max_and_number_of_tiers {
# #   sql_table_name: public.users ;;
# #   dimension: id {primary_key:yes}
# #   dimension: age {}
# #   measure: count {type:count}
#
#   dimension: field_to_compare
#   {
#
#     hidden: yes
# #     sql:${age};;
#     sql:null;;
#   }
#
#
#   parameter: max_of_first_tier_parameter {}
#   parameter: min_of_last_tier_parameter {}
#
# #one or the other of these
#   parameter: number_of_tiers_parameter {}
#   parameter: bucket_size_parameter {}
#
#   dimension: max_of_first_tier_dimension {type: number sql:  {{max_of_first_tier_parameter._parameter_value | remove: "'" | times: 1.0 | round:0 }};;}
#   dimension: min_of_last_tier_dimension {type: number sql:  {{min_of_last_tier_parameter._parameter_value | remove: "'" | times: 1.0 | round:0 }};;}
#   dimension: number_of_tiers_dimension {type: number sql:  {{number_of_tiers_parameter._parameter_value | remove: "'" | times: 1.0 | round:0 }};;}
#   dimension: bucket_size_dimension {type: number sql:  {{bucket_size_parameter._parameter_value | remove: "'" | times: 1.0 | round:0 }};;}
#
#
#   dimension: tier_size {
#     type: number
#   sql:
#   {% assign bucket_size_selection = bucket_size_parameter._parameter_value | remove: "'" | times: 1.0 %}
# {% if 0 < bucket_size_selection %}
#   ${bucket_size_dimension}
# {% else %}
#   {% assign min_last = min_of_last_tier_parameter._parameter_value | remove: "'" | times: 1.0 %}--min:{{min_last}}
#   {% assign max_first = max_of_first_tier_parameter._parameter_value | remove: "'"  | times: 1.0 %}
#   {% assign tiers = number_of_tiers_parameter._parameter_value | remove: "'"  | times: 1.0 %}
#   {% assign range_size = min_last | minus: max_first %}--range_size{{range_size}}
#   {% assign intermediate_tiers = tiers | minus: 2 %}
#   {% assign intermediate_tier_size = range_size | divided_by: intermediate_tiers %}--intermediate_tier_size{{intermediate_tier_size}}
#   {{intermediate_tier_size}}
# {% endif %}
#     ;;
#   }
#
#   dimension: field_to_compare_min_and_max{
# #need to add a lot of null checks... negatives checks
#     sql:
#     {% assign max = min_of_last_tier_parameter._parameter_value | remove: "'" | times: 1.0 %}
#     {% assign min = max_of_first_tier_parameter._parameter_value | remove: "'" | times: 1.0 %}
#     {% if max > 0 %}
#       {% if min > 0 %}
#         case when ${field_to_compare} < {{min}} then {{min}}-${tier_size} else case when ${field_to_compare} > {{max}} then {{max}} else ${field_to_compare} end end
#       {% else %}
#         case when ${field_to_compare} > {{max}} then {{max}} else ${field_to_compare} end
#       {% endif %}
#     {% else %}
#       {% if min > 0 %}
#         case when ${field_to_compare} < {{min}} then {{min}} else ${field_to_compare} end
#       {% else %}
#         ${field_to_compare}
#       {% endif %}
#     {% endif %} ;;
#   }
#
#
#   dimension: tiers_from_max_of_first_tier {
#     type: number
#     sql:
#
# floor((
# {% assign min_last = min_of_last_tier_parameter._parameter_value | remove: "'" | times: 1.0 %}
# {% if min_last > 0 %}
#   case when ${field_to_compare_min_and_max}>=${min_of_last_tier_dimension} then ${min_of_last_tier_dimension}+.000000001 else ${field_to_compare_min_and_max} end
# {% else %}
# ${field_to_compare_min_and_max}
# {% endif %}
# -${max_of_first_tier_dimension})*1.0/${tier_size})
# {% if min_last > 0 %}
#   + case when ${field_to_compare_min_and_max}>=${min_of_last_tier_dimension} then 1 else 0 end
# {% endif %}
#
#     ;;
# #     {% if min_last > 0 %}
#     #     floor((${field_to_compare_min_and_max}-${max_of_first_tier_dimension})*1.0/${tier_size})
#   }
#
#   dimension: tier_number {
#     type: number
#     sql:  case when ${tiers_from_max_of_first_tier} <0 then -1
#                 {% assign number_tiers_selection = number_of_tiers_parameter._parameter_value | remove: "'" | times: 1.0 %}
#                 {% if number_tiers_selection > 0 %}
#                 when ${tiers_from_max_of_first_tier} >= ${number_of_tiers_dimension} -2 then ${number_of_tiers_dimension} -2
#                 {% endif %}
#
#           else ${tiers_from_max_of_first_tier}
#           end +2;;
#     html: <span class="label label-info">{{value}}</span>;;
#   }
#
#   dimension: tier_label {
#     type: string
#     sql:
#     case
#       when ${field_to_compare_min_and_max}<${max_of_first_tier_dimension} then '<'|| ${max_of_first_tier_dimension}
#       when ${field_to_compare_min_and_max}>=${min_of_last_tier_dimension} then '>='||${min_of_last_tier_dimension}
#       else round(${max_of_first_tier_dimension}+${tier_size}*(${tier_number}-2),1)||' to '||round(
#         {% assign bucket_size_selection = bucket_size_parameter._parameter_value | remove: "'" | times: 1.0 %}
#         {% if 0 < bucket_size_selection %}
#           case when ${max_of_first_tier_dimension}+${tier_size}*(${tier_number}-1)>${min_of_last_tier_dimension} then ${min_of_last_tier_dimension} else ${max_of_first_tier_dimension}+${tier_size}*(${tier_number}-1) end
#         {% else %}
#           ${max_of_first_tier_dimension}+${tier_size}*(${tier_number}-1)
#         {% endif %}
#       ,1)
#       end
#     ;;
#
#     order_by_field: tier_number
#     html: <span class="label label-info">{{tier_number._value}}</span> {{rendered_value}} ;;
#   }
#
#   measure: range_of_values {
#     type: string
#     sql: min(${field_to_compare})||'-'||max(${field_to_compare}) ;;
#   }
#
# }
