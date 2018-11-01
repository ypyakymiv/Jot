if response.status != 200
  json.partial! "v1/shared/errors", object: @comment
else
  json.merge! @comment.attributes
end
