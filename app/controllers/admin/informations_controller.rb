class Admin::InformationsController < AdminController
  include LoggerModule

  def index
    @infos = Information.all
  end

  def new
    @info = Information.new
  end

  def create
    @info = Information.new(information_params)
    if @info.save
      redirect_to new_admin_information_url, success: 'お知らせを作成しました'
    else
      log_debug @info.errors.full_messages if @info&.errors.present?

      flash.now[:danger] = 'お知らせを作成出来ませんでした'
      render :new
    end
  end

  def destroy
    @info = Information.find(params[:id])
    @info.destroy
    redirect_to admin_informations_url, success: 'お知らせを削除しました'
  end

  private

  def information_params
    params.require(:information).permit(:display_time, :title, :content, :order, :information_type)
  end
end
