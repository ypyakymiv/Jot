if response.status != 200
  json.partial! "v1/shared/errors", object: @event
else
  json.merge! @event.attributes
end
