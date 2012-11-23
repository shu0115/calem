# coding: utf-8
class <%= controller_class_name %>Controller < ApplicationController
  #-------#
  # index #
  #-------#
  def index
    @<%= plural_table_name %> = <%= "#{class_name}.where( user_id: session[:user_id] ).all" %>
  end

  #------#
  # show #
  #------#
  def show( id )
    @<%= singular_table_name %> = <%= "#{class_name}.where( id: id, user_id: session[:user_id] ).first" %>
  end

  #-----#
  # new #
  #-----#
  def new
    @<%= singular_table_name %> = <%= orm_class.build( class_name ) %>
  end

  #------#
  # edit #
  #------#
  def edit( id )
    @<%= singular_table_name %> = <%= "#{class_name}.where( id: id, user_id: session[:user_id] ).first" %>
  end

  #--------#
  # create #
  #--------#
  def create( <%= singular_table_name %> )
    @<%= singular_table_name %> = <%= orm_class.build( class_name, " #{singular_table_name} " ) %>
    @<%= "#{singular_table_name}.user_id" %> = <%= "session[:user_id]" %>

    if @<%= orm_instance.save %>
      redirect_to( <%= plural_table_name %>_path, notice: <%= "\"#{human_name} was successfully created.\"" %> )
    else
      render action: "new"
    end
  end

  #--------#
  # update #
  #--------#
  def update( id, <%= singular_table_name %> )
    @<%= singular_table_name %> = <%= "#{class_name}.where( id: id, user_id: session[:user_id] ).first" %>

    if @<%= orm_instance.update_attributes(" #{singular_table_name} ") %>
      redirect_to( <%= singular_table_name %>_path( @<%= singular_table_name %> ), notice: <%= "\"#{human_name} was successfully updated.\"" %> )
    else
      render action: "edit"
    end
  end

  #---------#
  # destroy #
  #---------#
  def destroy( id )
    <%= singular_table_name %> = <%= "#{class_name}.where( id: id, user_id: session[:user_id] ).first" %>
    <%= orm_instance.present? %> ? <%= orm_instance.destroy %> : flash[:alert] = <%= "\"#{human_name} was successfully deleted.\"" %>

    redirect_to <%= plural_table_name %>_path
  end
end
