include: "function_support"
view: nps {
  measure: promoters_measure {hidden:yes}
  measure: detractors_measure {hidden:yes}
  measure: neutrals_measure {hidden:yes}
  measure: output_measure_explanation {
    label: "NPS Explanation"
    type:string
    sql:'Net: ('||${promoters_measure}||' - '||${detractors_measure}||') / '||${promoters_measure}||' + '||${neutrals_measure}||' = '||${output_measure};;
  }
  measure: output_measure {
    label: "NPS Custom HTML"
    type: number
    sql:
    round(100*(${promoters_measure}-${detractors_measure})*1.0/nullif((${promoters_measure}+${detractors_measure}+${neutrals_measure}),0))
    ;;
    html:
    <div align="left">
    {%assign promos = promoters_measure._value %}
    {%assign detracts = detractors_measure._value %}
    {%assign neuts = neutrals_measure._value %}
    {%assign mod_detracts = 0 %}
    <span>{% for i in (1..promos) %}😀{%assign mod_promos = i | modulo: 10 %}{%if mod_promos == 0 %}|{%endif%}{% endfor %}</span>
    <br>
    <span>{% for i in (1..detracts) %}😡{%assign mod_detracts = i | modulo: 10 %}{%if mod_detracts == 0 %}|{%endif%}{% endfor %}</span><span>{% for i in (1..neuts) %}🤖{%assign mod_neuts = i | plus: mod_detracts | modulo: 10 %}{%if mod_neuts == 0 %}|{%endif%}{% endfor %}</span>
    </div>
    ;;
  }
}
