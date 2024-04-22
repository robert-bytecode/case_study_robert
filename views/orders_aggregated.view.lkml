view: orders_aggregated {
  derived_table: {
    explore_source: order_items {
      column: user_id { field: order_items.user_id }
      column: total_orders { field: order_items.total_orders }
      # Assumes 'orders_per_customer' is a measure in 'order_items' view counting distinct orders per user
    }
  }

  dimension: user_id {
    primary_key: yes
    type: string
    # sql: ${TABLE}.user_id ;;
  }

  dimension: customer_lifetime_orders {
    type: string
    sql: CASE
           WHEN ${total_orders} = 1 THEN '1 Order'
           WHEN ${total_orders} = 2 THEN '2 Orders'
           WHEN ${total_orders} BETWEEN 3 AND 5 THEN '3-5 Orders'
           WHEN ${total_orders} BETWEEN 6 AND 9 THEN '6-9 Orders'
           WHEN ${total_orders} >= 10 THEN '10+ Orders'
           ELSE 'Unknown'  -- Optional, for handling unexpected cases
         END ;;
    order_by_field: customer_lifetime_orders_sort_key
  }

  dimension: customer_lifetime_orders_sort_key {
    type: string
    sql: CASE
           WHEN ${total_orders} = 1 THEN 1
           WHEN ${total_orders} = 2 THEN 2
           WHEN ${total_orders} BETWEEN 3 AND 5 THEN 3
           WHEN ${total_orders} BETWEEN 6 AND 9 THEN 4
           WHEN ${total_orders} >= 10 THEN 5
           ELSE 6  -- Optional, for handling unexpected cases
         END ;;
  }

  dimension: total_orders {
    type: string
    value_format_name: id
  }
}



# view: orders_aggregated {
#   derived_table: {
#     explore_source: order_items {
#       column: user_id { field: order_items.user_id }
#       column: total_orders { field: order_items.total_orders }
#       # Assumes 'orders_per_customer' is a measure in 'order_items' view counting distinct orders per user
#     }
#   }

#   dimension: user_id {
#     primary_key: yes
#     type: string
#     # sql: ${TABLE}.user_id ;;
#   }

#   dimension: total_orders {
#     type: string
#     value_format_name: id
#   }

#   dimension: customer_lifetime_orders_sort_key {
#     type: string
#     sql:  CASE
#           WHEN ${total_orders} = 1 THEN 1
#           WHEN ${total_orders} = 2 THEN 2
#           WHEN ${total_orders} BETWEEN 3 AND 5 THEN 3
#           WHEN ${total_orders} BETWEEN 6 AND 9 THEN 4
#           WHEN ${total_orders} >= 10 THEN 5
#           ELSE 6  -- Optional, for handling unexpected cases
#         END  ;;
#   }

#   dimension: customer_lifetime_orders {
#     type: string
#     sql:  CASE
#     WHEN ${total_orders} = 1 THEN '1 Order'
#     WHEN ${total_orders} = 2 THEN '2 Orders'
#     WHEN ${total_orders} BETWEEN 3 AND 5 THEN '3-5 Orders'
#     WHEN ${total_orders} BETWEEN 6 AND 9 THEN '6-9 Orders'
#     WHEN ${total_orders} >= 10 THEN '10+ Orders'
#     ELSE 'Unknown'  -- Optional, for handling unexpected cases
#     END  ;;
#     order_by_field: customer_lifetime_orders_sort_key
#   }


#   # measure: total_orders_sum {
#   #   type: sum
#   #   sql: ${TABLE}.order_amount;;
#   #   value_format_name: id
#   # }




# }
