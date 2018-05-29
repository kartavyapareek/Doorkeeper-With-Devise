module Api
  module V1
    class OrderController < BaseController

      def index
        orders = Order.where(user_id: d_current_user.id)
        data = []
        orders.each { |order|
          products = order.order_products.map { |p| { product_name: p.product.name} }
          data << {
            order_id: order.id,
            name: order.name,
            order_product: products,
          }
        }
        if orders.present?
          message = 'Orders loaded'
          success_json('Orders loaded',data)
        else
          message = 'No Order Available'
          failed_json('No Order Available')
        end
      end

      def show
        begin
          order = Order.find_by(params[:id])
          products = order.order_products.map { |p| { product_name: p.product.name} }
          data = {
            order: {
              id: order.id,
              name: order.name,
              order_product: products,
            }
          }
          success_json('Order loaded',data)
        rescue Exception => e
          failed_json('No Order Available')
        end
      end

      def create
        ActiveRecord::Base.transaction do
          @order = Order.new order_params
          @order.user_id = d_current_user.id
          @order.save
          products = Product.find(params[:product_attributes][:id])
          order_products = []
          products.each{ |product| 
           order_products << OrderProduct.create(product_id: product.id, order_id: @order.id, user_id: d_current_user.id)
          }
          @order.order_products.push(order_products)
        end
        if @order.present?
          CustomerSideMailer.order_confirm_mail(@order).deliver_now
          if @order.user.user_profile.present?
            ClientMessenger.order_confirm_sms(phone: @order.user.user_profile.phone).deliver_later
          end
          products = @order.order_products.map { |p| { product_name: p.product.name} }
          data = {
            order: {
              id: @order.id,
              name: @order.name,
              order_product: products,
            }
          }
          message = 'Order create successful'
          success_json('Order create successful',data)
        else
          failed_json('Order not created')
        end
        rescue StandardError => error
          failed_json('Failed to create order',error.message)
      end

      def show_user_all_products
        order_products = OrderProduct.where(user_id: d_current_user.id)
        if order_products.present?
          products = order_products.map { |p| { product_id: p.id, product_name: p.product.name} }
          data = {
              product: products,
            }
            success_json('User products loaded',data)
        else
          failed_json('User products not loaded')
        end
      end

      def show_user_single_product
        begin
          order_product = OrderProduct.where(product_id: params[:id])
          if order_product.present?
            product = Product.find(order_product.first.product.id)
          data = {
              product_id: product.id,
              product_name: product.name,
              product_rate: product.product_rate.rate
            }
          end
          success_json('User products loaded',data)
        rescue Exception => e
          failed_json('User products not loaded',e)
        end
      end

      private
      def order_params
        params.permit(:name)
      end
 
    end
  end
end
