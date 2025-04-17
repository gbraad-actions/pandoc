FROM pandoc/core:3.1.1

# Install additional packages if needed
RUN apk add --no-cache bash find

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]