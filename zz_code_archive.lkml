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

# view: id_over_age{
#   view_label: "Users"
#   extends:[safe_divide,input_unhidden]
#   dimension: input {sql:${users.id}^^${users.age};;}
# #   dimension: output {view_label:"{{_view._name}} {{users.age._field}}"}
# #   dimension: output {view_label:"Users" value_format_name: decimal_2} # label: "[Override Default Label (this extending view's name)]"
# }
# explore: users__for_functions {
#   from: users
#   view_name: users
#   join: id_over_age {sql:;; relationship: one_to_one}
# }


#^^^^^ old examples of invoking functions



# view: custom_tiers_by_min_max_and_number_of_tiers_old {
#   extends: [custom_tiers__base]
# #   sql_table_name: public.users ;;
# #   dimension: id {primary_key:yes}
# #   dimension: age {}
# #   measure: count {type:count}
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
#     sql:
#       {% assign bucket_size_selection = bucket_size_parameter._parameter_value | remove: "'" | times: 1.0 %}
#     {% if 0 < bucket_size_selection %}
#       ${bucket_size_dimension}
#     {% else %}
#       {% assign min_last = min_of_last_tier_parameter._parameter_value | remove: "'" | times: 1.0 %}--min:{{min_last}}
#       {% assign max_first = max_of_first_tier_parameter._parameter_value | remove: "'"  | times: 1.0 %}
#       {% assign tiers = number_of_tiers_parameter._parameter_value | remove: "'"  | times: 1.0 %}
#       {% assign range_size = min_last | minus: max_first %}--range_size{{range_size}}
#       {% assign intermediate_tiers = tiers | minus: 2 %}
#       {% assign intermediate_tier_size = range_size | divided_by: intermediate_tiers %}--intermediate_tier_size{{intermediate_tier_size}}
#       {{intermediate_tier_size}}
#     {% endif %}
#         ;;
#   }
#
#   dimension: field_to_compare_min_and_max{
# #need to add a lot of null checks... negatives checks
#   sql:
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
# }
#
#
# dimension: tiers_from_max_of_first_tier {
#   type: number
#   sql:
#
#   floor((
#   {% assign min_last = min_of_last_tier_parameter._parameter_value | remove: "'" | times: 1.0 %}
#   {% if min_last > 0 %}
#     case when ${field_to_compare_min_and_max}>=${min_of_last_tier_dimension} then ${min_of_last_tier_dimension}+.000000001 else ${field_to_compare_min_and_max} end
#   {% else %}
#   ${field_to_compare_min_and_max}
#   {% endif %}
#   -${max_of_first_tier_dimension})*1.0/${tier_size})
#   {% if min_last > 0 %}
#     + case when ${field_to_compare_min_and_max}>=${min_of_last_tier_dimension} then 1 else 0 end
#   {% endif %}
#
#       ;;
#   #     {% if min_last > 0 %}
#       #     floor((${field_to_compare_min_and_max}-${max_of_first_tier_dimension})*1.0/${tier_size})
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


# view: age_widget_view {extends: [compare_using_cutoff_parameter] dimension: field_to_compare {sql:${users.age};;}}
# view: latitude_widget_view {extends: [compare_using_cutoff_parameter] dimension: field_to_compare {sql:${users.latitude};;}}
# view: item_sale_price_custom_tiers {extends: [compare_using_cutoff_parameter] dimension: field_to_compare {sql:${order_items.sale_price};;}}
# view: item_sale_price_custom_tiers_by_min_max_and_number_of_tiers {extends: [custom_tiers_by_min_max_and_number_of_tiers] dimension: field_to_compare {sql:${order_items.sale_price};;}}
# view: age_conditionally_formatted{extends:[conditionally_format__field_number__threshold_number] dimension:input{sql:${users.age}^^{% parameter users.pass_parameter_value_test %};;}}
#   join: age_widget_view {relationship: one_to_one sql:;;}
#   join: latitude_widget_view {relationship: one_to_one sql:;;}
#   join: item_sale_price_custom_tiers {relationship: one_to_one sql:;;}
#   join: item_sale_price_custom_tiers_by_min_max_and_number_of_tiers {sql:;; relationship: one_to_one}
#   join: age_conditionally_formatted {sql:;; relationship: one_to_one}

