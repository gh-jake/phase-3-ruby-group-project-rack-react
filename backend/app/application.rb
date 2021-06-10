class Application

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)
    if req.path.match(/test/) 
      return [200, { 'Content-Type' => 'application/json' }, [ {:message => "test response!"}.to_json ]]
    elsif req.path.match(/details/) 
      if req.env["REQUEST_METHOD"] == "POST"
        input = JSON.parse(req.body.read)
        contact_id = req.path.split("/")[2]
        contact = Contact.find_by(id: contact_id)
        detail = contact.details.create(info: input["info"], label: input["label"])
        return [200, { 'Content-Type' => 'application/json' }, [ detail.to_json ]]
      elsif req.env["REQUEST_METHOD"] == "DELETE"
        contact_id = req.path.split("/")[2]
        contact = Contact.find_by(id: contact_id)
        detail_id = req.path.split('/details/').last
        contact.details.find_by(id: detail_id).destroy
      end
    elsif req.path.match(/contacts/) 
      if req.env["REQUEST_METHOD"] == "POST"
        input = JSON.parse(req.body.read)
        contact = Contact.create(name: input["name"])
        return [200, { 'Content-Type' => 'application/json' }, [ contact.to_json ]]
      elsif req.env["REQUEST_METHOD"] == "DELETE"
        contact_id = req.path.split("/").last
        Contact.find_by(id: contact_id).destroy
      else
        if req.path.split("/contacts").length == 0
          return [200, { 'Content-Type' => 'application/json' }, [ Contact.all.to_json ]]
        else
          contact_id = req.path.split("/contacts/").last
          return [200, { 'Content-Type' => 'application/json' }, [ Contact.find_by(id: contact_id).to_json({:include => :details}) ]]
        end
      end
    else
      resp.write "Path Not Found"
    end
    resp.finish
  end
end
