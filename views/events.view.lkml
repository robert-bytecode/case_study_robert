view: events {
  sql_table_name: `thelook.events` ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: browser {
    type: string
    sql: ${TABLE}.browser ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}.event_type ;;
  }

  dimension: ip_address {
    type: string
    sql: ${TABLE}.ip_address ;;
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: sequence_number {
    type: number
    sql: ${TABLE}.sequence_number ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: uri {
    type: string
    sql: ${TABLE}.uri ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.last_name, users.id, users.first_name]
  }

  measure: mtd_visitors_2023 {
    type: count_distinct
    sql: ${user_id} ;;
    filters: [created_date: "2023-01-01 to 2024-01-01"]
    drill_fields: [event_detail*, mtd_visitors_2023]
  }

  measure: mtd_visitors_2024 {
    type: count_distinct
    sql: ${user_id} ;;
    filters: [created_date: "2024-01-01 to 2024-01-01"]
    drill_fields: [event_detail*, mtd_visitors_2024]
  }

  measure: number_of_customers_returning_items {
    type: count_distinct
    sql: ${users_with_returns.user_id_return};;
    drill_fields: [event_detail*, number_of_customers_returning_items]
  }

  measure: percentage_of_users_with_returns {
    type: number
    sql: ${number_of_customers_returning_items}/${total_customers};;
    value_format_name: percent_2
    drill_fields: [event_detail*, percentage_of_users_with_returns]
  }

  measure: total_customers {
    type: count_distinct
    sql: ${events.user_id};;
    filters: [event_type: "purchase"]
    drill_fields: [event_detail*, total_customers]
  }

  measure: total_events {
    type: count_distinct
    sql: ${id} ;;
    drill_fields: [event_detail*, total_events]
  }

  measure: total_sessions {
    type: count_distinct
    sql: ${session_id} ;;
    drill_fields: [event_detail*, total_sessions]
  }

  set: event_detail {
    fields: [user_id, traffic_source, state]
  }
}



# view: events {
#   sql_table_name: `thelook.events` ;;
#   drill_fields: [id]

#   dimension: id {
#     primary_key: yes
#     type: number
#     sql: ${TABLE}.id ;;
#   }
#   dimension: browser {
#     type: string
#     sql: ${TABLE}.browser ;;
#   }
#   dimension: city {
#     type: string
#     sql: ${TABLE}.city ;;
#   }
#   dimension_group: created {
#     type: time
#     timeframes: [raw, time, date, week, month, quarter, year]
#     sql: ${TABLE}.created_at ;;
#   }
#   dimension: event_type {
#     type: string
#     sql: ${TABLE}.event_type ;;
#   }
#   dimension: ip_address {
#     type: string
#     sql: ${TABLE}.ip_address ;;
#   }
#   dimension: postal_code {
#     type: string
#     sql: ${TABLE}.postal_code ;;
#   }
#   dimension: sequence_number {
#     type: number
#     sql: ${TABLE}.sequence_number ;;
#   }
#   dimension: session_id {
#     type: string
#     sql: ${TABLE}.session_id ;;
#   }
#   dimension: state {
#     type: string
#     sql: ${TABLE}.state ;;
#   }
#   dimension: traffic_source {
#     type: string
#     sql: ${TABLE}.traffic_source ;;
#   }
#   dimension: uri {
#     type: string
#     sql: ${TABLE}.uri ;;
#   }
#   dimension: user_id {
#     type: string
#     # hidden: yes
#     sql: ${TABLE}.user_id ;;
#   }
#   measure: count {
#     type: count
#     drill_fields: [id, users.last_name, users.id, users.first_name]
#   }

#   measure: number_of_customers_returning_items {
#     type: count_distinct
#     sql: ${users_with_returns.user_id_return};;
#     drill_fields: [event_detail*,number_of_customers_returning_items]
#   }

#   measure: total_customers {
#     type: count_distinct
#     sql:  ${events.user_id};;
#     filters: [event_type: "purchase"]
#     drill_fields: [event_detail*,total_customers]
#   }

#   measure: percentage_of_users_with_returns {
#     type: number
#     sql:  ${number_of_customers_returning_items}/${total_customers};;
#     value_format_name: percent_2
#     drill_fields: [event_detail*,percentage_of_users_with_returns]
#   }

#   measure: mtd_visitors_2024 {
#     type: count_distinct
#     sql: ${user_id} ;;
#     filters: [created_date: "2024-01-01 to 2024-01-01"]
#     drill_fields: [event_detail*,mtd_visitors_2024]
#   }

#   measure: mtd_visitors_2023 {
#     type: count_distinct
#     sql: ${user_id} ;;
#     filters: [created_date: "2023-01-01 to 2024-01-01"]
#     drill_fields: [event_detail*,mtd_visitors_2023]
#   }

#   measure: total_events {
#     type: count_distinct
#     sql: ${id} ;;
#     drill_fields: [event_detail*,total_events]
#   }

#   measure: total_sessions {
#     type: count_distinct
#     sql: ${session_id} ;;
#     drill_fields: [event_detail*,total_sessions]
#   }

#   set: event_detail {
#     fields: [events.user_id,events.traffic_source,events.state]
#   }
# }
