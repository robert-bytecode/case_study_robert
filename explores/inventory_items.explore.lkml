include: "/views/**/*.view.lkml"

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: order_items {
    type: left_outer
    sql_on:  ${inventory_items.id}= ${order_items.inventory_item_id} ;;
    relationship: one_to_many
  }

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id}=${users.id} ;;
    relationship: many_to_one
  }

  join: events {
    type: left_outer
    sql_on: ${users.id}= ${events.user_id} ;;
    relationship: one_to_many
  }

  join: users_with_returns {
    type: left_outer
    sql_on: ${users.id}=${users_with_returns.user_id_return} ;;
    relationship: many_to_one
  }
  join: sale_price_by_user {
    type: left_outer
    sql_on: ${users.id}=${sale_price_by_user.user_id} ;;
    relationship: one_to_many
  }
  join: orders_aggregated {
    type: left_outer
    sql_on: ${order_items.user_id}=${orders_aggregated.user_id} ;;
    relationship: many_to_one
  }
  join: repeat_customers {
    type: left_outer
    sql_on: ${order_items.user_id}=${repeat_customers.user_id} ;;
    relationship: many_to_one
  }
  join: last_order {
    type: left_outer
    sql_on: ${order_items.user_id}=${last_order.id} ;;
    relationship: many_to_one
  }
  join: order_sequence {
    type: left_outer
    sql_on: ${events.id}= ${order_sequence.id} ;;
    relationship: one_to_one
  }
  join: category_averages {
    type: left_outer
    sql_on: ${products.category}=${category_averages.category} ;;
    relationship: many_to_one
  }
  join: cv_category_averages {
    type: left_outer
    sql:;;
  relationship: one_to_one
}
}
