view: order_items {
  sql_table_name: `thelook.order_items` ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [raw, time, hour_of_day, date, day_of_week, day_of_week_index, day_of_month,
            day_of_year, week, week_of_year, month, month_name, month_num, quarter, year]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [raw, time, hour_of_day, date, day_of_week, day_of_week_index, day_of_month,
            day_of_year, week, week_of_year, month, month_name, month_num, quarter, year]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: product_id {
    type: number
    hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [raw, time, hour_of_day, date, day_of_week, day_of_week_index, day_of_month,
            day_of_year, week, week_of_year, month, month_name, month_num, quarter, year]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [raw, time, hour_of_day, date, day_of_week, day_of_week_index, day_of_month,
            day_of_year, week, week_of_year, month, month_name, month_num, quarter, year]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: average_lifetime_orders {
    type: number
    sql: count(distinct ${order_id})/count(distinct ${user_id}) ;;
    value_format_name: usd_0
    drill_fields: [product_detail*, average_lifetime_orders]
  }

  measure: average_lifetime_revenue {
    type: number
    sql: sum(${sale_price})/count(distinct ${user_id}) ;;
    value_format_name: usd_0
    drill_fields: [product_detail*, average_lifetime_revenue]
  }

  measure: average_orders {
    type: number
    sql: ${total_orders}/nullif(${total_users},0);;
    value_format_name: decimal_2
    drill_fields: [product_detail*, average_orders]
  }

  measure: item_return_rate {
    type: number
    sql: 1.0*(${number_of_items_returned}/count(${id})) ;;
    value_format_name: percent_2
    drill_fields: [product_detail*, item_return_rate]
  }

  measure: number_of_items_returned {
    type: count_distinct
    sql: ${id} ;;
    filters: [status: "Returned"]
    drill_fields: [product_detail*, number_of_items_returned]
  }

  measure: number_of_one_off_customers {
    type: count_distinct
    sql: ${user_id} ;;
    filters: [repeat_customers.repeat_customer: "no"]
    drill_fields: [product_detail*, number_of_one_off_customers]
  }

  measure: number_of_repeat_customers {
    type: count_distinct
    sql: ${user_id} ;;
    filters: [repeat_customers.repeat_customer: "yes"]
    drill_fields: [product_detail*, number_of_repeat_customers]
  }

  measure: repeat_purchase_rate {
    type: number
    sql: ${number_of_repeat_customers}/${total_customers} ;;
    value_format_name: percent_2
    drill_fields: [product_detail*, repeat_purchase_rate]
  }

  measure: total_customers {
    type: count_distinct
    sql: ${user_id} ;;
    drill_fields: [product_detail*, total_customers]
  }

  measure: total_lifetime_revenue {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd_0
    drill_fields: [product_detail*, total_lifetime_revenue]
  }

  measure: total_orders {
    type: count_distinct
    sql: ${order_id} ;;
    drill_fields: [product_detail*, total_orders]
  }

  measure: total_units_sold {
    type: count_distinct
    sql: ${id} ;;
    drill_fields: [product_detail*, total_orders]
  }

  measure: total_users {
    type: count_distinct
    sql: ${user_id} ;;
    drill_fields: [product_detail*, total_users]
  }

  set: detail {
    fields: [
      id,
      users.last_name,
      users.id,
      users.first_name,
      inventory_items.id,
      inventory_items.product_name,
      products.name,
      products.id
    ]
  }

  set: product_detail {
    fields: [products.id,products.sku,products.name,products.category,products.department,products.brand]
   }
}


# view: order_items {
#   sql_table_name: `thelook.order_items` ;;
#   drill_fields: [id]

#   dimension: id {
#     primary_key: yes
#     type: number
#     sql: ${TABLE}.id ;;
#   }
#   dimension_group: created {
#     type: time
#     timeframes: [raw, time, date, week, month, quarter, year]
#     sql: ${TABLE}.created_at ;;
#   }
#   dimension_group: delivered {
#     type: time
#     timeframes: [raw, time, date, week, month, quarter, year]
#     sql: ${TABLE}.delivered_at ;;
#   }
#   dimension: inventory_item_id {
#     type: number
#     # hidden: yes
#     sql: ${TABLE}.inventory_item_id ;;
#   }
#   dimension: order_id {
#     type: number
#     sql: ${TABLE}.order_id ;;
#   }
#   dimension: product_id {
#     type: number
#     # hidden: yes
#     sql: ${TABLE}.product_id ;;
#   }
#   dimension_group: returned {
#     type: time
#     timeframes: [raw, time, date, week, month, quarter, year]
#     sql: ${TABLE}.returned_at ;;
#   }
#   dimension: sale_price {
#     type: number
#     sql: ${TABLE}.sale_price ;;
#   }
#   dimension_group: shipped {
#     type: time
#     timeframes: [raw, time, date, week, month, quarter, year]
#     sql: ${TABLE}.shipped_at ;;
#   }
#   dimension: status {
#     type: string
#     sql: ${TABLE}.status ;;
#   }
#   dimension: user_id {
#     type: number
#     # hidden: yes
#     sql: ${TABLE}.user_id ;;
#   }
#   # dimension: orders_per_customer{
#   #   type: number
#   #   # hidden: yes
#   #   sql: case when ${TABLE}.number_of_orders ;;
#   # }


#   measure: number_of_items_returned {
#     type: count_distinct
#     sql: ${id} ;;
#     filters: [status: "Returned"]
#     drill_fields: [product_detail*,number_of_items_returned]
#   }
#   measure: item_return_rate {
#     type: number
#     sql: 1.0*(${number_of_items_returned}/count(${id})) ;;
#     value_format_name: percent_2
#     drill_fields: [product_detail*,item_return_rate]
#   }
#   measure: total_orders {
#     type: count_distinct
#     sql: ${order_id} ;;
#     drill_fields: [product_detail*,total_orders]
#   }
#   measure: average_lifetime_orders {
#     type: number
#     sql: count(distinct ${order_id})/count(distinct ${user_id}) ;;
#     value_format_name: usd_0
#     drill_fields: [product_detail*,average_lifetime_orders]
#   }
#   measure: total_users {
#     type: count_distinct
#     sql: ${user_id} ;;
#     # drill_fields: [products.id,products.sku,products.name,products.category,products.department,products.brand]
#     drill_fields: [product_detail*,total_users]
#   }
#   measure: total_customers {
#     type: count_distinct
#     sql: ${user_id} ;;
#     # drill_fields: [products.id,products.sku,products.name,products.category,products.department,products.brand]
#     # drill_fields: [products.id,products.sku,products.name,products.category,products.department,products.brand]
#     drill_fields: [product_detail*,total_customers]
#   }
#   measure: average_orders {
#     type: number
#     sql: ${total_orders}/nullif(${total_users},0);;
#     value_format_name: decimal_2
#     drill_fields: [product_detail*,average_orders]
#   }

#   measure: total_lifetime_revenue {
#     type: sum
#     sql: ${sale_price} ;;
#     value_format_name: usd_0
#     drill_fields: [product_detail*,total_lifetime_revenue]
#   }

#   measure: average_lifetime_revenue {
#     type: number
#     sql: sum(${sale_price})/count(distinct ${user_id}) ;;
#     value_format_name: usd_0
#     drill_fields: [product_detail*,average_lifetime_revenue]
#   }

#   # measure: number_of_repeat_customers {
#   #   type: count_distinct
#   #   sql: ${user_id} ;;
#   #   filters: [repeat_customers.total_orders: ">1"]
#   # }

#   measure: number_of_repeat_customers {
#     type: count_distinct
#     sql: ${user_id} ;;
#     filters: [repeat_customers.repeat_customer: "yes"]
#     drill_fields: [product_detail*,number_of_repeat_customers]
#   }

#   measure: number_of_one_off_customers {
#     type: count_distinct
#     sql: ${user_id} ;;
#     filters: [repeat_customers.repeat_customer: "no"]
#     drill_fields: [product_detail*,number_of_one_off_customers]
#   }

#   measure: repeat_purchase_rate {
#     type: number
#     sql: ${number_of_repeat_customers}/${total_customers} ;;
#     value_format_name: percent_2
#     drill_fields: [product_detail*,repeat_purchase_rate]
#   }


#   # dimension: orders_per_customer {
#   #   type: string
#   #   sql:  CASE
#   #   WHEN ${orders_aggregated.total_orders} = 1 THEN '1 Order'
#   #   WHEN ${orders_aggregated.total_orders} = 2 THEN '2 Orders'
#   #   WHEN ${orders_aggregated.total_orders} BETWEEN 3 AND 5 THEN '3-5 Orders'
#   #   WHEN ${orders_aggregated.total_orders} BETWEEN 6 AND 9 THEN '6-9 Orders'
#   #   WHEN ${orders_aggregated.total_orders} >= 10 THEN '10+ Orders'
#   #   ELSE 'Unknown'  -- Optional, for handling unexpected cases
#   # END;;
#   # }

#   #   measure: number_of_customers_returning_items {
#   #   type: count_distinct
#   #   sql: ${user_id};;
#   #   filters: []
#   # }

#   # ----- Sets of fields for drilling ------
#   set: detail {
#     fields: [
#   id,
#   users.last_name,
#   users.id,
#   users.first_name,
#   inventory_items.id,
#   inventory_items.product_name,
#   products.name,
#   products.id
#   ]
#   }

#   set: product_detail {
#     fields: [products.id,products.sku,products.name,products.category,products.department,products.brand]
#   }

# }
