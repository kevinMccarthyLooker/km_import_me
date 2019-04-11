include: "function_support"
view: tooltipify {
  extends: [output]
  measure: my_measure {
    type: number
  }
  measure: tooltip_for_my_measure {
    type: number
  }
  measure: output_measure {
    hidden: no
    type: number
    sql: ${my_measure} ;;
    html: {{my_measure._rendered_value}}<br>({{tooltip_for_my_measure._rendered_value}}) ;;
  }
}

view: tooltipify_with_on_off_toggle {
  extends: [tooltipify]
  parameter: show_tooltip {
    type: yesno
    default_value: "Yes"
  }

  measure: output_measure {
    required_fields: [my_measure,tooltip_for_my_measure]
    type: number
    sql: ${my_measure} ;;
    html:
    {% assign hide = true %}
    {%if show_tooltip._parameter_value == 'true' %}{% assign hide = false %}{%endif%}
    {{my_measure._rendered_value}}{%if hide == true %}{%else%}<br>({{tooltip_for_my_measure._rendered_value}}){%endif%}
    ;;
  }
  # {{my_measure._rendered_value}}{%if show_tooltip._parameter_value == false %}{%else%}<br>({{tooltip_for_my_measure._rendered_value}}){%endif%}

#       {{show_tooltip._parameter_value}}
#     {%if show_tooltip._parameter_value == true %}true{%endif%}
#     {%if show_tooltip._parameter_value == 'true' %}'true'{%endif%}
#     {{tooltip_for_my_measure.value}}
}
