view: order_sequence {
  derived_table: {
    sql: WITH
      sequence AS (
        select *,
          RANK() OVER (PARTITION BY user_id ORDER BY created_at) as order_sequence,
          DATE_DIFF(created_at, LAG(created_at, 1) OVER (PARTITION BY user_id ORDER BY created_at), DAY) as days_between_orders
        from events
        where event_type='purchase'
      ),
      first_purchased as (
        select *,
        case when max(order_sequence) over (partition by user_id) > 1 then "Yes" else "No" end as repeat_purchaser,
        case when order_sequence=1 then "Yes" else "No" end as is_first_purchase,
        case when order_sequence = max(order_sequence) over (partition by user_id) then "No" else "Yes" end as has_subsequent_order
        from sequence
      )
      ,
      repeat_purchase as (
      select * ,
        case when date_diff(created_at, lag(created_at,1) over (partition by user_id order by created_at),day) <=60
              then 'Yes' else 'No' end as sixty_day_repeat_purchase
        from first_purchased
        order by user_id
      )

      select * from repeat_purchase ;;
  }

  dimension: id {
    type: number
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.id ;;
    drill_fields: [detail*]
  }

  dimension: browser {
    type: string
    hidden: yes
    sql: ${TABLE}.browser ;;
    drill_fields: [detail*]
  }

  dimension: city {
    type: string
    hidden: yes
    sql: ${TABLE}.city ;;
    drill_fields: [detail*]
  }

 dimension_group: created_at {
    type: time
    hidden: yes
    sql: ${TABLE}.created_at ;;
    drill_fields: [detail*]
  }

  dimension: days_between_orders {
    type: number
    sql: ${TABLE}.days_between_orders ;;
    drill_fields: [detail*]
  }

  dimension: event_type {
    type: string
    hidden: yes
    sql: ${TABLE}.event_type ;;
    drill_fields: [detail*]
  }

  dimension: has_subsequent_order {
    type: string
    sql: ${TABLE}.has_subsequent_order ;;
    drill_fields: [detail*]
  }

  dimension: ip_address {
    type: string
    hidden: yes
    sql: ${TABLE}.ip_address ;;
    drill_fields: [detail*]
  }

  dimension: is_first_purchase {
    type: string
    sql: ${TABLE}.is_first_purchase ;;
    drill_fields: [detail*]
  }

  dimension: order_sequence {
    type: number
    sql: ${TABLE}.order_sequence ;;
    drill_fields: [detail*]
  }

  dimension: postal_code {
    type: string
    hidden: yes
    sql: ${TABLE}.postal_code ;;
    drill_fields: [detail*]
  }

  dimension: repeat_purchaser {
    type: string
    sql: ${TABLE}.repeat_purchaser ;;
    drill_fields: [detail*]
  }

  dimension: sequence_number {
    type: number
    hidden: yes
    sql: ${TABLE}.sequence_number ;;
    drill_fields: [detail*]
  }

  dimension: session_id {
    type: string
    hidden: yes
    sql: ${TABLE}.session_id ;;
    drill_fields: [detail*]
  }

  dimension: sixty_day_repeat_purchase {
    type: string
    sql: ${TABLE}.sixty_day_repeat_purchase ;;
    drill_fields: [detail*]
  }

  dimension: state {
    type: string
    hidden: yes
    sql: ${TABLE}.state ;;
    drill_fields: [detail*]
  }

  dimension: traffic_source {
    type: string
    hidden: yes
    sql: ${TABLE}.traffic_source ;;
    drill_fields: [detail*]
  }

  dimension: uri {
    type: string
    hidden: yes
    sql: ${TABLE}.uri ;;
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;;
    drill_fields: [detail*]
  }

  measure: average_days_between_orders {
    type: average
    sql: ${days_between_orders} ;;
    drill_fields: [detail*]
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }


  measure: count_of_repeat_purchasers {
    type: number
    sql: count(distinct case when ${repeat_purchaser}="Yes" then ${user_id} else null end) ;;
    drill_fields: [detail*]
  }

  set: detail {
    fields: [
      id,
      user_id,
      sequence_number,
      session_id,
      created_at_time,
      ip_address,
      city,
      state,
      postal_code,
      browser,
      traffic_source,
      uri,
      event_type,
      order_sequence,
      days_between_orders,
      is_first_purchase,
      has_subsequent_order,
      sixty_day_repeat_purchase
    ]
  }
}




