m = require 'mithril'
#props
mq =
  endpoint: m.prop ''
  token: m.prop ''
  background: m.prop false
  initialValue: m.prop undefined

#call api
mq.request = (method, path, params = {}) ->
  method = method.toUpperCase()
  req =
    config: (xhr) -> xhr.setRequestHeader 'Authorization', "Bearer #{mq.token()}"
    method: method
    url: "#{mq.endpoint()}#{path}"
    background: if mq.background()? then mq.background() else false
    initialValue: if mq.initialValue()? then mq.initialValue() else undefined
  if method is 'GET'
    req.url += "?#{("#{k}=#{v}" for k, v of params).join '&'}"
  else
    throw new Error('mq.token() is must not blank') if !mq.token()?
    req.data = req
  m.request req

#request methods
mq.get = (path, params) -> mq.request 'GET', path, params
mq.post = (path, params) -> mq.request 'POST', path, params
mq.patch = (path, params) -> mq.request 'PATCH', path, params
mq.put = (path) -> mq.request 'PUT', path, null
mq.delete = (path) -> mq.request 'DELETE', path, null

#/users
mq.users = (id = null) ->
  base = "/api/v2/users"
  func =
    list: (params) -> mq.get base, params
  if id?
    path = "#{base}/#{id}"
    followers = "#{path}/followers"
    followees = "#{path}/followees"
    following = "#{path}/following"
    followingTags = "#{path}/following_tags"
    items = "#{path}/items"
    stocks = "#{path}/stocks"
    func.list = -> mq.get path
    func.followers =
      list: (params) -> mq.get followers, params
    func.following =
      list: (params) -> mq.get followees, params
      get: (params) -> mq.get following, params
      add: -> mq.put following
      delete: -> mq.delete following
    func.followingTags =
      list: (params) -> mq.get followingTags
    func.items =
      list: (params) -> mq.get items
    func.stocks =
      list: (params) -> mq.get stocks , params
  func

mq.items = (id = null) ->
  #TODO
  #base = "/api/v2/items/#{id}"

module.exports = mq