#this older format used a single input field and parsed that input
# view: age_conditionally_formatted{extends:[conditionally_format__field_number__threshold_number]
# #   dimension:input{sql:${users.age}^^${latitude_widget_view.compare_tiers_groups};;}
#   dimension:input{sql:${users.age}^^${latitude_widget_view.compare_groups};;}
# #   dimension:threshold{sql:${latitude_widget_view.compare_tiers_groups};;}
#   dimension:threshold{sql:${users.latitude};;}
# }


# # view: min_maxify_dimension__age__25__58{extends:[min_maxify_dimension] measure:measure_input {sql:${users.age}^^25^^58;;}}
# # view: min_maxify_dimension__age__25__43{extends:[min_maxify_dimension] measure:measure_input {sql:${min_maxify_dimension__age__25__58.output}^^25^^43;;}}
# # view: min_maxify_3{extends:[min_maxify_dimension] measure:measure_input {sql:${min_maxify_dimension__age__25__58.output}^^30^^40;;}}
# # view: min_maxify_4{extends:[min_maxify_dimension2] dimension: min{sql:35;;} dimension:max{sql:45;;} dimension:field{sql:${users.age};;}}
# join: count_conditionally_formatted {sql:;; relationship: one_to_one}
# join: acronymize2 {sql:;; relationship: one_to_one}
# #   join: min_maxify_dimension__age__25__58 {sql:;; relationship: one_to_one}
# #   join: min_maxify_dimension__age__25__43 {sql:;; relationship: one_to_one}
# #   join: min_maxify_3 {sql:;; relationship: one_to_one}
# #   join: min_maxify_4 {sql:;; relationship: one_to_one}


# view: count_conditionally_formatted{extends:[conditionally_format__field_number__threshold_number] dimension:input{sql:'a'^^10000;;} measure:measure_input{sql:${users.count};;}}
# view: acronymize2 {extends:[acronymize] measure:measure_input {sql:'Test'^^'another test'^^'Tax';;}dimension:output{view_label:"Users"}}


# view: user_age_30_to_latitude{extends:[min_maxify_dimension]
#   view_label: "Users"
#   dimension:input_min{sql:30;;}
#   dimension:input_max{sql:${users.latitude};;}
#   dimension:input_field{sql:${users.age};;}
#   dimension:output {label: "{{_view._name | replace: '_',' ' }}"}#override output field here, otherwise it will appear using the view name
# }
# join: user_age_30_to_latitude {sql:;; relationship: one_to_one}
# join: user_age_30_to_40 {sql:;; relationship: one_to_one}
# join: user_age_30_to_param {sql:;; relationship: one_to_one}


##old emojis html code
# view: emojis_percent {
#   extends: [input,output,emojis]
#   measure: output_measure {
#   hidden: no
#   sql: ${measure_input} ;;
#   html:
#   <div style="font-size:12px;">
#       {% assign break = 10 %}
#       {% assign break_counter = 0 %}
#       {% assign cell_break = 10 %}
#       {% assign cell_break_counter = 0 %}
#       {% for num in (1..100) %}
#   {% assign integer_representation = value | times: 100 %}
#
#   {% if num <= integer_representation %}
#   <span style="background-color:#a4f442;">😀</span>
#   {% else %}
#   <span style="background-color:#f47741;">😡</span>
#   {% endif %}
#        {% assign break_counter = break_counter | plus: 1 %}
#        {% if break_counter >= break %}
#           <br>
#           {% assign break_counter = 0 %}
#           {% assign cell_break_counter = cell_break_counter | plus: 1 %}
#             {% if cell_break_counter >= cell_break %}
#               <br>
#               {% assign cell_break_counter = 0 %}
#             {% endif %}
#         {% endif %}
#       {% endfor %}
#   </div>
#       ;;
#   }
# }


