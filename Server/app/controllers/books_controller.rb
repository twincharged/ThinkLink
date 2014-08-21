class BooksController < ApplicationController
  before_action :set_book, except: [:create, :index]

  # GET /books/1
  def show
    respond_with @book
  end

  # GET /books/1/assembly
  def assembly
    respond_with @book.assembly
  end

  # GET /books/1/users
  def users
    respond_with @book.users
  end

  # GET /books/1/units
  def units
    respond_with @book.units
  end

  # POST /books
  def create
    @book = Book.new(book_params)

    if @book.save
      respond_with @book
    else
      render json: {error: @book.errors}
    end
  end

  # PATCH/PUT /books/1
  def update
    if @book.update(book_params)
      redirect_to @book, notice: 'Book was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /books/1
  def destroy
    @book.destroy
    redirect_to books_url, notice: 'Book was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def book_params
      params.require(:book).permit(:title, :assembly_id)
    end
end
