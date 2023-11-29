# # Stage 1: Build the app
# FROM node:alpine AS build

# WORKDIR /app

# COPY package.json .
# COPY package-lock.json .

# RUN npm install
# COPY . .
# RUN npm run build

# # Stage 2: Create a minimal production image with Nginx
# FROM nginx:alpine AS production

# WORKDIR /usr/share/nginx/html

# COPY --from=build /app/.next ./.next
# COPY --from=build /app/public ./public

# # COPY nginx.conf /etc/nginx/conf.d/default.conf

# EXPOSE 80

# # Default command, start Nginx
# CMD ["nginx", "-g", "daemon off;"]

# Stage 1: Build the app
FROM node:alpine as build

# copy the package.json to install dependencies
COPY package.json package-lock.json ./

# Install the dependencies and make the folder
RUN npm install && mkdir /tlkt && mv ./node_modules ./tlkt

WORKDIR /tlkt

COPY . .

# Build the project and copy the files
RUN npm run build

# Set correct permissions
RUN chmod -R 777 /tlkt

# NGINX Image Build
FROM nginx:alpine

## Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /tlkt/ /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d/default.conf

# Set correct permissions for Nginx directory
RUN chmod -R 777 /usr/share/nginx/html

# Volumes
# VOLUME /usr/share/nginx/html
# VOLUME /etc/nginx

# Expose port 8080
EXPOSE 8080


# # Use an official Node.js runtime as the parent image
# FROM node:alpine

# # Set the working directory in the container to /app
# WORKDIR /app

# # Copy package.json and package-lock.json to the working directory
# COPY package*.json ./

# # Install the application dependencies
# RUN npm install

# # Copy the rest of the application code to the working directory
# COPY . .

# # Build the application
# RUN npm run build

# # Expose port 3000 for the application
# EXPOSE 3000

# # Start the application
# CMD [ "npm", "start" ]