#old nps - dimension based stuff
#   dimension: promoters {hidden:yes}
#   dimension: detractors {hidden:yes}
#   dimension: neutrals {hidden:yes}
#   dimension: output {
#     type: number
#     sql:round(100*(${promoters}-${detractors})*1.0/nullif((${promoters}+${detractors}+${neutrals}),0));;
#
#
# # html:
# # {%assign promos = promoters._value %}
# # {%assign detracts = detractors._value %}
# # {%assign neuts = neutrals._value %}
# # {%assign min_promos_detractors = promos %}
# # {%if min_promos_detractors > detracts %}
# #   {%assign min_promos_detractors = detracts %}
# # {%endif%}
# # {% assign remaining_promos = promos | minus: min_promos_detractors %}
# # {%if remaining_promos < 0 %}
# #   {%assign remaining_promos = 0 %}
# # {%endif%}
# # {% assign remaining_detracts = detracts | minus: min_promos_detractors %}
# # {%if remaining_detracts < 0 %}
# #   {%assign remaining_detracts = 0 %}
# # {%endif%}
# # <span style="background-color:DarkGray;">{% for i in (1..min_promos_detractors) %}😀😡|{% endfor %}{% for i in (1..neuts) %}🤖{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
# # <br>
# # <br>
# # <span style="background-color:Green;">{% for i in (1..remaining_promos) %}😀{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
# # <span style="background-color:Red;">{% for i in (1..remaining_detracts) %}😡{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
# # ;;
#     html:
#     {%assign promos = promoters._value %}
#     {%assign detracts = detractors._value %}
#     {%assign neuts = neutrals._value %}
#     {%assign min_promos_detractors = promos %}
#     {%if min_promos_detractors > detracts %}
#     {%assign min_promos_detractors = detracts %}
#     {%endif%}
#     {% assign remaining_promos = promos | minus: min_promos_detractors %}
#     {%if remaining_promos < 0 %}
#     {%assign remaining_promos = 0 %}
#     {%endif%}
#     {% assign remaining_detracts = detracts | minus: min_promos_detractors %}
#     {%if remaining_detracts < 0 %}
#     {%assign remaining_detracts = 0 %}
#     {%endif%}
#     Net: ({{promos| round}} - {{detracts | round}}) / {{promos | plus: detracts | plus: neuts | round}} = {{rendered_value}}<br>
#     <span style="background-color:Green;">{% for i in (1..remaining_promos) %}😀{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
#     <span style="background-color:Red;">{% for i in (1..remaining_detracts) %}😡{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
#     <br>
#     <span style="background-color:DarkGray;">{% for i in (1..min_promos_detractors) %}😀😡|{% endfor %}{% for i in (1..neuts) %}🤖{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
#     ;;
# # {{promos}}
# # {{detracts}}
# # {{neuts}}
# # -
# # {{remaining_promos}}
# # -
# # {{remaining_detracts}}
# }
# html:
# {%assign promos = promoters._value %}
# {%assign detracts = detractors._value %}
# {%assign neuts = neutrals._value %}
# {%assign min_promos_detractors = promos %}
# {%if min_promos_detractors > detracts %}
#   {%assign min_promos_detractors = detracts %}
# {%endif%}
# {% assign remaining_promos = promos | minus: min_promos_detractors %}
# {%if remaining_promos < 0 %}
#   {%assign remaining_promos = 0 %}
# {%endif%}
# {% assign remaining_detracts = detracts | minus: min_promos_detractors %}
# {%if remaining_detracts < 0 %}
#   {%assign remaining_detracts = 0 %}
# {%endif%}
# <span style="background-color:DarkGray;">{% for i in (1..min_promos_detractors) %}😀😡|{% endfor %}{% for i in (1..neuts) %}🤖{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
# <br>
# <br>
# <span style="background-color:Green;">{% for i in (1..remaining_promos) %}😀{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
# <span style="background-color:Red;">{% for i in (1..remaining_detracts) %}😡{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
# ;;
#this version tries to highlight the net by pairing promoters and detracters
#     html:
#     <div align="left">
#     {%assign promos = promoters_measure._value %}
#     {%assign detracts = detractors_measure._value %}
#     {%assign neuts = neutrals_measure._value %}
#     {%assign min_promos_detractors = promos %}
#     {%if min_promos_detractors > detracts %}
#     {%assign min_promos_detractors = detracts %}
#     {%endif%}
#     {% assign remaining_promos = promos | minus: min_promos_detractors %}
#     {%if remaining_promos < 0 %}
#     {%assign remaining_promos = 0 %}
#     {%endif%}
#     {% assign remaining_detracts = detracts | minus: min_promos_detractors %}
#     {%if remaining_detracts < 0 %}
#     {%assign remaining_detracts = 0 %}
#     {%endif%}
#     <span style="background-color:Green;">{% for i in (1..remaining_promos) %}😀{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
#     <span style="background-color:Red;">{% for i in (1..remaining_detracts) %}😡{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
#     <br>
#     <span style="background-color:DarkGray;">{% for i in (1..min_promos_detractors) %}😀😡|{% endfor %}{% for i in (1..neuts) %}🤖{%assign mod = i | modulo: 2 %}{%if mod == 0 %}|{%endif%}{% endfor %}</span>
#     </div>
#     ;;
#at one point had background colors like:
#  style="background-color:#white;"
#  style="background-color:##b55656;"
#  style="background-color:#929292;"

