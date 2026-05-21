class TasksController < ApplicationController
  before_action :require_login
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :check_task_owner, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = if params[:search].present?
      if params[:search][:title].present? && params[:search][:status].present?
        current_user.tasks.search_title_and_status(params[:search][:title], params[:search][:status])
      elsif params[:search][:title].present?
        current_user.tasks.search_title(params[:search][:title])
      elsif params[:search][:status].present?
        current_user.tasks.search_status(params[:search][:status])
      elsif params[:search][:label].present?
        label = current_user.labels.find_by(id: params[:search][:label])
        label ? label.tasks.where(user: current_user) : current_user.tasks.latest
      else
        current_user.tasks.latest
      end
    elsif params[:sort_deadline_on]
      current_user.tasks.sort_deadline
    elsif params[:sort_priority]
      current_user.tasks.sort_priority
    else
      current_user.tasks.latest
    end
    @tasks = @tasks.page(params[:page]).per(10)
  end
  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: t('flash.task.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to task_path(@task), notice: t('flash.task.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: t('flash.task.destroyed')
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def check_task_owner
    unless @task.user == current_user
      redirect_to tasks_path, alert: 'アクセス権限がありません'
    end
  end

  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status, label_ids: [])
  end
end