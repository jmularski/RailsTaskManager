# frozen_string_literal: true

class Project::ProjectController < ApplicationController
  
  def new

    project = new Project
  end

  def show

  end

  def edit_name

  end

  def delete

  end

  def add_to

  end

  private

  def project_params
    params.require(:project).permit(:name, :url, :token)
  end
end