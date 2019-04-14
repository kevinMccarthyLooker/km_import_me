include: "function_support"
view: profile_dimension {
  extends: [input,output]
  dimension: input {hidden:yes}
  measure: output_measure {
    view_label: "dimension_profiling"
    group_label: "dimension_profiling"
    hidden: no
    type: string
    sql:
    count(*)-count(${input})||' nulls of '||count(*)||' query rows |'||
    count(distinct ${input})||' distinct values between '||min(${input})||' & '||max(${input})
    ;;
# statistical functions,etc.
html:<div align:"top">{{value | replace: '|','<br>'}}</div>;;#line breaks in html
  }
}

view: profile_dimension__number {
  extends: [profile_dimension]
#   dimension: source_view {sql:${users.SQL_TABLE_NAME};;}
  dimension: input {sql:;;}
  dimension: is_number {sql:true;;}
  measure: output_measure {
    sql:
    ${EXTENDED}
    {% if is_number._sql == 'true' %}
    ||' |'
    ||'sum:'||sum(${input})||' & '||'sum distinct:'||sum(distinct ${input})||' |'
    ||'avg:'||avg(${input})||' & '||'avg distinct:'||avg(distinct ${input})
    {% endif %}
    ;;
  }
}
