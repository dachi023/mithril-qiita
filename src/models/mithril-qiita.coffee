m = require 'mithril'

#props
mq =
  endpoint: m.prop null
  token: m.prop null
  background: m.prop false
  initialValue: m.prop undefined

#call api
mq.request = (method, path, params = {}) ->
  throw new Error 'mq.endpoint() is null' if !mq.endpoint()?
  method = method.toUpperCase()
  req =
    config: do ->
      if mq.token()?
        (xhr) -> xhr.setRequestHeader 'Authorization', "Bearer #{mq.token()}"
      else
        (xhr) ->
    method: method
    url: "#{mq.endpoint()}#{path}"
    background: mq.background()
    initialValue: mq.initialValue()
  if method is 'GET'
    req.url += "?#{("#{k}=#{v}" for k, v of params).join '&'}"
  else
    throw new Error 'mq.token() is null' if !mq.token()?
    req.data = params
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

#/items
mq.items = (id = null) ->
  throw new Error 'item-id is null' if !id?
  base = "/api/v2/items/#{id}"
  comments = "#{base}/comments"
  taggings = "#{base}/taggings"
  stockers = "#{base}/stockers"
  like = "#{base}/like"
  stock = "#{base}/stock"
  func =
    get: -> mq.get base
    update: (params) -> mq.patch base, params
    delete: -> mq.delete base
  func.comments =
    list: (params) -> mq.get comments, params
    add: (params) -> mq.post comments, params
  func.taggings =
    add: (params) -> mq.post taggings, params
    delete: (id = null) -> if id? then mq.delete "#{taggings}/#{id}" else throw new Error 'tag-id is null'
  func.stockers =
    list: (params) ->mq.get stockers, params
  func.like =
    add: -> mq.put like
    delete: -> mq.delete like
  func.stock =
    get: (params) -> mq.get stock, params
    add: -> mq.put stock
    delete: -> mq.delete stock
  func

module.exports = mq
