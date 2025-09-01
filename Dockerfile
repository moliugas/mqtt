FROM eclipse-mosquitto:latest

# Copy the configuration file into the container
COPY config/mosquitto.conf /mosquitto/config/mosquitto.conf

# Use a named volume to persist the data and log files
VOLUME ["/mosquitto/data", "/mosquitto/log"]

# Expose the standard MQTT port
EXPOSE 1883

# Run the Mosquitto broker in the foreground
CMD ["mosquitto", "-c", "/mosquitto/config/mosquitto.conf"]
