#https://www.makeuseof.com/docker-image-dot-net-web-api/
#https://andrewlock.net/why-isnt-my-aspnetcore-app-in-docker-working/

#Define base image that will be used
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS base
WORKDIR /app
EXPOSE 80
ENV DOTNET_URLS=http://+:5000
ENV DOTNET_RUNNING_IN_CONTAINER=true
ENV Logging__Loglevel__Default=Debug
ENV Logging__Loglevel__Microsoft.AspNetCore=Debug

#Build and publish the code
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# copy all the layers' csproj files into respective folders
COPY ["aspdockerapi.csproj", "./"]

# run restore over API project - this pulls restore over the dependent projects as well
RUN dotnet restore "./aspdockerapi.csproj"

#Copy all the source code into the Build Container
COPY . .

# Run dotnet publish in the Build Container
# Generates output available in /app/build
# Since the current directory is /app
WORKDIR "/src/."
RUN dotnet build "aspdockerapi.csproj" -c Release -o /app/build

# run publish over the API project
FROM build AS publish
RUN dotnet publish "aspdockerapi.csproj" -c Release -o /app/publish

# Second Stage - Pick an Image with only dotnetcore Runtime
FROM base AS final
# Set the Directory as /app
# All consecutive operations happen under /app
WORKDIR /app

# Copy the dlls generated under /app/out of the previous step
# With alias build onto the current directory
# Which is /app in runtime
COPY --from=publish /app/publish .

# Set the Entrypoint for the Container
# Entrypoint is for executables (such as exe, dll)
# Which cannot be overriden by run command
# or docker-compose
ENTRYPOINT ["dotnet", "aspdockerapi.dll"]