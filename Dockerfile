FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY SampleApplication/*.csproj ./SampleApplication/
RUN dotnet restore

# copy everything else and build app
COPY SampleApplication/. ./SampleApplication/
WORKDIR /app/SampleApplication
RUN dotnet publish -c Release -o out
RUN dotnet dev-certs https

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS runtime
WORKDIR /app
COPY --from=build /app/SampleApplication/out ./
ENTRYPOINT ["dotnet", "SampleApplication.dll"]