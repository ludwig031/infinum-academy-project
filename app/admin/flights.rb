ActiveAdmin.register Flight do
  permit_params :company_id,
                :name,
                :no_of_seats,
                :base_price,
                :flys_at,
                :lands_at
end
