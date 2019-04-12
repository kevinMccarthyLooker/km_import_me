include: "function_support"
view: profile_dimension {
  extends: [parse_input,output]
  dimension: input {
    hidden: no
    sql: ;;
  }
  parameter: t {
    default_value: "t"
    allowed_value: {value:"t" label:"t"}

  }
  measure: output_measure {
    view_label: "dimension_profiling"
    group_label: "dimension_profiling"
    hidden: no
    type: string
# sql:'query rows:'||count(*)||
# ' |not null:'||count(${input})||
# ' |distinct:'||count(distinct ${input})||
# ' |min:'||min(${input})||
# ' |max:'||max(${input});;
# # ||'sum:'||sum(${input})
# # 'AVG:'||AVG(${input})||
# # 'AVG distinct:'||AVG(distinct ${input})||
# # statistical functions,etc.
    sql:
    count(*)-count(${input})||' nulls of '||count(*)||' query rows |'||
    count(distinct ${input})||' distinct values between '||min(${input})||' & '||max(${input})
    --||(select count(*) from public.users)
    ;;
# ||'sum:'||sum(${input})
# 'AVG:'||AVG(${input})||
# 'AVG distinct:'||AVG(distinct ${input})||
# statistical functions,etc.
# html:
# <div>
# <pre>
# No space
#  One space
#       Six spaces
#   One tab
# {{value | replace: '|','<br>'}}
#     Two tabs
# </pre>
# </div>
# <div align:"top">{{value | replace: '|','<br>'}}</div>;;
html:
<div align:"top">{{value | replace: '|','<br>'}}</div>;;
  }
}
