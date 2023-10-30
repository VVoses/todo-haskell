# Use a base image with Haskell support
FROM haskell:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the project files to the container
COPY . /app

# Install necessary dependencies
RUN cabal update
RUN cabal install --only-dependencies --lib
RUN cabal install scotty

# Build the Haskell project
RUN cabal build

# Expose the port that your app is listening on
EXPOSE <PORT>

# Specify the command to run your app
CMD ["cabal", "run"]
