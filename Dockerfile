# create the build instance
FROM mcr.microsoft.com/dotnet/sdk:9.0-alpine AS build

WORKDIR /src                                                                    
COPY ./src ./

# restore solution
RUN dotnet restore Pandora.Cli.sln

WORKDIR /src/Pandora.Cli

# build and publish project   
RUN dotnet build Pandora.Cli.csproj -c Release -o /app                                         
RUN dotnet publish Pandora.Cli.csproj -c Release -o /app/published

# create the runtime instance 
FROM mcr.microsoft.com/dotnet/aspnet:9.0-alpine AS runtime 

# add globalization support
RUN apk add --no-cache icu-libs
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

WORKDIR /app
                                                            
COPY --from=build /app/published .                         
                            
ENTRYPOINT ["dotnet", "Pandora.Cli.dll"]
