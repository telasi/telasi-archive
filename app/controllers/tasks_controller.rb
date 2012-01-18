# encoding: utf-8
class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.xml
  def index
    @title = 'დავალებები'

    user = get_session_user
    if user.editarchive
      @tasks = Task.paginate :page => params[:page], :order => 'id DESC'
    else
      @tasks = Task.paginate :page => params[:page], :order => 'id DESC', :conditions => ['from_id = ?', user.id]
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @task = Task.find(params[:id])
    @title = @task.subject

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = Task.new
    @title = 'ახალი დავალება'

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
    @title = 'სათაურის შეცვლა'
  end

  # GET /tasks/new_body/1
  # ახალი ტანის დამატება
  def new_body
    @task = Task.find(params[:id])
    @title = 'შენიშვნის დამატება'
    if request.post?
      new_body = params[:new_body]
      close_task = params[:close_task] 
      if new_body.nil? or new_body.empty?
        flash.now[:notice] = 'ჩაწერეთ შენიშვნის ტექსტი'
      else
        user = get_session_user

        if close_task
          @task.status = 'X'
        else
          if user.editarchive
            @task.status = 'C'
          else
            @task.status = 'O'
          end
        end
          
        task_body = TaskBody.new
        task_body.from = user
        task_body.body = new_body
        @task.last_body = new_body
        @task.bodies.push task_body
        @task.save
        
        redirect_to @task, :notice => 'შენიშვნა დამატებული'
      end
    end
  end
  
  # POST /tasks
  # POST /tasks.xml
  def create
    @title = 'ახალი დავალება'

    @task = Task.new(params[:task])
    @task.from = get_session_user
    @task.status = 'O'

    task_body = TaskBody.new
    task_body.from = @task.from
    task_body.body = @task.last_body

    @task.bodies.push task_body

    respond_to do |format|
      if @task.save
        format.html { redirect_to(@task, :notice => 'დავალება გაგზავნილია.') }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = Task.find(params[:id])
    @title = 'სათაურის შეცვლა'

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to(@task, :notice => 'სათაური შეცვლილია.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to(tasks_url) }
      format.xml  { head :ok }
    end
  end

  def print_task
    task = Task.find(params[:id])
    output = TaskReport.new.to_pdf(task)

    respond_to do |format|
      format.pdf do
        send_data(output, :filename => "task_#{task.id}.pdf", :type => :pdf)
      end
    end
  end
end