# view: order_sequence {
#   derived_table: {
#     sql: WITH
#       sequence AS (
#         select *,
#           RANK() OVER (PARTITION BY user_id ORDER BY created_at) as order_sequence,
#           DATE_DIFF(created_at, LAG(created_at, 1) OVER (PARTITION BY user_id ORDER BY created_at), DAY) as days_between_orders
#         from events
#         where event_type='purchase'
#       ),
#       first_purchased as (
#         select *,
#         case when max(order_sequence) over (partition by user_id) > 1 then "Yes" else "No" end as repeat_purchaser,
#         case when order_sequence=1 then "Yes" else "No" end as is_first_purchase,
#         case when order_sequence = max(order_sequence) over (partition by user_id) then "No" else "Yes" end as has_subsequent_order
#         from sequence
#       )
#       ,
#       repeat_purchase as (
#       select * ,
#         case when date_diff(created_at, lag(created_at,1) over (partition by user_id order by created_at),day) <=60
#               then 'Yes' else 'No' end as sixty_day_repeat_purchase
#         from first_purchased
#         order by user_id
#       )

#       select * from repeat_purchase ;;
#   }

#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }

#   dimension: id {
#     type: number
#     hidden: yes
#     primary_key: yes
#     sql: ${TABLE}.id ;;
#     drill_fields: [detail*]
#   }

#   dimension: user_id {
#     type: number
#     hidden: yes
#     sql: ${TABLE}.user_id ;;
#     drill_fields: [detail*]
#   }

#   dimension: sequence_number {
#     type: number
#     hidden: yes
#     sql: ${TABLE}.sequence_number ;;
#     drill_fields: [detail*]
#   }

#   dimension: session_id {
#     type: string
#     hidden: yes
#     sql: ${TABLE}.session_id ;;
#     drill_fields: [detail*]
#   }

#   dimension_group: created_at {
#     type: time
#     hidden: yes
#     sql: ${TABLE}.created_at ;;
#     drill_fields: [detail*]
#   }

#   dimension: ip_address {
#     type: string
#     hidden: yes
#     sql: ${TABLE}.ip_address ;;
#     drill_fields: [detail*]
#   }

#   dimension: city {
#     type: string
#     hidden: yes
#     sql: ${TABLE}.city ;;
#     drill_fields: [detail*]
#   }

#   dimension: state {
#     type: string
#     hidden: yes
#     sql: ${TABLE}.state ;;
#     drill_fields: [detail*]
#   }

#   dimension: postal_code {
#     type: string
#     hidden: yes
#     sql: ${TABLE}.postal_code ;;
#     drill_fields: [detail*]
#   }

#   dimension: browser {
#     type: string
#     hidden: yes
#     sql: ${TABLE}.browser ;;
#     drill_fields: [detail*]
#   }

#   dimension: traffic_source {
#     type: string
#     hidden: yes
#     sql: ${TABLE}.traffic_source ;;
#     drill_fields: [detail*]
#   }

#   dimension: uri {
#     type: string
#     hidden: yes
#     sql: ${TABLE}.uri ;;
#     drill_fields: [detail*]
#   }

#   dimension: event_type {
#     type: string
#     hidden: yes
#     sql: ${TABLE}.event_type ;;
#     drill_fields: [detail*]
#   }

#   dimension: order_sequence {
#     type: number
#     sql: ${TABLE}.order_sequence ;;
#     drill_fields: [detail*]
#   }

#   dimension: days_between_orders {
#     type: number
#     sql: ${TABLE}.days_between_orders ;;
#     drill_fields: [detail*]
#   }

#   dimension: repeat_purchaser {
#     type: string
#     sql: ${TABLE}.repeat_purchaser ;;
#     drill_fields: [detail*]
#   }

#   dimension: is_first_purchase {
#     type: string
#     sql: ${TABLE}.is_first_purchase ;;
#     drill_fields: [detail*]
#   }

#   dimension: has_subsequent_order {
#     type: string
#     sql: ${TABLE}.has_subsequent_order ;;
#     drill_fields: [detail*]
#   }

#   dimension: sixty_day_repeat_purchase {
#     type: string
#     sql: ${TABLE}.sixty_day_repeat_purchase ;;
#     drill_fields: [detail*]
#   }

#   measure: average_days_between_orders {
#     type: average
#     sql: ${days_between_orders} ;;
#     drill_fields: [detail*]
#   }

#   measure: count_of_repeat_purchasers {
#     type: number
#     sql: count(distinct case when ${repeat_purchaser}="Yes" then ${user_id} else null end) ;;
#     drill_fields: [detail*]
#   }

#   set: detail {
#     fields: [
#         id,
#   user_id,
#   sequence_number,
#   session_id,
#   created_at_time,
#   ip_address,
#   city,
#   state,
#   postal_code,
#   browser,
#   traffic_source,
#   uri,
#   event_type,
#   order_sequence,
#   days_between_orders,
#   is_first_purchase,
#   has_subsequent_order,
#   sixty_day_repeat_purchase
#     ]
#   }
# }
