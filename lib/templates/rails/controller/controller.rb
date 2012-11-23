# coding: utf-8
class <%= class_name %>Controller < ApplicationController

<% actions.each do |action| -%>
  #--#
  #  #
  #--#
  def <%= action %>
  end

<% end -%>
end
