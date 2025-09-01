FROM eclipse-mosquitto:latest

# Copy the configuration file into the container
COPY mosquitto.conf /mqtt/config/mosquitto.conf

# Use a named volume to persist the data and log files
VOLUME ["/mqtt/data", "/mqtt/log"]

# Expose the standard MQTT port
EXPOSE 1883

# Run the Mosquitto broker in the foreground
CMD ["mqtt", "-c", "/mqtt/config/mosquitto.conf"]