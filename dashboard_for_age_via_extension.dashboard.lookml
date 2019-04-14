- dashboard: dashboard_for_age_via_extension
  title: dashboard_for_age_via_extension
  extends: dashboard_to_be_extended
#   layout: newspaper
  elements:
  - name: Change from Prior Week
#     title: Change from Prior Week
#     model: import_test_model
    explore: users_for_dynamic_lookml_dashboard_block_demo2
#     type: single_value
#     fields: [dashboard_select_fields_age.for_dashboard_count, dashboard_select_fields_age.count_per_week,
#       dashboard_select_fields_age.weeks_ago_special_for_pivot_label, dashboard_select_fields_age.weeks_ago]
#     sorts: [dashboard_select_fields_age.weeks_ago_special_for_pivot_label]
  - name: Total Last Week vs Yr Prior
    explore: users_for_dynamic_lookml_dashboard_block_demo2
  - name: Date Explanation / Validation
    explore: users_for_dynamic_lookml_dashboard_block_demo2
  - name: Last Week
    explore: users_for_dynamic_lookml_dashboard_block_demo2
  - name: Overview for Last Week
  - name: Weekly Variance From Avg
    explore: users_for_dynamic_lookml_dashboard_block_demo2
  - name: 53 Week Trend
    explore: users_for_dynamic_lookml_dashboard_block_demo2
  - name: By Day of Week
    explore: users_for_dynamic_lookml_dashboard_block_demo2
  - name: Last Week Performance
    explore: users_for_dynamic_lookml_dashboard_block_demo2
  - name: Last Week Count (vs Last Yr's Avg Wk)
    explore: users_for_dynamic_lookml_dashboard_block_demo2
  - name: 'NOTE: WIP - See comments below'
