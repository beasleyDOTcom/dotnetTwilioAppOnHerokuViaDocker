#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.
FROM node:latest AS node_base

RUN echo "NODE Version:" && node --version
RUN echo "NPM Version:" && npm --version

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime
COPY --from=node_base . .
WORKDIR /app
COPY . .
CMD ASPNETCORE_URLS=http://*:$PORT dotnet ShortUrl.dll
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
COPY --from=node_base . .
WORKDIR /src
COPY ["dotnetTwilioAppOnHerokuViaDocker.csproj", "."]
RUN dotnet restore "./dotnetTwilioAppOnHerokuViaDocker.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "dotnetTwilioAppOnHerokuViaDocker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dotnetTwilioAppOnHerokuViaDocker.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dotnetTwilioAppOnHerokuViaDocker.dll"]