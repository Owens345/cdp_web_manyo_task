class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = if params[:search].present?
      if params[:search][:title].present? && params[:search][:status].present?
        Task.search_title_and_status(params[:search][:title], params[:search][:status])
      elsif params[:search][:title].present?
        Task.search_title(params[:search][:title])
      elsif params[:search][:status].present?
        Task.search_status(params[:search][:status])
      else
        Task.latest
      end
    elsif params[:sort_deadline_on]
      Task.sort_deadline
    elsif params[:sort_priority]
      Task.sort_priority
    else
      Task.latest
    end
    @tasks = @tasks.page(params[:page]).per(10)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
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

  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
  end
end