#replaced with a separate field
#     Net: ({{promos| round}} - {{detracts | round}}) / {{promos | plus: detracts | plus: neuts | round}} = {{rendered_value}}<br>

# {{promos}}
# {{detracts}}
# {{neuts}}
# -
# {{remaining_promos}}
# -
# {{remaining_detracts}}

#old acronymize based on parsed sql
#     sql:
#     {% assign v = parsed_input1._sql | size%}{% if v > 0  %}(left(${parsed_input1},1)){% endif %}
#     {% assign v = parsed_input2._sql | size%}{% if v > 0  %}||(left(${parsed_input2},1)){% endif %}
#     {% assign v = parsed_input3._sql | size%}{% if v > 0  %}||(left(${parsed_input3},1)){% endif %}
#     {% assign v = parsed_input4._sql | size%}{% if v > 0  %}||(left(${parsed_input4},1)){% endif %}
#     ;;

# view: min_maxify_dimension {
#   extends: [input,output]
#   dimension: output {
# sql:
# case when ${input1_dimension}<${input2_dimension}
#   then ${input2_dimension}
#   else
#     case
#     when ${input1_dimension}>${input3_dimension}
#       then ${input3_dimension}
#     else ${input1_dimension}
#     end
# end
# ;;
#   }
# }


#old confitional formatting code
#   dimension: parsed_input2_no_parens {
#     hidden: yes
#     #removes the first and last characters where we've added parens
#     sql:
#     {% assign sql = parsed_input2._sql %}
#     {% assign sql = sql | slice: 1,sql.size %}
#     {% assign sql = sql | split: "" | reverse | join: "" %}
#     {% assign sql = sql | slice: 1,sql.size %}
#     {% assign sql = sql | split: "" | reverse | join: "" %}
#     {{ sql }} ;;
#   }
#   measure:  parsed_measure_input {
#     hidden: yes
#     type: number
#     html:
#     {% assign threshold = parsed_input2_no_parens._sql | times: 1.0 %}
#     <div align="center" style="width:100%; color:white; background:{% if value > threshold %}green{% else %}black{% endif %};">{% if value > threshold %} >1{% else %} not >1{% endif %}</div> ;;
#     required_fields: [parsed_input2]
# #     html: {{value}} - {{parsed_input2_no_parens._sql}};;
#   }


#old confitional formatting that used dimensions
# view: conditionally_format__field_number__threshold_number {
#   extends: [input,output]
#
#   dimension: threshold {
#     hidden:yes
#     sql:0;;
#   }
#   dimension: meets_threshold {
#     hidden: yes
#     type: number
#     #sql: case when ${parsed_input1}>=${parsed_input2} then 1 else 0 end;;
#     sql: case when ${input}>=${threshold} then 1 else 0 end;;
#   }
#   measure: max_meets_threshold {
#     hidden: yes
#     label: "😁 or 😡(max_meets_threshold)"
#     type: max
#     sql: ${meets_threshold} ;;
#     html: <div align="center" style="width:100%; color:white; background:{% if value == 1 %}green{% else %}black{% endif %};">{% if value == 1 %} 😁{% else %} 😡{% endif %}</div> ;;
#   }
#   measure: min_meets_threshold {
#     hidden: yes
#     label: "😁 or 😡(min_meets_threshold)"
#     type: min
#     sql: ${meets_threshold} ;;
#     html: <div align="center" style="width:100%; color:white; background:{% if value == 1 %}green{% else %}black{% endif %};">{% if value == 1 %} 😁{% else %} 😡{% endif %}</div> ;;
#   }
#   dimension: output {
#     sql: ${input} ;;
#     #sql: case when ${parsed_input1}>=${parsed_input2} then 'meets' else 'doesnt meet' end ;;
#     html: <div align="center" style="width:100%; color:white; background:{% if meets_threshold._value == 1 %}green{% else %}black{% endif %};">{{rendered_value}}{% if meets_threshold._value == 1 %} 😁{% else %} 😡{% endif %}</div> ;;
#     type: number
#   }
# }


