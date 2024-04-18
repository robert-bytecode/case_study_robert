connection: "looker_partner_demo"

# include all the views
# include: "/views/**/*.view.lkml"

datagroup: case_study_robert_ladimir_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

include: "/explores/*.explore.lkml"

persist_with: case_study_robert_ladimir_default_datagroup

# explore: distribution_centers {}

# explore: inventory_items {
#   join: products {
#     type: left_outer
#     sql_on: ${inventory_items.product_id} = ${products.id} ;;
#     relationship: many_to_one
#   }

#   join: distribution_centers {
#     type: left_outer
#     sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
#     relationship: many_to_one
#   }

#   join: order_items {
#     type: left_outer
#     sql_on: $ ${inventory_items.id}= ${order_items.inventory_item_id} ;;
#     relationship: one_to_many
#   }

#   join: users {
#     type: left_outer
#     sql_on: ${order_items.user_id}=${users.id} ;;
#     relationship: many_to_one
#   }

#   join: events {
#     type: left_outer
#     sql_on: ${users.id}= ${events.user_id} ;;
#     relationship: one_to_many
#   }

#   join: users_with_returns {
#     type: left_outer
#     sql_on: ${users.id}=${users_with_returns.user_id_return} ;;
#     relationship: many_to_one
#   }
#   join: sale_price_by_user {
#     type: left_outer
#     sql_on: ${users.id}=${sale_price_by_user.user_id} ;;
#     relationship: one_to_many
#   }
# }

# explore: products {
#   join: distribution_centers {
#     type: left_outer
#     sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
#     relationship: many_to_one
#   }
#   join: order_items {
#     type:  left_outer
#     sql_on: ${products.id}=${order_items.product_id} ;;
#     relationship: one_to_many
#   }

#   join: users {
#     type: left_outer
#     sql_on: ${order_items.user_id}=${users.id} ;;
#     relationship: many_to_one
#   }
#   join: events {
#     type: left_outer
#     sql_on: ${users.id}= ${events.user_id} ;;
#     relationship: one_to_many
#   }
#   join: users_with_returns {
#     type: left_outer
#     sql_on: ${users.id}=${users_with_returns.user_id_return} ;;
#     relationship: many_to_one
#   }
#   join: sale_price_by_user {
#     type: left_outer
#     sql_on: ${users.id}=${sale_price_by_user.user_id} ;;
#     relationship: one_to_many
#   }
# }

# explore: events {
#   join: users {
#     type: left_outer
#     sql_on: ${events.user_id} = ${users.id} ;;
#     relationship: many_to_one
#   }
# }

# explore: order_items {
#   join: users {
#     type: left_outer
#     sql_on: ${order_items.user_id} = ${users.id} ;;
#     relationship: many_to_one
#   }

#   join: inventory_items {
#     type: left_outer
#     sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
#     relationship: many_to_one
#   }

#   join: products {
#     type: left_outer
#     sql_on: ${order_items.product_id} = ${products.id} ;;
#     relationship: many_to_one
#   }

#   join: distribution_centers {
#     type: left_outer
#     sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
#     relationship: many_to_one
#   }

#   join: events {
#     type: left_outer
#     sql_on: ${users.id}= ${events.user_id} ;;
#     relationship: one_to_many
#   }

#   join: users_with_returns {
#     type: left_outer
#     sql_on: ${users.id}=${users_with_returns.user_id_return} ;;
#     relationship: many_to_one
#   }

#   join: sale_price_by_user {
#     type: left_outer
#     sql_on: ${users.id}=${sale_price_by_user.user_id} ;;
#     relationship: one_to_many
#   }
# }

# explore: users {}

# explore: order_items_test {}
