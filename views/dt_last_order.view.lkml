view: last_order {
  derived_table: {
    sql: with date_difference as (
      select id,
      max(created_at) as max_created_time,
      date(max(created_at)) as max_created_date,
      current_date() as current_date,
      date_diff(current_date,max(date(created_at)),year) as years_difference,
      date_diff(current_date,max(date(created_at)),month) as months_difference,
      date_diff(current_date,max(date(created_at)),day) as days_difference
      from users group by 1 order by 1, 2 desc,3 desc
      )
      ,
      max_created as (
      select user_id, max(created_at) as max_created_time, date(max(created_at)) as max_created_date from order_items group by 1 order by 1
      )
      ,
      orders_by_user as (
      select distinct user_id, order_id, created_at as created_time, date(created_at) as created_date from order_items order by 1,3 desc,4 desc,2
      )
      ,
      order_master as (
        SELECT
          m.user_id,
          o.order_id as last_order_id,
          m.max_created_time as last_order_time,
          m.max_created_date as last_order_date
        FROM max_created m
        LEFT JOIN orders_by_user o
          ON m.user_id = o.user_id
          AND m.max_created_time = o.created_time
        WHERE o.order_id = (
            SELECT MAX(o2.order_id)
            FROM orders_by_user o2
            WHERE o2.user_id = m.user_id
            AND o2.created_time = m.max_created_time
            )
      )
      ,
      date_orders as (
      select d.*, o.last_order_id, o.last_order_time, o.last_order_date
      from date_difference d left join order_master o on
        d.id=o.user_id
      )
      select * from date_orders ;;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: current_date {
    type: date
    datatype: date
    sql: ${TABLE}.current_date ;;
  }

  dimension: current_vs_signup_date_in_days {
    type: number
    sql: ${TABLE}.days_difference ;;
  }

  dimension: current_vs_signup_date_in_months {
    type: number
    sql: ${TABLE}.months_difference ;;
  }

  dimension: current_vs_signup_date_in_years {
    type: number
    sql: ${TABLE}.years_difference ;;
  }

  dimension: last_order_date {
    type: date
    datatype: date
    sql: ${TABLE}.last_order_date ;;
  }

  dimension: last_order_id {
    type: number
    sql: ${TABLE}.last_order_id ;;
  }

  dimension: last_order_vs_signup_in_days {
    type: number
    sql: date_diff(${last_order_date},${max_created_date},day) ;;
  }

  dimension: last_order_vs_signup_in_months {
    type: number
    sql: date_diff(${last_order_date},${max_created_date},month) ;;
  }

  dimension: last_order_vs_signup_in_years {
    type: number
    sql: date_diff(${last_order_date},${max_created_date},year) ;;
  }

  dimension_group: last_order_time {
    type: time
    sql: ${TABLE}.last_order_time ;;
  }

  dimension: max_created_date {
    type: date
    datatype: date
    sql: ${TABLE}.max_created_date ;;
  }

  dimension_group: max_created_time {
    type: time
    sql: ${TABLE}.max_created_time ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

    set: detail {
    fields: [
        id,
   max_created_time_time,
   max_created_date,
   current_date,
   current_vs_signup_date_in_years,
   current_vs_signup_date_in_months,
   current_vs_signup_date_in_days,
   last_order_id,
   last_order_time_time,
   last_order_date
     ]
   }
}



# view: last_order {
#   derived_table: {
#     sql: with date_difference as (
#       select id,
#       max(created_at) as max_created_time,
#       date(max(created_at)) as max_created_date,
#       current_date() as current_date,
#       date_diff(current_date,max(date(created_at)),year) as years_difference,
#       date_diff(current_date,max(date(created_at)),month) as months_difference,
#       date_diff(current_date,max(date(created_at)),day) as days_difference
#       from users group by 1 order by 1, 2 desc,3 desc
#       )
#       ,
#       max_created as (
#       select user_id, max(created_at) as max_created_time, date(max(created_at)) as max_created_date from order_items group by 1 order by 1
#       )
#       ,
#       orders_by_user as (
#       select distinct user_id, order_id, created_at as created_time, date(created_at) as created_date from order_items order by 1,3 desc,4 desc,2
#       )
#       ,
#       order_master as (
#         SELECT
#           m.user_id,
#           o.order_id as last_order_id,
#           m.max_created_time as last_order_time,
#           m.max_created_date as last_order_date
#         FROM max_created m
#         LEFT JOIN orders_by_user o
#           ON m.user_id = o.user_id
#           AND m.max_created_time = o.created_time
#         WHERE o.order_id = (
#             SELECT MAX(o2.order_id)
#             FROM orders_by_user o2
#             WHERE o2.user_id = m.user_id
#             AND o2.created_time = m.max_created_time
#             )
#       )
#       ,
#       date_orders as (
#       select d.*, o.last_order_id, o.last_order_time, o.last_order_date
#       from date_difference d left join order_master o on
#         d.id=o.user_id
#       )



#       select * from date_orders ;;

#   }

#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }

#   dimension: id {
#     type: number
#     primary_key: yes
#     sql: ${TABLE}.id ;;
#   }

#   dimension_group: max_created_time {
#     type: time
#     sql: ${TABLE}.max_created_time ;;
#   }

#   dimension: max_created_date {
#     type: date
#     datatype: date
#     sql: ${TABLE}.max_created_date ;;
#   }

#   dimension: current_date {
#     type: date
#     datatype: date
#     sql: ${TABLE}.current_date ;;
#   }

#   dimension: current_vs_signup_date_in_years {
#     type: number
#     sql: ${TABLE}.years_difference ;;
#   }

#   dimension: current_vs_signup_date_in_months {
#     type: number
#     sql: ${TABLE}.months_difference ;;
#   }

#   dimension: current_vs_signup_date_in_days {
#     type: number
#     sql: ${TABLE}.days_difference ;;
#   }

#   dimension: last_order_id {
#     type: number
#     sql: ${TABLE}.last_order_id ;;
#   }

#   dimension_group: last_order_time {
#     type: time
#     sql: ${TABLE}.last_order_time ;;
#   }

#   dimension: last_order_date {
#     type: date
#     datatype: date
#     sql: ${TABLE}.last_order_date ;;
#   }

#   dimension: last_order_vs_signup_in_days {
#     type: number
#     sql: date_diff(${last_order_date},${max_created_date},day) ;;
#   }

#   dimension: last_order_vs_signup_in_months {
#     type: number
#     sql: date_diff(${last_order_date},${max_created_date},month) ;;
#   }

#   dimension: last_order_vs_signup_in_years {
#     type: number
#     sql: date_diff(${last_order_date},${max_created_date},year) ;;
#   }

#   set: detail {
#     fields: [
#         id,
#   max_created_time_time,
#   max_created_date,
#   current_date,
#   current_vs_signup_date_in_years,
#   current_vs_signup_date_in_months,
#   current_vs_signup_date_in_days,
#   last_order_id,
#   last_order_time_time,
#   last_order_date
#     ]
#   }
# }
