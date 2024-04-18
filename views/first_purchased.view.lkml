
view: first_purchased {
  derived_table: {
    sql: with first_activity as (
       SELECT
              user_id, event_type, min(created_at) as first_activity
            FROM events
            -- WHERE event_type='purchase'
            GROUP BY
                1, 2
            ORDER BY
                1, 2
        )
       ,
       first_purchase as (
       select *
       from first_activity
       where event_type='purchase'
       )

      select row_number() over(order by user_id) as pk,
      * ,
        CASE
          WHEN first_activity >= TIMESTAMP(DATETIME_ADD(CURRENT_DATE('America/Los_Angeles'), INTERVAL -90 DAY))
              AND event_type = 'purchase' THEN 'New Customer'
          WHEN first_activity < TIMESTAMP(DATETIME_ADD(CURRENT_DATE('America/Los_Angeles'), INTERVAL -90 DAY))
              AND event_type = 'purchase' THEN 'Long-Term Customer'
          ELSE 'Non-Customer'
        END AS customer_length
      from first_purchase ;;
  }

  dimension: pk {
    type: number
    primary_key: yes
    sql: ${TABLE}.pk ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}.event_type ;;
  }

  dimension_group: first_activity {
    type: time
    sql: ${TABLE}.first_activity ;;
  }

  dimension: customer_length {
    type: string
    sql: ${TABLE}.customer_length ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  set: detail {
    fields: [
      user_id,
      event_type,
      first_activity_time,
      customer_length
    ]
  }
}
