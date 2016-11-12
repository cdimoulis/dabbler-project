# Convert the body of a response to JSON
def body_as_json
  str_to_hash(response.body)
end

# Convert a string to JSON
def str_to_hash(str)
  JSON.parse(str)
end
