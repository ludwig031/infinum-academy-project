class CompanyPolicy < ApplicationPolicy
  attr_reader :user, :company

  def initialize(user, company)
    @user = user
    @company = company
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
