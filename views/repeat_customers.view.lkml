view: repeat_customers {
  derived_table: {
    explore_source: products {
      column: user_id { field: order_items.user_id }
      column: total_orders { field: order_items.total_orders }
    }
  }

  dimension: user_id {
    type: string
    primary_key: yes
  }

  dimension: repeat_customer {
    type: yesno
    sql: ${TABLE}.total_orders > 1 ;;
  }

  dimension: total_orders {
    type: number
    sql: ${TABLE}.total_orders ;;
    value_format_name: decimal_0
  }
}



# view: repeat_customers {
#   derived_table: {
#     explore_source: products {
#       column: user_id {field: order_items.user_id}
#       column: total_orders {field: order_items.total_orders}
#     }
#   }

#   dimension: user_id {
#     type: string
#     primary_key: yes
#   }

#   dimension: total_orders {
#     type: number
#     sql: ${TABLE}.total_orders ;;
#     value_format_name: decimal_0
#   }

#   dimension: repeat_customer {
#     type: yesno
#     sql: ${TABLE}.total_orders > 1 ;;
#   }

# }
