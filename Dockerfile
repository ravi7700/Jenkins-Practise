# Use a lightweight web server image
FROM nginx:alpine

# Add a simple custom webpage
RUN echo "Hello from Jenkins Automated Build!" > /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80