#old parse input code:
#   measure: measure_input_sql_holder {
#     hidden: yes
# #     type: string
#     sql: 0/*${measure_input}*/ ;;
#   }
# # dimension: parsed_input1 {sql:{% assign my_array = input_sql_holder._sql | replace: '0/*','(' | remove: '*/' | replace: '^^',')' %}{{my_array[0]}};; required_fields: [input_sql_holder]}
# # dimension: parsed_input1 {sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: ')*/' | split: '^^' %}{{my_array[0]}};; required_fields: [input_sql_holder]}
#
#   dimension: parsed_input1 {hidden: yes sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[0] }}{% assign my_array = measure_input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[0] }};; required_fields: [input_sql_holder,measure_input_sql_holder]}
#   dimension: parsed_input2 {hidden: yes sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[1] }}{% assign my_array = measure_input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[1] }};; required_fields: [input_sql_holder,measure_input_sql_holder]}
#   dimension: parsed_input3 {hidden: yes sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[2] }}{% assign my_array = measure_input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[2] }};; required_fields: [input_sql_holder,measure_input_sql_holder]}
#   dimension: parsed_input4 {hidden: yes sql:{% assign my_array = input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[3] }}{% assign my_array = measure_input_sql_holder._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[3] }};; required_fields: [input_sql_holder,measure_input_sql_holder]}
# #}^^^
#   dimension: input1_dimension {hidden: yes sql:(${parsed_input1});;}#wrap in parens to ensure correct calculations on ratios, etc.
#   dimension: input2_dimension {hidden: yes sql:(${parsed_input2});;}
#   dimension: input3_dimension {hidden: yes sql:(${parsed_input3});;}
#   dimension: input4_dimension {hidden: yes sql:(${parsed_input4});;}
#
#   measure: input1_measure {hidden: yes sql:(${parsed_input1});;}#wrap in parens to ensure correct calculations on ratios, etc.
#   measure: input2_measure {hidden: yes sql:(${parsed_input2});;}
#   measure: input3_measure {hidden: yes sql:(${parsed_input3});;}
#   measure: input4_measure {hidden: yes sql:(${parsed_input4});;}

#   measure: parsed_measure_input {sql:{% assign my_array = measure_input_sql._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[0] | prepend: '(' | append: ')'}};; required_fields: [measure_input_sql]}
#
#   measure: parsed_measure_input1_sql {sql:{% assign my_array = measure_input_sql._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[0]}};; required_fields: [measure_input_sql]}
#   measure: parsed_measure_input1_measure {sql:{{ parsed_measure_input1_sql._sql | prepend: '(' | append: ')' }};; required_fields: [measure_input_sql]}
#
#
#   dimension: parsed_measure_input1_sql_as_dimension{sql:{% assign my_array = measure_input_sql._sql | remove: '0/*(' | remove: '0/*' | remove: ')*/' | remove: '*/' | split: '^^' %}{{my_array[0]}};; required_fields: [measure_input_sql]}

#   dimension: parsed_input1    {group_label:"{{_view._name}}(hidden fields)" hidden:no}
#   dimension: parsed_input2    {group_label:"{{_view._name}}(hidden fields)" hidden:no}
#   dimension: parsed_input3    {group_label:"{{_view._name}}(hidden fields)" hidden:no}
#   dimension: parsed_input4    {group_label:"{{_view._name}}(hidden fields)" hidden:no}
#   dimension: input1_dimension {group_label:"{{_view._name}}(hidden fields)" hidden:no}
#   dimension: input2_dimension {group_label:"{{_view._name}}(hidden fields)" hidden:no}
#   dimension: input3_dimension {group_label:"{{_view._name}}(hidden fields)" hidden:no}
#   dimension: input4_dimension {group_label:"{{_view._name}}(hidden fields)" hidden:no}
#   measure: input1_measure     {group_label:"{{_view._name}}(hidden fields)" hidden:no}
#   measure: input2_measure     {group_label:"{{_view._name}}(hidden fields)" hidden:no}
#   measure: input3_measure     {group_label:"{{_view._name}}(hidden fields)" hidden:no}
#   measure: input4_measure     {group_label:"{{_view._name}}(hidden fields)" hidden:no}


