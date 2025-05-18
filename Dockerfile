FROM tomcat:9.0-jdk11-openjdk

# Remove default webapps to keep image clean (optional)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file to Tomcat webapps folder as ROOT.war (root context)
COPY target/java-app-1.0.war /usr/local/tomcat/webapps/ROOT.war


# Expose Tomcat default port
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]
