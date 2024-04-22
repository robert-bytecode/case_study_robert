
view: users_with_returns {
  derived_table: {
    sql: select distinct user_id as user_id_return from order_items
      where status="Returned" order by 1 ;;
  }

  dimension: user_id_return {
    type: number
    primary_key: yes
    sql: ${TABLE}.user_id_return ;;
    value_format_name: id
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  set: detail {
    fields: [
        user_id_return
    ]
  }
}
