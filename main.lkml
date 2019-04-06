view: main_view {
  extends: [primary_key_and_counts]
}

view: primary_key_and_counts {
  dimension: primary_key {
    primary_key: yes
    sql: null ;; #extending view must override sql parameter to be the primary_key for that view. (e.g. extending view has dimension: primary_key {sql: ${id};;}}
  }
  measure: count {
    type: sum
    sql: case when ${primary_key} is not null then 1 else null end ;;
  }
  measure: count_distinct {
    type: count_distinct
    sql: ${primary_key};;
  }

}

view: compare_using_cutoff_parameter {
  parameter: compare_cutoff__paramter
  {
    view_label: "Binary Compare"
    type:number
  }
#   dimension: field_to_compare {sql:${latitude};;}
  dimension: field_to_compare
  {
    hidden: yes
    view_label: "Binary Compare"
    sql:null;;#extending view must override sql parameter to be the primary_key for that view. (e.g. extending view has dimension: primary_key {sql: ${id};;}}
  }
  dimension: compare_groups
  {
    view_label: "Binary Compare"
    description: "Choose Cutoff In Binary Compare Filter Field"
    label: "{% assign to_be_removed = _view._name | append: '.' %}{% assign label = field_to_compare._sql | replace: to_be_removed ,'' %}{% if compare_groups._in_query == false %}Binary Compare On {{label}}{% else %}{{label}} Group{% endif %}"
    sql:
    {% assign to_be_removed = _view._name | append: '.' %}
    '{{ field_to_compare._sql | replace: to_be_removed ,'' }}'||' '||case when ${field_to_compare} >= cast({% parameter compare_cutoff__paramter %} as integer) then '>='||{% parameter compare_cutoff__paramter %} else '< '||{% parameter compare_cutoff__paramter %} end
    ;;
  }

  parameter: compare_cutoffs__min__max__points_between
  {
    #view_label: "Custom Tiers-{{_view._name}}"
    label: "Define Tiers: Max Tier 1, Min last Tier, # Tiers)"
    description: "Enter a value like '0,100,5' ("
#     suggestions: ["0,100,10","-50,50,3"]
    suggestions: ["Max Tier 1:0,Min last Tier:100,Tiers:5","0,20,3","1,3,5"]
    default_value: "Max Tier 1:0^,Min last Tier:100^,Tiers:5"
    type:string

  }
  dimension: compare_tiers_groups
  {
    #view_label: "Custom Tiers-{{_view._name}}"
    description: "Choose Cutoff In Binary Compare Filter Field"
#     label: "{% assign label = compare_tiers_label._sql %}{% if _field._in_query == false %}Groupings by {{label}}{% else %}{{label}} Group{% endif %}"
    label: "{{ field_to_compare._sql | split: '/*label:' | last | split: '*/' | first }}"
#     label: "{{compare_tiers_label._sql}}"
#     suggestions: ["0,100,10","-50,50,3"]

#{% assign current_max = min | plus: group_size %}
    sql:
{% assign to_be_removed = _view._name | append: '.' %}
{% assign label = '#' %}
{% assign my_array = compare_cutoffs__min__max__points_between._parameter_value | remove: "'" | split: "," %}
{% assign min = my_array.first | split:"Max Tier 1:" | last | times: 1.0 %}--min:{{min}}
{% assign max = my_array[1] | split:"Min last Tier:" | last | times: 1.0 %}--max:{{max}}
{% assign number_tiers  = my_array.last | split:"Tiers:" | last | times: 1.0 | minus: 2 %}--tiers:{{number_tiers}}
{% assign range = max | minus: min | times:1.0 %}--range:{{range}}
{% assign number_intermediate_groups = number_tiers | times: 1.0 %}--number_intermediate_groups:{{number_intermediate_groups}}
{% assign group_size = range | divided_by: number_intermediate_groups | round: 1 %}--group_size:{{group_size}}
{% assign half_group_size = group_size | divided_by: 2 %}
{% assign current_min = -99999999 %}
{% assign current_max = min %}
case when ${field_to_compare} < {{current_max }} then '1 (-∞ to {{min | round:0 }})'
{% assign current_min = current_max %}
{% assign iterations = number_intermediate_groups %}
{% for i in (1..iterations) %}
    {% assign current_max = current_max | plus: group_size %}
    {% assign test_max = current_max | plus: half_group_size %}
    {% if test_max > max %}
      when ${field_to_compare} < {{max}} then '{{i | plus: 1 }} ({{current_min}} to {{max}})'
      {% assign current_min = max %}
    {% else %}
      when ${field_to_compare} < {{current_max}} then '{{i | plus: 1 }} ({{current_min}} to {{current_max}})'
      {% assign current_min = current_max %}
    {% endif %}
{% endfor %}
      when ${field_to_compare} >= {{current_min}} then '{{number_tiers | plus:2 | round: 0 }} ({{max | round:0 }} to ∞)'
    else 'unkown' end
    ;;
#     order_by_field: compare_tiers_groups_order_by
  }

#   dimension: compare_tiers_label {
#     sql:dynamic tiers;;
#     hidden:yes
#     }

  dimension: compare_tiers_groups_order_by
  {
    type: number
    hidden: yes
    #view_label: "Custom Tiers-{{_view._name}}"
    description: "Specify Tiers with "
    label: "{% assign to_be_removed = _view._name | append: '.' %}{% assign label = field_to_compare._sql | replace: to_be_removed ,'' %}{% if compare_groups._in_query == false %}Groupings by {{label}}{% else %}{{label}} Group{% endif %} order by"
    suggestions: ["0,100,10","-50,50,3"]
    sql:
    {% assign to_be_removed = _view._name | append: '.' %}
    {% assign my_array = compare_cutoffs__min__max__points_between._parameter_value | remove: "'" | split: "," %}
    {% assign min = my_array.first %}--min:{{min}}
    {% assign max = my_array[1] %}--max:{{max}}
    {% assign number_tiers  = my_array.last | times: 1.0 %}--tiers:{{number_tiers}}
    {% assign range = max | minus: min %}--range:{{range}}
    {% assign group_size = range | divided_by: number_tiers | round: 1 %}
    {% assign current_min = -99999999 %}
    {% assign current_max = min | plus: group_size %}case  when ${field_to_compare} < {{current_max }} then 1
    {% assign current_min = current_max %}
    {% assign iterations = number_tiers | minus: 2 %}
    {% for i in (1..iterations) %}
        {% assign current_max = current_max | plus: group_size %}
              when ${field_to_compare} < {{current_max}} then {{i | plus: 1 }}
        {% assign current_min = current_max %}
    {% endfor %}
              when ${field_to_compare} >= {{current_min}} then {{number_tiers | round: 0 }}
    else 999999999 end
        ;;
  }
  #
#   when ${field_to_compare} < cast({{max}} as integer) then 'between' ||{{number_tiers}}
}

