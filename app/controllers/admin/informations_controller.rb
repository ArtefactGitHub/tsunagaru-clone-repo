class Admin::InformationsController < AdminController
  def new
    @info = Information.new
  end

  def create
    @info = Information.new(information_params)
    if @info.save
      redirect_to admin_root_url, success: 'お知らせを作成しました'
    else
      log_debug @info.errors.full_messages if @info&.errors.present?

      flash.now[:danger] = 'お知らせを作成出来ませんでした'
      render :new
    end
  end

  private

  def information_params
    params.require(:information).permit(:title, :content, :order, :information_type)
  end
end
