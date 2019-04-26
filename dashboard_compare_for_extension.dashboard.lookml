- dashboard: compare_group_dashboard_for_extension
  title: Compare Group Dashboard For Extension
  layout: newspaper
  elements:
  - title: Pie Chart
    name: Pie Chart
    model: compare_one_to_group_dashboard
    explore: compare_dashboard
    type: looker_pie
    fields: [compare_input.dimension_with_value_vs_other, compare_input.input_measure]
    sorts: [compare_input.input_measure desc]
    limit: 500
    query_timezone: America/New_York
    series_types: {}
    row: 0
    col: 16
    width: 8
    height: 6
  - title: Single Record Comparison
    name: Single Record Comparison
    model: compare_one_to_group_dashboard
    explore: compare_dashboard
    type: looker_single_record
    fields: [compare_input.dimension_with_value_vs_other, compare_input.input_measure]
    sorts: [compare_input.input_measure desc]
    limit: 500
    query_timezone: America/New_York
    series_types: {}
    row: 6
    col: 0
    width: 8
    height: 6
