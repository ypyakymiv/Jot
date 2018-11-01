if response.status != 200
  json.partial! "v1/shared/errors", object: @user
else
  json.merge! @user.attributes
end
