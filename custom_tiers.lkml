######
# Multiple different impementations of custom tiers...
## Open questions/tasks:
## # Can one be built on the other? How to best let an importing project choose between different option sets?
## # File could use some cleanup (4/7).  Still want 'Binary Compare'? etc.


###############
#takes field_to_compare and spits into two groups based on the parameter selection
view: custom_tiers__base {
  dimension: field_to_compare{
    hidden: yes
    sql:null;;
  }
  dimension: tier_number {
    hidden: yes
    type: number
    sql:  1;;
    value_format_name: id
  }
  #the output field that will reflect the custom groups on field_to_compare
  dimension: compare_groups{
#   label: "{% assign to_be_removed = _view._name | append: '.' %}{% assign label = field_to_compare._sql | replace: to_be_removed ,'' %}{% if compare_groups._in_query == false %}Binary Compare On {{label}}{% else %}{{label}} Group{% endif %}"
    label: "{{_view._name | replace: '_',' ' }} - Grouping"
    order_by_field: tier_number
    html: <span class="label label-info">{{tier_number._rendered_value}}</span> {{rendered_value}} ;;
  }
}

############
# Divide the field into a group above and below a parameter based threshold
view: custom_tiers__binary_threshold {
  extends: [custom_tiers__base]
  parameter: binary_cutoff_parameter{
    label: "{{_view._name | replace: '_',' ' }} - Threshold Param"
    type:number
  }
  dimension: tier_number {sql: case when ${field_to_compare}>= {% parameter binary_cutoff_parameter %} then 2 else 1 end ;;}
  dimension: compare_groups{sql:case when ${field_to_compare} >= {% parameter binary_cutoff_parameter %} then '>='||{% parameter binary_cutoff_parameter %} else '< '||{% parameter binary_cutoff_parameter %} end;;}
}

############
# Choose a # of tiers and a # cutoffs
view: custom_tiers__min__max__points_between {
  extends: [custom_tiers__base]

  parameter: compare_cutoffs__min__max__points_between{
    #view_label: "Custom Tiers-{{_view._name}}"
    label: "Define Tiers: Max Tier 1, Min last Tier, # Tiers)"
    description: "Enter a value like '0,100,5' ("
#     suggestions: ["0,100,10","-50,50,3"]
    suggestions: ["Max Tier 1:0,Min last Tier:100,Tiers:5","0,20,3","1,3,5"]
    default_value: "Max Tier 1:0^,Min last Tier:100^,Tiers:5"
    type:string
  }
  dimension: compare_groups{
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
  }
  dimension: tier_number{
    type: number
    hidden: yes
    #view_label: "Custom Tiers-{{_view._name}}"
    description: "Specify Tiers with "
    label: "{% assign to_be_removed = _view._name | append: '.' %}{% assign label = field_to_compare._sql | replace: to_be_removed ,'' %}{% if compare_groups._in_query == false %}Groupings by {{label}}{% else %}{{label}} Group{% endif %} order by"
    suggestions: ["0,100,10","-50,50,3"]
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
case when ${field_to_compare} < {{current_max }} then 1
{% assign current_min = current_max %}
{% assign iterations = number_intermediate_groups %}
{% for i in (1..iterations) %}
{% assign current_max = current_max | plus: group_size %}
{% assign test_max = current_max | plus: half_group_size %}
{% if test_max > max %}
when ${field_to_compare} < {{max}} then {{i | plus: 1 }}
{% assign current_min = max %}
{% else %}
when ${field_to_compare} < {{current_max}} then {{i | plus: 1 }}
{% assign current_min = current_max %}
{% endif %}
{% endfor %}
when ${field_to_compare} >= {{current_min}} then {{number_tiers | plus:2 | round: 0 }}
else null end
  ;;
  }
}

##########
# User chooses a specific bucket size
  view: custom_tiers__by_bucket_size {
  extends: [custom_tiers__base]
  parameter: max_of_first_tier_parameter {}
  parameter: min_of_last_tier_parameter {}
  parameter: bucket_size_parameter {type:number}
  dimension: max_of_first_tier_dimension {
    hidden:yes
    type: number
    sql:  {{max_of_first_tier_parameter._parameter_value | remove: "'" | times: 1.0 | round:0 }};;
  }
  dimension: min_of_last_tier_dimension {
    hidden:yes
    sql:  {{min_of_last_tier_parameter._parameter_value | remove: "'" | times: 1.0 | round:0 }};;
  }
  dimension: bucket_size_dimension {
    hidden:yes
    sql:  {{bucket_size_parameter._parameter_value | remove: "'" | times: 1.0 | round:0 }};;
  }
  dimension: tier_size {
    hidden:yes
    sql:${bucket_size_dimension};;
  }
  dimension: field_to_compare_min_and_max{
    hidden: yes
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
    hidden: yes
    type: number
    sql:
    floor(
      (
      case when ${field_to_compare_min_and_max}>=${min_of_last_tier_dimension}
        then ${min_of_last_tier_dimension}+.000000001
        else ${field_to_compare_min_and_max}
      end
      -${max_of_first_tier_dimension}
      )*1.0/${tier_size}
    )
    ;;
  }
  dimension: tier_number {
    hidden: yes
    type: number
    sql:  case when ${tiers_from_max_of_first_tier} <0 then -1 else ${tiers_from_max_of_first_tier} end +2;;
    html: <span class="label label-info">{{value}}</span>;;
  }
  dimension: compare_groups {
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
    # html: <span class="label label-info">{{tier_number._value}}</span> {{rendered_value}} ;;
  }
#   measure: range_of_values {#was helpful for testing. might be interesting to enable in an extended version, but for now, don't want to clutter the field picker
#     type: string
#     sql: min(${field_to_compare})||'-'||max(${field_to_compare}) ;;
#   }
}

############
# User specifies any number of arbitrary cutoffs in a parameter
  view: custom_tiers__arbitrary_cutoffs {
    extends: [custom_tiers__base]
    parameter: compare_cutoffs__arbitrary{
      #view_label: "Custom Tiers-{{_view._name}}"
      label: "Define Tiers using any number of comma separated breakpoints"
      description: "Define Tiers using any number of comma separated breakpoints"
      suggestions: ["0,10,100","-50,50,150,300"]
      default_value: "0,10,100"
      type:string
    }
    dimension: compare_groups {
      sql:
{% assign my_array = compare_cutoffs__arbitrary._parameter_value | remove: "'" | split: "," %}
{% assign last_group_max_label = '-∞' %}
case
{%for element in my_array%}
  when ${field_to_compare}<{{element}} then '{{last_group_max_label}}< & <{{element}}'
  {% assign last_group_max_label = element %}
{%endfor%}
  when ${field_to_compare}>={{last_group_max_label}} then '>={{last_group_max_label}}'
else 'unknown'
end
      ;;
  }
    dimension: tier_number {
      sql:
{% assign my_array = compare_cutoffs__arbitrary._parameter_value | remove: "'" | split: "," %}
{% assign last_group_max_label = '-∞' %}
{% assign element_counter = 0 %}
case
{%for element in my_array%}
  {% assign element_counter = element_counter | plus: 1 %}
  when ${field_to_compare}<{{element}} then {{element_counter}}
  {% assign last_group_max_label = element %}
{%endfor%}
{% assign element_counter = element_counter | plus: 1 %}
  when ${field_to_compare}>={{last_group_max_label}} then {{element_counter}}
else {{last_group_max_label | plus: 1 }}
end
      ;;
    }
  }
