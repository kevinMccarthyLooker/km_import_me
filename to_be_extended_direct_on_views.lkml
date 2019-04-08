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
  measure: primary_key_range {
    type: string
    sql: min(${primary_key})||' to '||max(${primary_key});;
  }
}