explore: main_explore {
  from: main_view
}






view: custom_tiers_by_min_max_and_number_of_tiers {
  sql_table_name: public.users ;;
  dimension: id {primary_key:yes}
  dimension: age {}
  measure: count {type:count}

  dimension: field_to_compare
  {

    hidden: yes
    sql:${age};;#extending view must override sql parameter to be the primary_key for that view. (e.g. extending view has dimension: primary_key {sql: ${id};;}}
  }


  parameter: max_of_first_tier_parameter {}
  parameter: min_of_last_tier_parameter {}

#one or the other of these
  parameter: number_of_tiers_parameter {}
  parameter: bucket_size_parameter {}

  dimension: max_of_first_tier_dimension {type: number sql:  {{max_of_first_tier_parameter._parameter_value | remove: "'" | times: 1.0 | round:0 }};;}
  dimension: min_of_last_tier_dimension {type: number sql:  {{min_of_last_tier_parameter._parameter_value | remove: "'" | times: 1.0 | round:0 }};;}
  dimension: number_of_tiers_dimension {type: number sql:  {{number_of_tiers_parameter._parameter_value | remove: "'" | times: 1.0 | round:0 }};;}
  dimension: bucket_size_dimension {type: number sql:  {{bucket_size_parameter._parameter_value | remove: "'" | times: 1.0 | round:0 }};;}


  dimension: tier_size {
    type: number
  sql:
  {% assign bucket_size_selection = bucket_size_parameter._parameter_value | remove: "'" | times: 1.0 %}
{% if 0 < bucket_size_selection %}
  ${bucket_size_dimension}
{% else %}
  {% assign min_last = min_of_last_tier_parameter._parameter_value | remove: "'" | times: 1.0 %}--min:{{min_last}}
  {% assign max_first = max_of_first_tier_parameter._parameter_value | remove: "'"  | times: 1.0 %}
  {% assign tiers = number_of_tiers_parameter._parameter_value | remove: "'"  | times: 1.0 %}
  {% assign range_size = min_last | minus: max_first %}--range_size{{range_size}}
  {% assign intermediate_tiers = tiers | minus: 2 %}
  {% assign intermediate_tier_size = range_size | divided_by: intermediate_tiers %}--intermediate_tier_size{{intermediate_tier_size}}
  {{intermediate_tier_size}}
{% endif %}
    ;;
  }

  dimension: field_to_compare_min_and_max{
#need to add a lot of null checks... negatives checks
    sql:
    {% assign max = min_of_last_tier_parameter._parameter_value | remove: "'" | times: 1.0 %}
    {% assign min = max_of_first_tier_parameter._parameter_value | remove: "'" | times: 1.0 %}
    {% if max > 0 %}
      {% if min > 0 %}
        case when ${field_to_compare} < {{min}} then {{min}}-${tier_size} else case when ${field_to_compare} > {{max}} then {{max}} else ${field_to_compare} end end
      {% else %}
        case when ${field_to_compare} > {{max}} then {{max}} else ${field_to_compare} end
      {% endif %}
    {% else %}
      {% if min > 0 %}
        case when ${field_to_compare} < {{min}} then {{min}} else ${field_to_compare} end
      {% else %}
        ${field_to_compare}
      {% endif %}
    {% endif %} ;;
  }


  dimension: tiers_from_max_of_first_tier {
    type: number
    sql:

floor((
{% assign min_last = min_of_last_tier_parameter._parameter_value | remove: "'" | times: 1.0 %}
{% if min_last > 0 %}
  case when ${field_to_compare_min_and_max}>=${min_of_last_tier_dimension} then ${min_of_last_tier_dimension}+.000000001 else ${field_to_compare_min_and_max} end
{% else %}
${field_to_compare_min_and_max}
{% endif %}
-${max_of_first_tier_dimension})*1.0/${tier_size})
{% if min_last > 0 %}
  + case when ${field_to_compare_min_and_max}>=${min_of_last_tier_dimension} then 1 else 0 end
{% endif %}

    ;;
#     {% if min_last > 0 %}
    #     floor((${field_to_compare_min_and_max}-${max_of_first_tier_dimension})*1.0/${tier_size})
  }

  dimension: tier_number {
    type: number
    sql:  case when ${tiers_from_max_of_first_tier} <0 then -1
                {% assign number_tiers_selection = number_of_tiers_parameter._parameter_value | remove: "'" | times: 1.0 %}
                {% if number_tiers_selection > 0 %}
                when ${tiers_from_max_of_first_tier} >= ${number_of_tiers_dimension} -2 then ${number_of_tiers_dimension} -2
                {% endif %}

          else ${tiers_from_max_of_first_tier}
          end +2;;
    html: <span class="label label-info">{{value}}</span>;;
  }

  dimension: tier_label {
    type: string
    sql:
    case
      when ${field_to_compare_min_and_max}<${max_of_first_tier_dimension} then '<'|| ${max_of_first_tier_dimension}
      when ${field_to_compare_min_and_max}>=${min_of_last_tier_dimension} then '>='||${min_of_last_tier_dimension}
      else round(${max_of_first_tier_dimension}+${tier_size}*(${tier_number}-2),1)||' to '||round(
        {% assign bucket_size_selection = bucket_size_parameter._parameter_value | remove: "'" | times: 1.0 %}
        {% if 0 < bucket_size_selection %}
          case when ${max_of_first_tier_dimension}+${tier_size}*(${tier_number}-1)>${min_of_last_tier_dimension} then ${min_of_last_tier_dimension} else ${max_of_first_tier_dimension}+${tier_size}*(${tier_number}-1) end
        {% else %}
          ${max_of_first_tier_dimension}+${tier_size}*(${tier_number}-1)
        {% endif %}
      ,1)
      end
    ;;

    order_by_field: tier_number
    html: <span class="label label-info">{{tier_number._value}}</span> {{rendered_value}} ;;
  }

  measure: range_of_values {
    type: string
    sql: min(${age})||'-'||max(${age}) ;;
  }

}
