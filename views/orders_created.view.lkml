view: orders_created {
  derived_table: {
    sql:
      with first_order as (
        select user_id, min(order_id) as first_order
        from order_items
        group by 1
        order by 1
      ),
      first_created as (
        select f.user_id, f.first_order, min(o.created_at) as first_order_date
        from first_order f
        left join order_items o on f.user_id = o.user_id and f.first_order = o.order_id
        group by 1, 2
        order by 1, 2
      ),
      last_created as (
        select f.user_id, f.first_order, max(o.created_at) as last_order_date
        from first_order f
        left join order_items o on f.user_id = o.user_id and f.first_order = o.order_id
        group by 1, 2
        order by 1, 2
      )
      select f.user_id, f.first_order, f.first_order_date, o.last_order_date
      from first_created f
      left join last_created o on f.user_id = o.user_id and f.first_order = o.first_order ;;
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: days_since_last_order {
    type: number
    sql: CASE
           WHEN DATE_DIFF(current_date(), ${last_order_date}, DAY) < 0 THEN 0
           ELSE DATE_DIFF(current_date(), ${last_order_date}, DAY)
         END ;;
  }

  dimension_group: first_order {
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  dimension: is_active {
    type: yesno
    sql: date_diff(current_date(), ${last_order_date}, day) <= 90 ;;
  }

  dimension_group: last_order {
    type: time
    sql: ${TABLE}.last_order_date ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.first_order ;;
  }

  measure: average_days_since_latest_order {
    type: average
    sql: ${days_since_last_order};;
    value_format_name: decimal_0
    drill_fields: [products.id, products.sku, products.name, products.category, products.department, products.brand]
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  set: detail {
    fields: [
      user_id,
      order_id,
      first_order_date,
      last_order_date
    ]
  }
}




# view: orders_created {
#   derived_table: {
#     sql: -- select user_id, min(created_at) from order_items group by 1;

#       -- select distinct status from order_items

#       -- select * from order_items limit 10

#       with first_order as (select user_id, min(order_id) as first_order from order_items group by 1 order by 1)
#       ,
#       first_created as (select f.user_id, f.first_order, min(o.created_at) as first_order_date
#                         from first_order f left join order_items o on
#                           f.user_id=o.user_id and f.first_order=o.order_id
#                           group by 1,2
#                           order by 1,2
#                         )
#       ,
#       last_created as (select f.user_id, f.first_order, max(o.created_at) as last_order_date
#                         from first_order f left join order_items o on
#                           f.user_id=o.user_id and f.first_order=o.order_id
#                           group by 1,2
#                           order by 1,2
#                         )

#       select f.user_id, f.first_order, f.first_order_date, o.last_order_date
#       from first_created f left join last_created o on
#         f.user_id=o.user_id and f.first_order=o.first_order
#         ;;
#   }

#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }

#   dimension: user_id {
#     type: number
#     primary_key: yes
#     sql: ${TABLE}.user_id ;;
#   }

#   dimension: order_id {
#     type: number
#     sql: ${TABLE}.first_order ;;
#   }

#   dimension_group: first_order {
#     type: time
#     sql: ${TABLE}.first_order_date ;;
#   }

#   dimension_group: last_order {
#     type: time
#     sql: ${TABLE}.last_order_date ;;
#   }

#   dimension: is_active {
#     type: yesno
#     sql: date_diff(current_date(),${last_order_date},day)<=90 ;;
#   }

#   dimension: days_since_last_order {
#     type: number
#     sql: CASE
#         WHEN DATE_DIFF(current_date(), ${last_order_date}, DAY) < 0 THEN 0
#         ELSE DATE_DIFF(current_date(), ${last_order_date}, DAY)
#       END ;;
#   }

#   measure:  average_days_since_latest_order {
#     type: average
#     sql: ${days_since_last_order};;
#     value_format_name: decimal_0
#     drill_fields: [products.id,products.sku,products.name,products.category,products.department,products.brand]
#   }

#   set: detail {
#     fields: [
#       user_id,
#       order_id,
#       first_order_date,
#       last_order_date
#     ]
#   }
# }
