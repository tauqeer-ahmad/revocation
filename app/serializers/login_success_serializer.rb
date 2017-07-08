class LoginSuccessSerializer < ActiveModel::Serializer
  attributes :name, :email, :access_token, :category
end
