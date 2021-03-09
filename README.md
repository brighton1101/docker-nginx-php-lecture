# ITP 405: Deeper Dive into Docker Demo


## Intro:
- In class we have played a bit with Laravel sail, a local development tool powered by Docker
- In the demo, we'll look at a more generalized approach to deploying PHP applications with nginx and a cgi server. This is more popular in the "real" world.
- Don't get caught up too much in the "big words" that are being thrown around. Just know this: `reverse proxy` or `nginx` will refer to a web server that receives the request. `cgi server` or `php-fpm` will be the thing that actually executes our php code for us.
- This demonstration is just meant to be a brief overview of what might go into deploying a Laravel app in production
- I hope you get something out of learning what it takes to build a Dockerfile (the goal is to understand Docker better, not to become an nginx or cgi server expert)


### High level overview on what we will build
- Docker container with our application and two processes running: `nginx` and `php-fpm` that will run on Heroku
- nginx is our reverse proxy server that will handle and forward requests to our cgi server, php-fpm
- php-fpm is our cgi server that will receive the request from nginx and actually run our php application
- important note: general best practices usually say to separate nginx and php-fpm into separate containers - to keep this demonstration simple, we will keep them in one container


### Prerequisites:
- Docker
- Heroku cli


## Background on nginx/reverse proxies/cgi servers

### What is a proxy server and a reverse proxy:
- Proxy server: Intermediarry server that forwards requests from content from multiple clients to different servers (broad)
- Reverse proxy: type of proxy server that forwards requests to the appropriate backend server


### Motivating factors for running a Laravel app in front of a reverse proxy
- <strong>PHP/Laravel's built in development server is not meant for production!</strong>
- Proxying to multiple applications (ie, some requests go to your Laravel app, but others go to a Django app...)
- Logging
- Well known proxy servers such as nginx and Apache are built for a production environment in general: speed, security, configuration provided out of the box. <strong>They abstract lots of concerns away from developers</strong>
- <strong>We will be using nginx as a reverse proxy server</strong>, but don't worry - you will not need any background. If the configuration file looks scary, that's totally ok. You don't need to know what everything means, this is just demonstrating how one might go about deploying containerized Laravel apps in production


### Review the `nginx.conf` file
- Look at the commented block above the `root` property. This points to the `public` subdirectory within our Laravel code
- Look at the `index` property pointing to `index.php`. This is our entrypoint into our application
- Look at the comment block that starts with `CGI stuff`. This is where requests get proxied to our php-fpm cgi server


## Dockerfile pseduo-code
1. Install php-fpm in container
1. Install nginx in container
1. Copy over our app code 
1. Copy over configuration files required
1. Set the default command to first start nginx and then php-fpm

