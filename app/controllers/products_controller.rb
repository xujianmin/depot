class ProductsController < ApplicationController
  include ActiveModel::Serializers::Xml

  before_action :set_product, only: %i[ show edit update destroy who_bought ]

  # GET /products or /products.json
  def index
    @products = Product.all
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        puts @product.errors.full_messages
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
        @product.broadcast_replace_later_to "products", partial: "store/product"
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def who_bought
    @orders = []

    # TODO:
    # 这个循环应该有优化的余地
    @product.orders.each do |order|
      line = {}
      line[:order] = order
      line[:quantity] = order.line_items.find_by(product_id: @product.id).quantity
      @orders << line
    end

    respond_to do |format|
      format.html
      format.json { render json: @orders.to_json }
      format.xml { render xml: @orders.to_xml }
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    # @product.destroy!
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_path, status: :see_other, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:title, :description, :image_url, :price)
    end
end
