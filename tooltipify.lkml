include: "function_support"
view: tooltipify {
  extends: [output]
  measure: my_measure {
    hidden:yes
    type: number
  }
  measure: tooltip_for_my_measure {
    hidden:yes
    type: number
  }
  measure: output_measure {
    view_label: "{{_view._name | replace: '_',' ' }}"
    hidden: no
    type: number
    sql: ${my_measure} ;;
    html: {{my_measure._rendered_value}}<br>({{tooltip_for_my_measure._rendered_value}}) ;;
  }
}

view: tooltipify_with_on_off_toggle {
  extends: [tooltipify]
  parameter: show_tooltip {
    view_label: "{{_view._name | replace: '_',' ' }}"
    #unquoted with value yes makes the presence of the parameter itself the toggle
    type: unquoted
    allowed_value: {value:"Yes"}
  }
  measure: output_measure {
    required_fields: [my_measure,tooltip_for_my_measure]
    type: number
    sql: ${my_measure} ;;
    html:
    {% assign hide = true %}
    {%if show_tooltip._parameter_value == 'Yes' %}{% assign hide = false %}{%endif%}
    {{my_measure._rendered_value}}{%if hide == true %}{%else%}<br>({{tooltip_for_my_measure._rendered_value}}){%endif%}
    ;;
  }
}
