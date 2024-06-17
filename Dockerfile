# Dockerfile to build and server the Angular application


###############
### STAGE 1: Build app
###############
FROM node:current as build

WORKDIR /usr/local/app
# Add the source code to app
COPY ./ /usr/local/app/
# Install all the dependencies
RUN npm install
# Generate the build of the application
RUN npm run build

###############
### STAGE 2: Serve app with nginx ###
###############
FROM nginx:1.21.4-alpine
#Define las variables de ambiente
COPY ./nginx.conf /etc/nginx/conf.d/nginx.conf
COPY  --from=build /usr/local/app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 81

# When the container starts, replace the env.js with values from environment variables
# CMD ["/bin/sh",  "-c",  "envsubst < /usr/share/nginx/html/assets/env.sample.js > /usr/share/nginx/html/assets/env.js && exec nginx -g 'daemon off;'"]
#CMD ["nginx" "-g" "daemon off;"]
CMD ["nginx", "-g", "daemon off;"]
