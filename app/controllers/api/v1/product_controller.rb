module Api
  module V1
    class ProductController < BaseController

      def index
        products  = Product.all
        if products.present?
          success_json('Products loaded',products)
        else
          failed_json('No Product Available')
        end
      end

      def show
        begin
        product  = Product.find(params[:id])
        success_json('Products loaded',product)
        rescue Exception => e
          failed_json('No Product found for given id',e)
        end
      end

      def create
        product = Product.new
        product.build_product_rate
        product.assign_attributes product_params
        if product.save
          data = {
            product: product,
            product_rate: product.product_rate
          }
          success_json('Product create successful',data)
        else
          failed_json('Product not created',product.errors)
        end
      end

      def update
        product  = Product.find(params[:id])
        if product.update_attributes(product_params)
          data = {
            product: product,
            product_rate: product.product_rate
          }
          success_json('Products updated',data)
        else
          failed_json('Product not updated',product.errors)
        end

      end

      def destroy
        product  = Product.find(params[:id])
        if product.present?
          product.destroy
          success_json('Products Deleted','Product Deleted')
        else
          failed_json('No Product found for given id')
        end
      end

      private

      def product_params
        params.permit(:name, product_rate_attributes: [:rate] )
      end
 
    end
  end
end
