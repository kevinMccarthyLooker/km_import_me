- dashboard: compare_group_dashboard_via_extension
  extends: compare_group_dashboard_for_extension
  title: Compare Group Dashboard Via Extension
  elements:
  - title: Pie Chart
    name: Pie Chart
    model: compare_one_to_group_dashboard
    explore: compare_dashboard_extending_explore
  - title: Single Record Comparison
    name: Single Record Comparison
    model: compare_one_to_group_dashboard
    explore: compare_dashboard_extending_explore
