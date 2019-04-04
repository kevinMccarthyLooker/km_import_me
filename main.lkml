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
    label: "Define Groups. Like 0,100,5 (min, max, and # Groups)"
    description: "value like '0,50,5' "
    suggestions: ["0,100,10","-50,50,3"]
    default_value: "default:0,100,10"
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
{% assign min = my_array.first | times: 1.0 %}--min:{{min}}
{% assign max = my_array[1] | times: 1.0 %}--max:{{max}}
{% assign number_tiers  = my_array.last | times: 1.0 %}--tiers:{{number_tiers}}
{% assign range = max | minus: min %}--range:{{range}}
{% assign number_intermediate_groups = number_tiers %}
{% assign group_size = range | divided_by: number_intermediate_groups | round: 0.1 %}--group_size:{{group_size}}
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
      when ${field_to_compare} < {{current_max}} then '{{i | plus: 1 }} ({{current_min}} to {{max}})'
    {% else %}
      when ${field_to_compare} < {{current_max}} then '{{i | plus: 1 }} ({{current_min}} to {{current_max}})'
    {% endif %}
    {% assign current_min = current_max %}
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
