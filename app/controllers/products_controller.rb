class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    #@products = Product.all

    @products = Product.find_products_by_locale
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def who_bought
      @product = Product.find(params[:id])
      @latest_order = @product.orders.order(:updated_at).last
      if stale?(@latest_order)
        respond_to do |format|
          format.atom
          format.xml { render( :xml => @product.to_xml(
           :only => [ :title, :updated_at ],
           :skip_types => true,
           :include => {
              :orders => {
                 :except => [ :created_at, :updated_at ],
                 :skip_types => true,
                 :include => {
                    :line_items => {
                       :skip_types => true,
                       :except => [ :created_at, :updated_at, :cart_id, :order_id ]
                    }
                 }
              }
           }
        )) }
          format.json { render json: @product.to_json(:include => :orders) }
          format.html #who_bought.html.erb
        end
      end
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :description, :image_url, :price, :locale)
    end


end
