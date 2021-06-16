FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY albiondata-api-dotNet/*.csproj ./albiondata-api-dotNet/
WORKDIR /app/albiondata-api-dotNet
RUN dotnet restore

# copy and publish app and libraries
WORKDIR /app/
COPY albiondata-api-dotNet/. ./albiondata-api-dotNet/
WORKDIR /app/albiondata-api-dotNet
RUN dotnet publish -c Release -o out

FROM albiondata/model:latest as models

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS runtime
WORKDIR /app
COPY --from=build /app/albiondata-api-dotNet/out ./
COPY --from=models /app/albiondata-models-dotNet.dll ./
RUN dir
ENTRYPOINT ["dotnet", "albiondata-api-dotNet.dll"]
