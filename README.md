= Enabler

Enabler can enable and disable a site remotely. Here's how it works:

1. You setup an API key for your site in `Radiant::Config['application.api_key']` such as `1eukshp8c4rchbkoep9d4ntbekp4208`
2. Then you post to `yoursite.com/admin/disable/1eukshp8c4rchbkoep9d4ntbekp4208?message=Site%20is%20down.`
3. The site will return all requests with a message such as `Site is down.`

To re-enable a site (the default state) you can post to `yoursite.com/admin/enable/1eukshp8c4rchbkoep9d4ntbekp4208`

Each time you post to enable or disable the cache is cleared. The messages displayed to a visitor when a site is disabled are cached for 24 hours, so your application won't be bogged down by requests.

So that your sites don't reveal whether or not this extension is installed, if you post an invalid api key it will respond with the usual Radiant response for any url. Responding to an invalid key with a 403 (as you might expect from this) would allow someone to scan your site for this url and a 403 response. To avoid that, it'll just render your FileNotFound page.

Built by [Saturn Flyer](http://www.saturnflyer.com)