#old custom tiers code:
#     sql:
#     {% assign to_be_removed = _view._name | append: '.' %}
#     {% assign my_array = compare_cutoffs__min__max__points_between._parameter_value | remove: "'" | split: "," %}
#     {% assign min = my_array.first %}--min:{{min}}
#     {% assign max = my_array[1] %}--max:{{max}}
#     {% assign number_tiers  = my_array.last | times: 1.0 %}--tiers:{{number_tiers}}
#     {% assign range = max | minus: min %}--range:{{range}}
#     {% assign group_size = range | divided_by: number_tiers | round: 1 %}
#     {% assign current_min = -99999999 %}
#     {% assign current_max = min | plus: group_size %}case  when ${field_to_compare} < {{current_max }} then 1
#     {% assign current_min = current_max %}
#     {% assign iterations = number_tiers | minus: 2 %}
#     {% for i in (1..iterations) %}
#         {% assign current_max = current_max | plus: group_size %}
#               when ${field_to_compare} < {{current_max}} then {{i | plus: 1 }}
#         {% assign current_min = current_max %}
#     {% endfor %}
#               when ${field_to_compare} >= {{current_min}} then {{number_tiers | round: 0 }}
#     else 999999999 end
#         ;;

#at one point had an unhidden thing for testing


#use this version to keep fields hidden. The unhidden version can be used for testing
# view: input_unhidden {
#   extends: [input]
#   dimension: input            {group_label:"{{_view._name}}(hidden fields)" hidden:no}
#   dimension: input_sql_holder {group_label:"{{_view._name}}(hidden fields)" hidden:no}
#   measure: measure_input {hidden: yes}
# }
# view: min_maxify_dimension_unhidden {
#   extends: [ min_maxify_dimension]
#   dimension: input_field  {hidden: no group_label:"{{_view._name}}(hidden fields)"}
#   dimension: input_min    {hidden: no group_label:"{{_view._name}}(hidden fields)"}
#   dimension: input_max    {hidden: no group_label:"{{_view._name}}(hidden fields)"}
#   dimension: output       {hidden: no group_label:"{{_view._name}}(hidden fields)"}
# }


#was trying to find a way to set a good default view label
#   dimension: view_label__sql_placeholder_input {sql:'default';;}
#   dimension: view_label__sql_placeholder {
#     type: string
#     required_fields: [view_label__sql_placeholder_viewer]
#     sql: ''/*{{ view_label__sql_placeholder_input._sql | replace: '_',' ' }}*/ ;;
#
#   }
#   dimension: view_label__sql_placeholder_viewer {
#     required_fields: [view_label__sql_placeholder]
#     sql: ${view_label__sql_placeholder};;
#   }


#     html:
#     {% assign n = number_iterations._value %}
#     {% assign break = final_emojis_per_row._sql | times: 1.0 %}
#     {% assign break_counter = 0 %}
#     {% assign cell_break = final_break_every_x_rows._sql | times: 1.0 %}
#     {% assign cell_break_counter = 0 %}
#     {% for num in (1..n) %}
# {{final_emoji._sql}}
#      {% assign break_counter = break_counter | plus: 1 %}
#      {% if break_counter >= break %}
#         <br>
#         {% assign break_counter = 0 %}
#         {% assign cell_break_counter = cell_break_counter | plus: 1 %}
#           {% if cell_break_counter >= cell_break %}
#             <br>
#             {% assign cell_break_counter = 0 %}
#           {% endif %}
#       {% endif %}
#     {% endfor %}
#     </tr>
#     </table>
#     ;;

#was interested in using this formatting...
# html:
# <pre>
# No space
#  One space
# </pre>


#old example min_maxify
########
# view: user_age_30_to_40{
#   extends:[min_maxify_dimension]
#   dimension: input_min    {sql:30;;}
#   dimension: input_max    {sql:40;;}
#   dimension: input_field  {sql:${users.age};;}
#   dimension: output {
#     #override output format here. Otherwise it will appear using the view name.
#     label: "{{_view._name | replace: '_',' ' }}"
#     view_label: "Users"
#   }
# }
# view: user_age_30_to_param{
#   extends:[min_maxify_dimension]
#   dimension: input_min    {sql:30;;}
#   dimension: input_max    {sql:{% parameter integer_input_test %};;}
#   dimension: input_field  {sql:${users.age};;}
#   dimension: output {
#     #override output format here. Otherwise it will appear using the view name.
#     label: "{{_view._name | replace: '_',' ' }}"
#     view_label: "Users"
#   }
# }
