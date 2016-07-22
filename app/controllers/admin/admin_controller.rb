class Admin::AdminController < ApplicationController
  before_action :require_login

  layout 'admin'
  
  private

  def crumb(name, path)
    crumbs.push(Crumb.new(name, path))
  end

  helper_method :crumb

  def crumbs
    @crumbs ||= []
  end

  helper_method :crumbs
end
