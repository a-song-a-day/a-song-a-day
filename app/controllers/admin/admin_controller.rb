class Admin::AdminController < ApplicationController
  before_action :require_login

  layout 'admin'
end
