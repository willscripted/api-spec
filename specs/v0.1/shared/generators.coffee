
uuid = require('node-uuid')
Promise = require('es6-promise').Promise
request = require('superagent')

email = () ->
  "#{uuid.v4()}@example.com"


# Create a new user with password (default: random)
# Returns a promise which resolves to the new user's email
user = (password) ->
  pw = password ||= Math.random().toString()
  addr = email()
  return new Promise((resolve, reject) ->
    request
      .post("#{process.env.API_PATH}/sign-up")
      .send({"email": addr, "url": "http://herp.derp.co/&&{token}"})
      .end (err, resp) ->
        token = resp["body"]["url"].split('&&')[1]
        request.post("#{process.env.API_PATH}/sign-up/#{token}")
          .send({"email": addr, "password": pw})
          .end((err, resp) ->
            resolve(addr)
          )
  )

module.exports = {
  email: email,
  user: user
}
