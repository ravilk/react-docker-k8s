# Pull NodeJS image with tag '16-alpine' from and set custom tag 'builder'. All command after FROM will be reffered to 'builder' phase 
FROM node:16-alpine as builder 

# Set working folder inside of container
WORKDIR '/app'

# Copy files from current host folder to container WORKDIR
COPY package.json .

# Install all dependecies
RUN npm install

# Copy all files from current host folder to container WORKDIR
COPY . .

# Run command to start npm project
CMD ["npm", "run", "build"]

################# End of 'builder' section #################

################# Start of 'runner' section #################
FROM nginx as runner

# Expose listening port to extrenal service
EXPOSE 80

# We need to copy files/folders from another phase. 
# In our case we will:
# Copy folder '/app/build' from prevous(above) phase => 'builder', to the '/usr/share/nginx/html' directory in our nginx container
COPY --from=builder /app/build /usr/share/nginx/html

# Start NGINX 
# NGINX will be started automatically
